// edit_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // controllers for fields requested
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _gender = '';
  bool _loading = true;
  bool _saving = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fire = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadProfileFromFirebase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileFromFirebase() async {
    setState(() => _loading = true);
    try {
      _user = _auth.currentUser;
      if (_user == null) {
        _showSnack('No signed-in user.');
        setState(() => _loading = false);
        return;
      }

      // Prefill basic auth values (email / displayName)
      _emailController.text = _user!.email ?? '';
      _usernameController.text = _user!.displayName ?? '';

      // Fetch Firestore users/{uid} doc (signup writes this)
      final docRef = _fire.collection('users').doc(_user!.uid);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data()!;
        _usernameController.text =
            (data['username'] ?? _usernameController.text);
        _emailController.text = (data['email'] ?? _emailController.text);
        _nameController.text = (data['fullName'] ?? data['name'] ?? '');
        _phoneController.text = (data['phone'] ?? '');
        _gender = (data['gender'] ?? '');
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      _showSnack('Failed to load profile.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Shows a dialog to ask for the current password and returns it (or null).
  Future<String?> _showPasswordDialog() async {
    final TextEditingController pwController = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirm Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('To change your email, please confirm your password.'),
              const SizedBox(height: 12),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Current password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(pwController.text);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    pwController.dispose();
    return result;
  }

  Future<void> _handleSave() async {
    // ensure we have a user loaded
    _user ??= _auth.currentUser;
    if (_user == null) {
      _showSnack('No signed-in user.');
      return;
    }

    final newName = _nameController.text.trim();
    final newUsername = _usernameController.text.trim();
    final newPhone = _phoneController.text.trim();
    final newEmail = _emailController.text.trim();
    final newGender = _gender;

    if (newUsername.isEmpty || newEmail.isEmpty) {
      _showSnack('Please fill username and email.');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(newEmail)) {
      _showSnack('Please enter a valid email address.');
      return;
    }

    setState(() => _saving = true);

    try {
      // Update FirebaseAuth displayName if changed
      if (newUsername != (_user!.displayName ?? '')) {
        await _user!.updateDisplayName(newUsername);
      }

      // Update FirebaseAuth email if changed
      if (newEmail != (_user!.email ?? '')) {
        try {
          // Attempt fast update (works if the current sign-in is "recent")
          await _user!.updateEmail(newEmail);
        } on FirebaseAuthException catch (e) {
          // If requires recent login -> prompt for password and reauthenticate
          if (e.code == 'requires-recent-login') {
            final password = await _showPasswordDialog();
            if (password == null || password.isEmpty) {
              _showSnack('Password required to change email.');
              setState(() => _saving = false);
              return;
            }

            // create credential and reauthenticate
            try {
              final cred = EmailAuthProvider.credential(
                email: _user!.email!,
                password: password,
              );
              await _user!.reauthenticateWithCredential(cred);
              // after successful reauth try updating email again
              await _user!.updateEmail(newEmail);
            } on FirebaseAuthException catch (reauthErr) {
              // common reauth errors
              if (reauthErr.code == 'wrong-password') {
                _showSnack('Incorrect password. Please try again.');
              } else if (reauthErr.code == 'user-mismatch' ||
                  reauthErr.code == 'user-not-found') {
                _showSnack('Unable to reauthenticate the user.');
              } else {
                _showSnack(reauthErr.message ?? 'Reauthentication failed.');
              }
              setState(() => _saving = false);
              return;
            } catch (reauthErr) {
              debugPrint('Reauth unexpected: $reauthErr');
              _showSnack('Failed to reauthenticate. Please login again.');
              setState(() => _saving = false);
              return;
            }
          } else if (e.code == 'invalid-email') {
            _showSnack('The email address is not valid.');
            setState(() => _saving = false);
            return;
          } else if (e.code == 'email-already-in-use') {
            _showSnack('This email is already in use by another account.');
            setState(() => _saving = false);
            return;
          } else if (e.code == 'operation-not-allowed') {
            _showSnack(
              'Email/Password sign-in is disabled in Firebase Console. Enable it to change email.',
            );
            setState(() => _saving = false);
            return;
          } else {
            // rethrow to be caught by outer catch
            rethrow;
          }
        }
      }

      // Persist to Firestore (merge so we don't overwrite other fields)
      final docRef = _fire.collection('users').doc(_user!.uid);
      await docRef.set({
        'fullName': newName,
        'username': newUsername,
        'phone': newPhone,
        'email': newEmail,
        'gender': newGender,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Refresh local user
      await _user!.reload();
      _user = _auth.currentUser;

      _showSnack('Profile updated successfully.');
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? 'Auth error: ${e.code}');
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
    } catch (e) {
      _showSnack('Failed to save profile.');
      debugPrint('Save profile error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (same layout you used)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.kronaOne(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Name
                    Text(
                      'Name',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration(hint: 'Enter your name'),
                    ),
                    const SizedBox(height: 18),

                    // Username
                    Text(
                      'Username',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _usernameController,
                      decoration: _inputDecoration(hint: 'Enter your username'),
                    ),
                    const SizedBox(height: 18),

                    // Gender
                    Text(
                      'Gender',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _gender.isEmpty ? null : _gender,
                          hint: const Text('Select Gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                            DropdownMenuItem(
                              value: 'Prefer not to say',
                              child: Text('Prefer not to say'),
                            ),
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Phone
                    Text(
                      'Phone Number (Recovery)',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(hint: 'Enter phone number'),
                    ),
                    const SizedBox(height: 18),

                    // Email
                    Text(
                      'Email Address',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(hint: 'Enter your email'),
                    ),

                    const SizedBox(height: 30),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9747FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
      ),
    );
  }
}

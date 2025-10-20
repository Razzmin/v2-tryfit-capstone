import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import all pages directly
import 'homepage.dart';
import 'edit_profile.dart';
import 'edit_body_measurement.dart';
import 'notification.dart';
import 'shipping_location.dart';
import 'change_password.dart';
import 'login.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showDeleting = false;

  void _goBackToHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Homepage()),
    );
  }

  // ✅ Navigate directly to each page
  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // ✅ Delete Account Logic (Firebase)
  Future<void> _deleteAccount() async {
    try {
      setState(() => _showDeleting = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete Firestore user data (if exists)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete()
            .catchError((_) {});

        // Delete Authentication account
        await user.delete();

        // Sign out the user
        await FirebaseAuth.instance.signOut();
      }

      setState(() => _showDeleting = false);

      // Navigate back to login
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _showDeleting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete account: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Confirmation Dialog before delete
  Future<void> _showDeleteAccountDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete Your Account?'),
        content: const Text(
          'Are you sure you want to delete your account?\n'
          'This action is permanent and cannot be undone.\n\n'
          'All your data including:\n'
          '• Order history\n'
          '• Preferences\n'
          '• Personal information\n\n'
          'will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9747FF)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9747FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3), // ✅ near square corners
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white, // ✅ white text
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteAccount();
    }
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return InkWell(
      onTap: () => _navigateToPage(page),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: const Color(0xFF9747FF), size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF333333),
                  letterSpacing: 1,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _goBackToHomepage,
                        child: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Profile',
                        style: GoogleFonts.kronaOne(
                          fontSize: 26,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Centered avatar
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const NetworkImage(
                        'https://placehold.co/100x100?text=User',
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      'Your Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // MENU ITEMS
                  Column(
                    children: [
                      _menuItem(
                        icon: FontAwesomeIcons.user,
                        label: 'Edit Profile',
                        page: const EditProfile(),
                      ),
                      _menuItem(
                        icon: FontAwesomeIcons.edit,
                        label: 'Edit Body Measurement',
                        page: const EditBodyMeasurement(),
                      ),
                      _menuItem(
                        icon: FontAwesomeIcons.bell,
                        label: 'Notification',
                        page: const NotificationPage(),
                      ),
                      _menuItem(
                        icon: FontAwesomeIcons.mapMarker,
                        label: 'Shipping Location',
                        page: const ShippingLocation(),
                      ),
                      _menuItem(
                        icon: FontAwesomeIcons.lock,
                        label: 'Change Password',
                        page: const ChangePassword(),
                      ),
                      const SizedBox(height: 6),

                      // DELETE ACCOUNT (main menu)
                      InkWell(
                        onTap: _showDeleteAccountDialog,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.trash,
                                color: Color(0xFF9747FF),
                                size: 20,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF333333),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SIGN OUT BUTTON
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9747FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            if (_showDeleting)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF9747FF)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

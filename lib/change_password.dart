import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> handleSetPassword() async {
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showAlert('Error', 'Please fill in all password fields.');
      return;
    }

    if (newPassword != confirmPassword) {
      showAlert('Error', 'New passwords do not match.');
      return;
    }

    if (newPassword.length < 6) {
      showAlert('Error', 'New password should be at least 6 characters.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = _auth.currentUser;

      if (user == null || user.email == null) {
        showAlert('Error', 'No user found. Please log in again.');
        return;
      }

      // Re-authenticate the user before changing password
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      showAlert('Success', 'Your password has been successfully changed.');
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'wrong-password':
          message = 'Your current password is incorrect.';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters.';
          break;
        case 'requires-recent-login':
          message = 'Please log in again and try changing your password.';
          break;
        case 'user-not-found':
          message = 'User not found.';
          break;
        default:
          message = 'An error occurred: ${e.message}';
      }
      showAlert('Error', message);
    } catch (e) {
      showAlert('Error', 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Enter new password below to change your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF9747FF), fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Current Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  passwordInput(currentPasswordController, showCurrent, () {
                    setState(() => showCurrent = !showCurrent);
                  }),

                  const Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  passwordInput(newPasswordController, showNew, () {
                    setState(() => showNew = !showNew);
                  }),

                  const Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  passwordInput(confirmPasswordController, showConfirm, () {
                    setState(() => showConfirm = !showConfirm);
                  }),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleSetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A5AF8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "SET",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF9747FF)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget passwordInput(
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 6),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindful/login_page.dart';
import 'package:mindful/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Add this import

import 'app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;  // Add Firestore instance

  // Variables to store values
  String firstname = "";
  String lastname = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String errorMessage = '';
  bool showError = false;

  // Controllers
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 70),

              Text(
                "Let's Get Started!",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Create an account on Mindfull \n           to get all features',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              /// FIRSTNAME
              CustomTextField(
                controller: firstnameController,
                hint: "Firstname",
                icon: Icons.person_outline_outlined,
                onChanged: (value) {
                  setState(() => firstname = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 30),

              /// LASTNAME
              CustomTextField(
                controller: lastnameController,
                hint: "Lastname",
                icon: Icons.person_outline_outlined,
                onChanged: (value) {
                  setState(() => lastname = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 30),

              /// PHONE NUMBER
              CustomTextField(
                controller: phoneNumberController,
                hint: "Phone Number",
                icon: Icons.phone_outlined,
                onChanged: (value) {
                  setState(() => phoneNumber = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 30),

              /// EMAIL
              CustomTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                onChanged: (value) {
                  setState(() => email = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 30),

              /// PASSWORD
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (value) {
                  setState(() => password = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 30),

              /// CONFIRM PASSWORD
              CustomTextField(
                controller: confirmPasswordController,
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (value) {
                  setState(() => confirmPassword = value);
                  if (showError) {
                    setState(() => showError = false);
                  }
                },
              ),

              const SizedBox(height: 20),

              // Error Message Display
              if (showError)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: GoogleFonts.inter(
                            color: Colors.red.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              /// CREATE BUTTON
              GestureDetector(
                onTap: () async {
                  // Validation
                  if (firstname.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter your first name';
                      showError = true;
                    });
                    return;
                  }

                  if (lastname.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter your last name';
                      showError = true;
                    });
                    return;
                  }

                  if (phoneNumber.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter your phone number';
                      showError = true;
                    });
                    return;
                  }

                  if (email.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter your email';
                      showError = true;
                    });
                    return;
                  }

                  if (password.isEmpty) {
                    setState(() {
                      errorMessage = 'Please enter a password';
                      showError = true;
                    });
                    return;
                  }

                  if (password.length < 6) {
                    setState(() {
                      errorMessage = 'Password must be at least 6 characters';
                      showError = true;
                    });
                    return;
                  }

                  if (confirmPassword.isEmpty) {
                    setState(() {
                      errorMessage = 'Please confirm your password';
                      showError = true;
                    });
                    return;
                  }

                  if (password != confirmPassword) {
                    setState(() {
                      errorMessage = 'Passwords do not match';
                      showError = true;
                    });
                    return;
                  }

                  try {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Create user with Firebase Authentication
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email.trim(),
                      password: password.trim(),
                    );

                    // Save user data to Firestore
                    if (newUser.user != null) {
                      String userId = newUser.user!.uid;

                      // Update display name
                      await newUser.user!.updateDisplayName('$firstname $lastname');

                      // Save to Firestore
                      await _firestore.collection('users').doc(userId).set({
                        'firstName': firstname.trim(),
                        'lastName': lastname.trim(),
                        'phoneNumber': phoneNumber.trim(),
                        'email': email.trim(),
                        'fullName': '${firstname.trim()} ${lastname.trim()}',
                        'createdAt': FieldValue.serverTimestamp(),
                        'userId': userId,
                      });

                      print('User data saved to Firestore successfully!');
                    }

                    // Close loading dialog
                    if (mounted) Navigator.pop(context);

                    // Navigate to chat
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/chat');
                    }
                  } on FirebaseAuthException catch (e) {
                    // Close loading dialog
                    if (mounted) Navigator.pop(context);

                    String message = '';

                    switch (e.code) {
                      case 'email-already-in-use':
                        message = 'This email is already registered';
                        break;
                      case 'invalid-email':
                        message = 'Invalid email format';
                        break;
                      case 'weak-password':
                        message = 'Password is too weak';
                        break;
                      case 'operation-not-allowed':
                        message = 'Registration is currently disabled';
                        break;
                      default:
                        message = e.message ?? 'Registration failed';
                    }

                    setState(() {
                      errorMessage = message;
                      showError = true;
                    });
                  } catch (e) {
                    // Close loading dialog
                    if (mounted) Navigator.pop(context);

                    print('Error: $e');
                    setState(() {
                      errorMessage = 'An error occurred. Please try again';
                      showError = true;
                    });
                  }
                },
                child: Container(
                  width: 199,
                  height: 53,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'CREATE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Already have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ?",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
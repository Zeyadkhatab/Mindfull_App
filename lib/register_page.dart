import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindful/login_page.dart';
import 'package:mindful/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = FirebaseAuth.instance; // this is a request to register a new user

  // Variables to store values
  String firstname = "";
  String lastname = "";
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";



  // Controllers (must NOT be inside build)
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();



  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
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
                onChanged: (value) => setState(() => firstname = value),
              ),

              const SizedBox(height: 30),

              /// LASTNAME
              CustomTextField(
                controller: lastnameController,
                hint: "Lastname",
                icon: Icons.person_outline_outlined,
                onChanged: (value) => setState(() => lastname = value),
              ),

              const SizedBox(height: 30),

              /// USERNAME
              CustomTextField(
                controller: usernameController,
                hint: "Username",
                icon: Icons.person_outline_outlined,
                onChanged: (value) => setState(() => username = value),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              CustomTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                onChanged: (value) => setState(() => email = value),
              ),

              const SizedBox(height: 30),

              /// PASSWORD
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (value) => setState(() => password = value),
              ),

              const SizedBox(height: 30),

              /// CONFIRM PASSWORD
              CustomTextField(
                controller: confirmPasswordController,
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                obscureText: true,
                onChanged: (value) => setState(() => confirmPassword = value),
              ),

              const SizedBox(height: 40),

              /// CREATE BUTTON
              GestureDetector(
                onTap: () async {
                try{
                  final newUser =  await  _auth.createUserWithEmailAndPassword(email: email, password: password);
                  Navigator.pushNamed(context, '/chat');
                }
                catch(e){
                  print(e);
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

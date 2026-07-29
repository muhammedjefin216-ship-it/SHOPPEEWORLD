// import 'package:flutter/material.dart';
// import 'package:shoppee_world/widgets/textfields/password_field.dart';
// import '../../../core/constants/app_sizes.dart';
// import '../../../widgets/auth/auth_divider.dart';
// import '../../../widgets/auth/auth_header.dart';
// import '../../../widgets/auth/bottom_auth_text.dart';
// import '../../../widgets/buttons/google_button.dart';
// import '../../../widgets/buttons/primary_button.dart';
// import '../../../widgets/textfields/custom_text_field.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool agreeTerms = false;

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void createAccount() {
//     if (!_formKey.currentState!.validate()) return;

//     if (!agreeTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please accept Terms & Conditions"),
//         ),
//       );
//       return;
//     }

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(
//               left: AppSizes.screenPadding,
//               right: AppSizes.screenPadding,
//               top: 20,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//             ),
//             child: Form(
//               key: _formKey,
//               child: AutofillGroup(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),

//                     const AuthHeader(
//                       title: "Create Account",
//                       subtitle: "Create your account to continue",
//                     ),

//                     const SizedBox(height: 45),

//                     CustomTextField(
//                       controller: fullNameController,
//                       hintText: "Full Name",
//                       prefixIcon: Icons.person_outline,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Enter your full name";
//                         }
//                         if (value.trim().length < 3) {
//                           return "Minimum 3 characters";
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     CustomTextField(
//                       controller: emailController,
//                       hintText: "Email Address",
//                       prefixIcon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       autofillHints: const [
//                         AutofillHints.email,
//                       ],
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Enter your email";
//                         }

//                         if (!value.contains("@")) {
//                           return "Invalid email";
//                         }

//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     PasswordTextField(
//                       controller: passwordController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Enter password";
//                         }

//                         if (value.length < 6) {
//                           return "Minimum 6 characters";
//                         }

//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     PasswordTextField(
//                       controller: confirmPasswordController,
//                       hintText: "Confirm Password",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Confirm your password";
//                         }

//                         if (value != passwordController.text) {
//                           return "Passwords do not match";
//                         }

//                         return null;
//                       },
//                     ),

//                                         const SizedBox(height: 20),

//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                           value: agreeTerms,
//                           activeColor: Colors.black,
//                           onChanged: (value) {
//                             setState(() {
//                               agreeTerms = value ?? false;
//                             });
//                           },
//                         ),

//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 12),
//                             child: RichText(
//                               text: const TextSpan(
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 14,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: "I agree to the ",
//                                   ),
//                                   TextSpan(
//                                     text: "Terms & Conditions",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: " and ",
//                                   ),
//                                   TextSpan(
//                                     text: "Privacy Policy",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     PrimaryButton(
//                       text: "CREATE ACCOUNT",
//                       onPressed: createAccount,
//                     ),

//                     const SizedBox(height: 30),

//                     const AuthDivider(),

//                     const SizedBox(height: 30),

//                     GoogleButton(
//                       onPressed: () {
//                         // Google Sign Up
//                       },
//                     ),

//                     const SizedBox(height: 35),

//                     BottomAuthText(
//                       title: "Already have an account?",
//                       buttonText: "Login",
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shoppee_world/widgets/textfields/password_field.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_divider.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/bottom_auth_text.dart';
import '../../../widgets/buttons/google_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/textfields/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agreeTerms = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void createAccount() {
    if (!_formKey.currentState!.validate()) return;

    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept Terms & Conditions"),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image.asset(
                  "assets/images/signup.jpg", // Change to your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // White Overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Main Content
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        const AuthHeader(
                          title: "Create Account",
                          subtitle: "Create your account to continue",
                        ),

                        const SizedBox(height: 45),

                        CustomTextField(
                          controller: fullNameController,
                          hintText: "Full Name",
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter your full name";
                            }
                            if (value.trim().length < 3) {
                              return "Minimum 3 characters";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: emailController,
                          hintText: "Email Address",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter your email";
                            }

                            if (!value.contains("@")) {
                              return "Invalid email";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        PasswordTextField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter password";
                            }

                            if (value.length < 6) {
                              return "Minimum 6 characters";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        PasswordTextField(
                          controller: confirmPasswordController,
                          hintText: "Confirm Password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm your password";
                            }

                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeTerms,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  agreeTerms = value ?? false;
                                });
                              },
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "I agree to the ",
                                      ),
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " and ",
                                      ),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        PrimaryButton(
                          text: "CREATE ACCOUNT",
                          onPressed: createAccount,
                        ),

                        const SizedBox(height: 30),

                        const AuthDivider(),

                        const SizedBox(height: 30),

                        GoogleButton(
                          onPressed: () {
                            // Google Sign Up
                          },
                        ),

                        const SizedBox(height: 35),

                        BottomAuthText(
                          title: "Already have an account?",
                          buttonText: "Login",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final profileNameController = TextEditingController();
    final mailController = TextEditingController();
    final passwordControler = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Consumer<UserManager>(builder: (context, userManager, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Flexible(
                flex: 2,
                child: Center(
                  child: Text(
                    "facebook",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == '' || value!.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(label: Text("Name")),
                      ),
                      TextFormField(
                        controller: profileNameController,
                        validator: (value) {
                          if (value == '' || value!.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text("Profile Name")),
                      ),
                      TextFormField(
                        controller: mailController,
                        validator: (value) {
                          if (value == '' || value!.isEmpty) {
                            return "Required";
                          } else if (!value.endsWith('@gmail.com')) {
                            return "Invalid mail";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(label: Text("Mail")),
                      ),
                      TextFormField(
                        controller: passwordControler,
                        obscureText: true,
                        validator: (value) {
                          if (value == '' || value!.isEmpty) {
                            return "Required";
                          } else if (value.length < 8) {
                            return "Please enter at least 8 characters";
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text("Password")),
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != passwordControler.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("Confirm Password")),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            User newUser = User(
                              realName: nameController.text,
                              profileName: profileNameController.text,
                              mail: mailController.text,
                              password: passwordControler.text,
                              createdTime: DateTime.now(),
                              updatedTime: DateTime.now(),
                            );
                            userManager.signUpUser(newUser);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Signed up successfully'),
                              action: SnackBarAction(
                                label: 'Log in now',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ));
                          }
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text('Sign up'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ),
        ),
      );
    });
  }
}

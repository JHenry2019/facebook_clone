import 'package:facebook_clone/pages/sign_up_page.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final mailInputController = TextEditingController();
    final passwordInputController = TextEditingController();

    return Consumer<UserManager>(builder: (context, userManager, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(children: [
            const Flexible(
              flex: 4,
              child: Center(
                child: Icon(
                  Icons.facebook,
                  size: 50,
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
                      controller: mailInputController,
                      validator: (value) {
                        if (value == '' || value!.isEmpty) {
                          return "Required";
                        } else if (!value.endsWith("@gmail.com")) {
                          return "Enter a valid mail";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Mail'),
                      ),
                    ),
                    TextFormField(
                      controller: passwordInputController,
                      obscureText: true,
                      validator: (value) {
                        if (value == '' || value!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          userManager.logInUser(mailInputController.text,
                              passwordInputController.text, context);
                        }
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text('Log in'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
            Flexible(
              flex: 3,
              child: Container(),
            ),
            TextButton(
              onPressed: () {
                formKey.currentState?.reset();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpPage()));
              },
              child: const Text('Create a new account'),
            ),
            const Flexible(
              flex: 1,
              child: Center(child: Text('Meta')),
            ),
          ]),
        ),
      );
    });
  }
}

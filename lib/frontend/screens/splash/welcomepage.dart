import 'package:calaroiscount/auth/loginPage.dart';
import 'package:calaroiscount/auth/signup.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kapp,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(46.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Let's Get Started",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                Image.asset(
                  "assets/images/chef.png",
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Image not found',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blueAccent,
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat/main.dart';
import 'package:my_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    });
  } // For log in with google btn

// this code taken from sign_in_with_google Page
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Welcome to My Chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            child: Image.asset(
              'images/chat.png',
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              //* note this style of elevated button
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 1,
                  backgroundColor: Colors.blue.shade200),
              onPressed: () {
                _handleGoogleBtnClick();
              },
              icon: Image.asset(
                'images/google.png',
                height: mq.height * .05,
              ),
              label: RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 19, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Sign in with '),
                      TextSpan(
                        text: 'Google',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

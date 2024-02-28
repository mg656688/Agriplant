import 'package:agriplant/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is already signed in
    if (FirebaseAuth.instance.currentUser != null) {
      // User is already signed in, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  const HomePage(),
        ),
      );
      return Container(); // Return an empty container as the widget is replaced
    }

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/onboarding.png'),
              ),
              const Spacer(),
              Text('Welcome to AgriPlant',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "Get your agriculture products from the comfort of your home. You're just a few clicks away from your favorite products.",
                  textAlign: TextAlign.center,
                ),
              ),
              /**/
              FilledButton.tonalIcon(
                onPressed: () => signUpWithGoogle(context),
                icon: const Icon(IconlyLight.login),
                label: const Text("Continue with Google"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<UserCredential?> signUpWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  const HomePage(),
      ),
    );

    return userCredential;
  } catch (e) {
    // Handle any errors during the sign-in process
    if (kDebugMode) {
      print("Error signing in with Google: $e");
    }
    return null;
  }
}

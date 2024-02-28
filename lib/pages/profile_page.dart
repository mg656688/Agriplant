import 'package:agriplant/pages/market/orders_page.dart';
import 'package:agriplant/pages/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Profile", style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: CircleAvatar(
              radius: 62,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 60,
                foregroundImage: NetworkImage(_user?.photoURL ?? ''),
              ),
            ),
          ),
          Center(
            child: Text(
              _user?.displayName ?? "User Name",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Center(
            child: Text(
              _user?.email ?? "user@example.com",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 25),
          ListTile(
            title: const Text("My orders"),
            leading: const Icon(IconlyLight.bag),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("About us"),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(IconlyLight.logout),
            onTap: () async{
                await _logout();
                // Navigate to the home page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingPage(),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _logout() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  try {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    // Additional cleanup or navigation if needed
  } catch (error) {
    if (kDebugMode) {
      print("Error during logout: $error");
    }
  }
}
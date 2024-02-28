import 'package:agriplant/pages/bottom_navigation/bottom_navigation_view.dart';
import 'package:agriplant/pages/onboarding_page.dart';
import 'package:agriplant/view_model/market/market_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/app_routes.dart';
import 'models/bloc_providers_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( ChangeNotifierProvider<MarketViewModel>(
    create: (context) => MarketViewModel(),
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBlocProviderInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        routes: appRoutes,
        initialRoute: Routes.init,
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBlocProviderInit(
      child: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // You can show a loading indicator here if needed.
            return const CircularProgressIndicator();
          } else {
            // Check if the user is already logged in
            final bool isLoggedIn = snapshot.data != null;

            // Return the appropriate screen
            return isLoggedIn ? const BottomNavigationBarView() : const OnboardingPage();
          }
        },
      ),
    );
  }
}

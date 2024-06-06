import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/controller/services/auth_services/auth_service.dart';
import 'package:amazon_clone/costants/images.dart';
import 'package:amazon_clone/utils/theme.dart';
import 'package:amazon_clone/view/auth_screens/auth_Screen.dart';
import 'package:amazon_clone/view/auth_screens/otp_screen.dart';
import 'package:amazon_clone/view/users/homepage.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization failed: ${e.toString()}");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authScreen_provider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amazon Clone',
        theme: theme,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, timer) => timer.connectionState == ConnectionState.done
          ? Builder(builder: (context) {
              if (auth_service.is_user_authenticated()) {
                return homePage();
              } else {
                return auth_Screen();
              }
            }) //Screen to navigate to once the splashScreen is done.
          : Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Image.asset(
                splashImage,
                fit: BoxFit.contain,
              ),
            ),
      future: Future.delayed(const Duration(seconds: 1)),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.redAccent,
    );
  }
}

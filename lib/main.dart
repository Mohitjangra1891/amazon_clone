import 'dart:developer';

import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/controller/providers/deal_of_day_provider.dart';
import 'package:amazon_clone/controller/services/auth_services/auth_service.dart';
import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_crud_serivice.dart';
import 'package:amazon_clone/costants/images.dart';
import 'package:amazon_clone/utils/theme.dart';
import 'package:amazon_clone/view/auth_screens/auth_Screen.dart';
import 'package:amazon_clone/view/auth_screens/otp_screen.dart';
import 'package:amazon_clone/view/seller/seller_bottom_nav.dart';
import 'package:amazon_clone/view/users/botton_nav_bar.dart';
import 'package:amazon_clone/view/users/home/homepage.dart';
import 'package:amazon_clone/view/users/user_data_screen/user_data_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/providers/address_provider.dart';
import 'controller/providers/product_by_category_provider.dart';
import 'controller/providers/product_provider.dart';
import 'controller/providers/rating_provider.dart';
import 'controller/providers/user_product_provider.dart';
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
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => SellerProductProvider()),
        ChangeNotifierProvider(create: (_) => UsersProductProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => DealOfTheDayProvider()),
        ChangeNotifierProvider(
            create: (_) => ProductsBasedOnCategoryProvider()),
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
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (ctx, timer) => timer.connectionState == ConnectionState.done
          ? const signIn_logic()
          : Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Image.asset(
                splashImage,
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}

class signIn_logic extends StatefulWidget {
  const signIn_logic({super.key});

  @override
  State<signIn_logic> createState() => _signIn_logicState();
}

class _signIn_logicState extends State<signIn_logic> {
  checkUser() async {
    bool userAlreadyThere = await userData_CRUD.checkUser();
    // log(userAlreadyThere.toString());
    if (userAlreadyThere == true) {
      bool userIsSeller = await userData_CRUD.userIsSeller();
      // log('start-----');
      log("user is seller =" + userIsSeller.toString());
      if (userIsSeller == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SellerBottomNavBar()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const bottom_NavBar()));
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const UserDataInputScrren()));
    }
  }

  checkAuthentication() {
    bool userIsAuthenticated = auth_service.is_user_authenticated();
    userIsAuthenticated
        ? checkUser()
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const auth_Screen(),
            ),
            (route) => false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

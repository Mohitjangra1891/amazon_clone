import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/view/auth_screens/auth_Screen.dart';
import 'package:amazon_clone/view/auth_screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view/users/botton_nav_bar.dart';
import '../../../view/users/home/homepage.dart';

class auth_service {
  static bool is_user_authenticated() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static recieveOTP(
      {required BuildContext context, required String mobile_no}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: mobile_no,
          verificationCompleted: (PhoneAuthCredential credential) {
            context.read<authScreen_provider>().change_is_loading(false);
            print(
                "verification Completed $credential\n mobile numer --$mobile_no");
          },
          verificationFailed: (FirebaseAuthException exception) {
            context.read<authScreen_provider>().change_is_loading(false);

            print("verification falied $exception\n mobile numer --$mobile_no");
          },
          codeSent: (String verificationID, int? resendToken) {
            print("code sent successfully");
            context
                .read<authScreen_provider>()
                .ser_verificationID(verificationID);
            context.read<authScreen_provider>().change_is_loading(false);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => otp_screen(
                          mobile_number: mobile_no,
                        )));
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            print("codeAutoRetrievalTimeout-- $verificationID");
          });
    } catch (exception) {
      context.read<authScreen_provider>().change_is_loading(false);

      if (kDebugMode) {
        print(exception);
      }
    }
  }

  static verifyOTp({required BuildContext context, required String otp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: context.read<authScreen_provider>().verificationID,
          smsCode: otp);
      await auth.signInWithCredential(credential);

      if (is_user_authenticated()) {
        print("login successful");
        context.read<authScreen_provider>().change_is_loading(false);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => bottom_NavBar()),
            (Route<dynamic> route) => false);
      } else {
        context.read<authScreen_provider>().change_is_loading(false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => auth_Screen()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      context.read<authScreen_provider>().change_is_loadingOTP(false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'OTP Invalid',
          style: TextStyle(color: Colors.red),
        )),
      );

      print("dddddddd" + e.toString());
    }
  }
}

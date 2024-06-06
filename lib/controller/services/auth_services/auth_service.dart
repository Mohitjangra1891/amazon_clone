import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/view/auth_screens/auth_Screen.dart';
import 'package:amazon_clone/view/auth_screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view/users/homepage.dart';

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
            print(
                "verification Completed $credential\n mobile numer --$mobile_no");
          },
          verificationFailed: (FirebaseAuthException exception) {
            print("verification falied $exception\n mobile numer --$mobile_no");
          },
          codeSent: (String verificationID, int? resendToken) {
            print("code sent successfully");
            context
                .read<authScreen_provider>()
                .ser_verificationID(verificationID);
            // context.read<authScreen_provider>().set_mobileNumber(mobile_no);
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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => auth_Screen()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

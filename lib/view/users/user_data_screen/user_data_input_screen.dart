import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_crud_serivice.dart';
import 'package:flutter/material.dart';

import '../../../costants/commonFunctions.dart';
import '../../../costants/constants.dart';
import '../../../models/user_model.dart';
import '../../../utils/colors.dart';

class UserDataInputScrren extends StatefulWidget {
  const UserDataInputScrren({super.key});

  @override
  State<UserDataInputScrren> createState() => _UserDataInputScrrenState();
}

class _UserDataInputScrrenState extends State<UserDataInputScrren> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneController.text = auth.currentUser!.phoneNumber ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: Container(
          padding: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
              bottom: height * 0.012,
              top: height * 0.045),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: appBarGradientColor,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: const AssetImage(
                  'assets/images/amazon_black_logo.png',
                ),
                height: height * 0.04,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        // height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help us about knowing you more',
              style:
                  textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            commonFunctions.blankSpace(
              height: height * 0.03,
              width: 0,
            ),
            Text(
              'Enter your Name',
              style: textTheme.bodyMedium,
            ),
            commonFunctions.blankSpace(
              height: height * 0.01,
              width: 0,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            commonFunctions.blankSpace(
              height: height * 0.02,
              width: 0,
            ),
            Text(
              'Phone Number',
              style: textTheme.bodyMedium,
            ),
            commonFunctions.blankSpace(
              height: height * 0.01,
              width: 0,
            ),
            TextField(
              controller: phoneController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  UserModel userModel = UserModel(
                    name: nameController.text.trim(),
                    mobileNum: phoneController.text.trim(),
                    userType: 'user',
                  );
                  await userData_CRUD.addNewUser(
                      userModel: userModel, context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  minimumSize: Size(
                    width,
                    height * 0.06,
                  ),
                ),
                child: Text('Proceed', style: textTheme.bodyMedium))
          ],
        ),
      ),
    );
  }
}

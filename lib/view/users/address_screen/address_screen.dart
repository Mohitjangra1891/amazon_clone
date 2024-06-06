import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_crud_serivice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../../costants/commonFunctions.dart';
import '../../../costants/constants.dart';
import '../../../models/address_model.dart';
import '../../../utils/colors.dart';
import 'address_screen_textfield.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController houseController = TextEditingController();

  TextEditingController areaController = TextEditingController();

  TextEditingController landmarkController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  TextEditingController townController = TextEditingController();

  TextEditingController stateController = TextEditingController();

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
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddressScreenTextField(
                title: 'Enter your name',
                hintText: 'Enter your name',
                textController: nameController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your Mobile Number',
                hintText: 'Enter your Mobile Number',
                textController: mobileController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your House No.',
                hintText: 'Enter your house number',
                textController: houseController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your Area',
                hintText: 'Area',
                textController: areaController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your LandMark',
                hintText: 'Landmark',
                textController: landmarkController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your PINCODE',
                hintText: 'pincode',
                textController: pincodeController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your Town',
                hintText: 'Town',
                textController: townController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              AddressScreenTextField(
                title: 'Enter your State',
                hintText: 'State',
                textController: stateController,
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              ElevatedButton(
                  onPressed: () {
                    Uuid uuid = Uuid();
                    String docID = uuid.v1();
                    AddressModel addressModel = AddressModel(
                      name: nameController.text.trim(),
                      mobileNumber: mobileController.text.trim(),
                      authenticatedMobileNumber: auth.currentUser!.phoneNumber,
                      houseNumber: houseController.text.trim(),
                      area: areaController.text.trim(),
                      landMark: landmarkController.text.trim(),
                      pincode: pincodeController.text.trim(),
                      town: townController.text.trim(),
                      state: stateController.text.trim(),
                      docID: docID,
                      isDefault: true,
                    );

                    userData_CRUD.addUserAddress(
                      context: context,
                      addressModel: addressModel,
                      docID: docID,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: amber,
                    minimumSize: Size(
                      width,
                      height * 0.06,
                    ),
                  ),
                  child: Text(
                    'Add Address',
                    style: textTheme.bodyMedium,
                  )),
              commonFunctions.blankSpace(
                height: height * 0.09,
                width: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

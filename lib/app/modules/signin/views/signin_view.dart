import 'package:chatapp/app/data/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Get.put(SigninController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 100, bottom: 30),
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Please confirm your phone country code and enter your phone number.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Form(
                      key: phoneNumberKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: InternationalPhoneNumberInput(
                        inputDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: mainColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Phone number is required";
                          } else if (value[0] == "0") {
                            return "Can't start with 0";
                          } else if (value.length < 10) {
                            return "Must be 11 or 12 digits";
                          } else {
                            return null;
                          }
                        },
                        maxLength: 12,
                        cursorColor: mainColor,
                        inputBorder: InputBorder.none,
                        onInputChanged: (PhoneNumber number) {
                          controller.phoneNumber = number.toString();
                        },
                        spaceBetweenSelectorAndTextField: 0,
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          leadingPadding: 0,
                        ),
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(
                          color: blackColor,
                        ),
                        textStyle: TextStyle(
                          color: blackColor,
                        ),
                        initialValue: PhoneNumber(isoCode: "ID"),
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => ElevatedButton.icon(
                onPressed: () {
                  if (phoneNumberKey.currentState!.validate()) {
                    if (controller.isLoading.value) {
                      null;
                    } else {
                      controller.sendOtp();
                    }
                  }
                },
                label: const Text('NEXT'),
                icon: controller.isLoading.value
                    ? Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Container(color: Colors.red),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(Get.width, 40),
                  primary: mainColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

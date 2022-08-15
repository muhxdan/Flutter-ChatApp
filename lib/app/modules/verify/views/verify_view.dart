import 'package:chatapp/app/data/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/verify_controller.dart';

class VerifyView extends GetView<VerifyController> {
  final phoneNumber;
  VerifyView({ this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    Get.put(VerifyController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "OTP Code Verification",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Get.offAllNamed('/signin'),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/otp.svg",
              width: 180,
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                "Code has been send to\n${phoneNumber}",
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            PinCodeTextField(
              length: 6,
              appContext: context,
              obscureText: false,
              keyboardType: TextInputType.phone,
              animationType: AnimationType.scale,
              textStyle: TextStyle(
                color: Colors.white,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: mainColor,
                activeFillColor: mainColor,
                selectedColor: mainColor,
                selectedFillColor: mainColor,
                inactiveColor: mainColor,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              enableActiveFill: true,
              onChanged: (value) {
                print("send otp " + value);
              },
              onCompleted: (otp) {
                controller.verifyOTP(otp);
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/phone_auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginPhonePage extends StatefulWidget {
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String? complete;
  PhoneNumber? phoneNumber;

  bool obscurePassword = true;
  bool showPassChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titleText(),
              const SizedBox(height: 80),
              _phoneNumberField(),
              const SizedBox(height: 20),
              _generateOTPButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return Column(
      children: [
        Center(
          child: Text(
            'Enter your Phone Number',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            'We will send you the 6 digit verification code',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _phoneNumberField() {
    _phoneNumberController.text = "6505551234";
    return IntlPhoneField(
      keyboardType: TextInputType.phone,
      controller: _phoneNumberController,
      dropdownTextStyle: TextStyle(fontSize: 14),
      flagsButtonMargin: EdgeInsets.only(bottom: 10),
      style: TextStyle(fontSize: 14),
      initialCountryCode: 'US',
      onChanged: (newValue) {
        phoneNumber = newValue;
      },
    );
  }

  Widget _generateOTPButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await PhoneAuthService().sendOTP(context: context, phoneNumber: phoneNumber!.completeNumber);
      },
      child: Text(
        "Generate OTP",
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }
}
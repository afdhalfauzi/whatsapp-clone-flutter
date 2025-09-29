import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/services/phone_auth_service.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OTPVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Enter the 6-digit code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter the otp sent to number ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (pin) {
                print('Entered OTP: $pin');
                // Call Firebase verify function here
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                User? user = await PhoneAuthService().verifyOTP(
                  context: context,
                  verificationId: widget.verificationId,
                  smsCode: _otpController.text,
                );

                if (user != null) {
                  final api = Provider.of<APIManager>(context, listen: false);
                  final notif = Provider.of<NotificationService>(
                    context,
                    listen: false,
                  );

                  await user.updateDisplayName(widget.phoneNumber);

                  final existingTenant = await api.get(
                    table: "tenant",
                    condition: {"tenantId": user.uid},
                  );

                  if (existingTenant.isNotEmpty) {
                    await api.put(
                      table: "tenant",
                      newData: {
                        "tenantId": user.uid,
                        "fcmToken": notif.FCMToken,
                      },
                    );
                  } else {
                    api.post(
                      table: "tenant",
                      newData: {
                        "tenantId": user.uid,
                        "roomId": null,
                        "name": widget.phoneNumber,
                        "photoUrl": user.photoURL,
                        "phoneNumber": widget.phoneNumber,
                        "accountProvider": "number",
                        "fcmToken": notif.FCMToken,
                        "createdAt": DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(DateTime.now()),
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
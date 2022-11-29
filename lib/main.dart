import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MaterialApp(
    home: Home(),
  ));
}
//
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController numberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  OtpFieldController otpFieldController = OtpFieldController();
  String vid ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: numberController,
          ),
          SizedBox(height: 7,),
          ElevatedButton(onPressed: () async {
            await FirebaseAuth.instance.verifyPhoneNumber(
              timeout: Duration(minutes: 1),
              phoneNumber: '+91${numberController.text}',
              verificationCompleted: (PhoneAuthCredential credential) async {

                await auth.signInWithCredential(credential);
              },
              verificationFailed: (FirebaseAuthException e) {
                if (e.code == 'invalid-phone-number') {
                  print('The provided phone number is not valid.');
                }
              },
              codeSent: (String verificationId, int? resendToken)  {
                vid = verificationId;
              },
              codeAutoRetrievalTimeout: (String verificationId) {

              },
            );
          }, child: Text("Get OTP")),
          OTPTextField(
            length: 6,
            keyboardType: TextInputType.number,
            controller: otpFieldController,
            onCompleted: (value) {

            },
          ),
          ElevatedButton(onPressed: () {

          }, child: Text("Submit"))
        ],
      ),
    );
  }
}

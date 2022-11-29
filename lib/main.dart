import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController numberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

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
              phoneNumber: '+91${numberController.text}',
              verificationCompleted: (PhoneAuthCredential credential) async {

                await auth.signInWithCredential(credential);
              },
              verificationFailed: (FirebaseAuthException e) {

              },
              codeSent: (String verificationId, int? resendToken) {},
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }, child: Text("Get OTP")),

        ],
      ),
    );
  }
}

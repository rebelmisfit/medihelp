import 'package:flutter/material.dart';
import 'sign-in.dart';
import 'package:medihelp/constants.dart';
import 'package:medihelp/screens/sign-up.dart';
import 'package:medihelp/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medihelp/screens/home.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose()
  {
    emailController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        leading: IconButton(onPressed:() { Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),

        title: Text("Forgot Password"),),
      body: Column(
        children: [
          TextFormField(
            controller: emailController,
            cursorColor : Colors.black,
            textInputAction: TextInputAction.done,
            decoration : InputDecoration(labelText: "email"),

          ),
          ElevatedButton.icon(

            icon: Icon(Icons.email_outlined),
              label: Text("reset password"),
              onPressed: resetpassword,
          )
        ],
      )
    );

  }
  Future resetpassword() async{
    showDialog(
        context: context ,
        barrierDismissible: false,
        builder: (context) =>Center(child: CircularProgressIndicator(),));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e)
    {
      print(e);
      Navigator.of(context).pop();
    }
  }

}

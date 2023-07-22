// import 'package:doctor_app/screens/auth/sign_up_screen.dart';

import 'package:flutter/material.dart';

import 'package:medihelp/constants.dart';
import 'package:medihelp/screens/sign-up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../main.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forgot-password.dart';
// import '../../constants.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();



class SignInForm extends StatelessWidget {
  SignInForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey formKey;

  //late String _email, _password;


  get passwordValidator => null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "Email"),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "I2K21122222@ms.pict.edu"),
            // validator: EmailValidator(errorText: "Use a valid email!"),
            onSaved: (email) => emailController = email! as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Password"),
          TextFormField(
            // We want to hide our password
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "******"),
            validator: passwordValidator,
            onSaved: (password) => passwordController= password! as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}


class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }
        else if (snapshot.hasError)
          {
            return Center(child: Text('Something Went Wrong!'));
          }
        else if (snapshot.hasData) {
          return Dashboard();
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign In",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              ),
                              child: Text(
                                "Sign Up!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        SignInForm(formKey: _formKey),
                        const SizedBox(height: defaultPadding * 2),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signIn,

                            child: Text("Sign In"),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          ),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );

  }

  Future signIn() async {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) =>Center(child: CircularProgressIndicator(),));
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),);
    } on FirebaseAuthException catch(e)
    {
      print(e);
    }
 navigatorKey.currentState!.popUntil((route)=>route.isFirst);

  }
  }


// import 'package:doctor_app/constants.dart';
// import 'package:doctor_app/screens/auth/sign_in_screen.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:medihelp/constants.dart';
import 'package:medihelp/main.dart';
import 'package:medihelp/screens/sign-in.dart';

// import 'components/sign_up_form.dart';


class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey formKey;

  // late String _userName, _email, _password, _phoneNumber;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();




  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "Username"),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(hintText: "enter user name"),
            // validator: RequiredValidator(errorText: "Username is required"),
            // Let's save our username
            onSaved: (username) => usernameController = username! as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
          // We will fixed the error soon
          // As you can see, it's a email field
          // But no @ on keybord
          TextFieldName(text: "Email"),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "I2K21122222@ms.pict.edu"),
            // validator: EmailValidator(errorText: "Use a valid email!"),
            onSaved: (email) => emailController = email! as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Phone"),
          // Same for phone number
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "+91"),
            // validator: RequiredValidator(errorText: "Phone number is required"),
            onSaved: (phoneNumber) =>phoneNumberController = phoneNumber! as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Password"),

          TextFormField(
            // We want to hide our password
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "******"),
            // validator: passwordValidator,
            onSaved: (password) => passwordController = password! as TextEditingController,
            // We also need to validate our password
            // Now if we type anything it adds that to our password
            onChanged: (pass) => passwordController = pass as TextEditingController,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Confirm Password"),
          TextFormField
            (
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "*****"),

            // validator: (pass) =>
            //     MatchValidator(errorText: "Password do not  match")
            //         .validateMatch(pass!, _password),
          ),
        ],
      ),
    );
  }
}

class RequiredValidator {}

class TextFieldName extends StatelessWidget {
  const TextFieldName({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 3),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  // It's time to validat the text field
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              )),
                          child: Text(
                            "Sign In!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SignUpForm(formKey: _formKey),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUp,
                        child: Text("Sign Up"),
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
  Future signUp() async
  {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }
    on FirebaseAuthException catch(e){
      print(e);
    }
    navigatorKey.currentState!.popUntil((route)=>route.isFirst);
  }


}

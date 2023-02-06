import 'package:flutter/material.dart';
import 'package:task/widgets/custom_button.dart';
import '../data/database_helper.dart';
import '../models/user.dart';
import '../utils/globals.dart';
import '../utils/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _userName = TextEditingController();
  final _password = TextEditingController();

  void _showSnackBar(String text) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Login to your Account',
                      style: Styles.headingStyle3(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:3,left: 12.0),
                    child: Text(
                      'Enter your user name to log in your account',
                      style: Styles.headingStyle6(
                          isBold : true,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: kHeight * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _userName,
                      validator: (value) => value!.length < 3
                          ? "Enter at least 3 or more characters."
                          : null,
                      decoration: InputDecoration(
                          hintText: 'Enter user name',
                          hintStyle: Styles.headingStyle6(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: const Icon(Icons.person,
                            color: Globals.primary,)
                        // fillColor: colorSearchBg,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kHeight * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) => value!.length < 3
                          ? "Enter at least 3 or more characters."
                          : null,
                      decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: Styles.headingStyle6(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: const Icon(Icons.lock,
                            color: Globals.primary,)
                        // fillColor: colorSearchBg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kHeight * 0.06,
            ),
            CustomButton(
                padding: 40,
                text: 'LOGIN',
                sColor: Globals.primary,
                fColor: Globals.primary,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    DatabaseHelper().checkUser(User(_userName.text, _password.text)).
                    then((user) => onLoginSuccess(user))
                        .catchError((onError) {
                      return onLoginError(onError.toString());
                    });
                  }
                }),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("/register");
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0,bottom: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account ? ',
                        style: Styles.headingStyle6(
                            isBold: true
                        ),),
                      Text('Sign Up',
                        style: Styles.headingStyle5(
                            isBold: true,
                            color: Globals.primary
                        ),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLoginError(String error) {
    _showSnackBar(error);
  }

  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    Navigator.of(context).pushNamedAndRemoveUntil(
        "/home", (route) => false);
  }

}

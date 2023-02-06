import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/user.dart';
import '../utils/globals.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  void _showSnackBar(String text) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Globals.primary,
        centerTitle: true,
        title: Text("Register Page",
        style: Styles.headingStyle4(
          isBold: true,
          color: Colors.white
        ),),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: kHeight * 0.06,
            ),
            Form(
              key: formKey,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Sign Up',
                      style: Styles.headingStyle3(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 3),
                    child: Text(
                      'Please enter basic details to proceed',
                      style: Styles.headingStyle6(color: Colors.grey,isBold:true),
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
                      validator: (value) => value!.length < 5
                          ? "Enter at least 5 or more characters."
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
                  SizedBox(
                    height: kHeight * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _confirmPassword,
                      validator: (value) => value!.length < 5
                          ? "Enter at least 5 or more characters."
                          : null,
                      decoration: InputDecoration(
                          hintText: 'Enter confirm password',
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
                text: 'REGISTER',
                sColor: Globals.primary,
                fColor: Globals.primary,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if(_password.text == _confirmPassword.text){
                      Future.value(User(_userName.text, _password.text))
                          .then((user) => onRegisterSuccess(user))
                          .catchError((onError) {
                        return onRegisterError(onError.toString());
                      });
                    }else{
                      _showSnackBar('Confirm password need to be same!');
                    }
                  }
                }),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/login", (route) => false);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0,bottom: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account ? ',
                        style: Styles.headingStyle6(
                            isBold: true
                        ),),
                      Text('Sign In',
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

  void onRegisterError(String error) {
    _showSnackBar(error);
  }

  void onRegisterSuccess(User user) async {
    _showSnackBar(user.toString());
    var db = DatabaseHelper();
    await db.saveUser(user);
    Navigator.of(context).pushNamedAndRemoveUntil(
        "/login", (route) => false);
  }
}

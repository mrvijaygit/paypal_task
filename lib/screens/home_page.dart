import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/database_helper.dart';
import '../models/user.dart';
import '../utils/globals.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  final _price = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState(){
    super.initState();
    var db = DatabaseHelper();
    db.getAllUser().then((user){
      users = user;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Globals.primary,
          centerTitle: true,
          title: Text("Home Screen",
            style: Styles.headingStyle4(
                isBold: true,
                color: Colors.white
            ),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text('Enter the amount',
                  style: Styles.headingStyle5(
                    isBold: true
                  )),
                ),
                SizedBox(
                  height: kHeight * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: _price,
                    validator: (value) => value!.isEmpty
                        ? "Invalid amount"
                        : null,
                    decoration: InputDecoration(
                        hintText: 'Enter the amount',
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
                        prefixIcon: const Icon(Icons.price_change,
                          color: Globals.primary,)
                      // fillColor: colorSearchBg,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kHeight * 0.05,
            ),
            CustomButton(
                padding: 80,
                text: 'PAYPAL',
                sColor: Globals.primary,
                fColor: Globals.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId:
                          "AeGpvqJ59CPm3htDGjWv9HNtXJ80OvG-zfEjVJWVM5Hr-qAbOafCaKpYdFSLPgwfLT5y6iRjUi6DkKxS",
                          secretKey:
                          "EMg6RE8usZYISfiLFXaTSysXE0dBSdL_JPCQw9tJz0OnJ9dl-yaODZ5B3DxKsjuvvUcM_-A8i7Wk2jkv",
                          returnURL: "https://samplesite.com/return",
                          cancelURL: "https://samplesite.com/cancel",
                          transactions: [
                            {
                              "amount": {
                                "total": "${double.parse(_price.value.text)}",
                                "currency": "USD",
                                "details": {
                                  "subtotal": "${double.parse(_price.value.text)}",
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description": "The payment transaction description.",
                              "item_list": {
                                "items": [
                                  {
                                    "name": "Example product",
                                    "quantity": 1,
                                    "price": "${double.parse(_price.value.text)}",
                                    "currency": "USD"
                                  }
                                ],

                                // shipping address is not required though
                                "shipping_address": const {
                                  "recipient_name": "Vijay Ravi",
                                  "line1": "Travis County",
                                  "line2": "",
                                  "city": "Austin",
                                  "country_code": "US",
                                  "postal_code": "10001",
                                  "phone": "+00000000",
                                  "state": "New York"
                                },
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print('onSuccess : $params');
                            Fluttertoast.showToast(msg: 'Payment Successful!');
                          },
                          onError: (error) {
                            Fluttertoast.showToast(msg: 'Something went wrong, Please try again!');
                          },
                          onCancel: (params) {}),
                    ),
                  );
                }),
          ],
        )
    );
  }
}
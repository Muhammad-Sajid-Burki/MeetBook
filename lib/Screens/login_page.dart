
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Model/UserModel.dart';
import 'package:dating_app_flutter/Provider/AllUsersProvider.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/blocked_user_screen.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:dating_app_flutter/main.dart';
import 'package:dating_app_flutter/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key,
  }): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  double _headerHeight = 250;
  final formkey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();

  DatabaseMethod databaseMethod = new DatabaseMethod();

  bool circular = false;

  QuerySnapshot? snapshotUserInfo;
  signIn() async {
    setState(() {
      circular = true;
    });

      final userProvider =  Provider.of<UserProvider>(context, listen: false);
      final allUsersProvider =  Provider.of<AllUsersProvider>(context, listen: false);

      await userProvider.signIn(userModel: UserModel(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      ),
        onSuccess: () async {
          await allUsersProvider.changeGender(context);
          await allUsersProvider.getAllUsers(context);
          setState(() {
            circular = false;
          });

          userProvider.userModel.isBlocked == 'false' ?

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => AuthWrapper()),
                  (route) => false) :
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => BlockedUserScreen()),
                  (route) => false);
        },
        onFail: (e) {
          setState(() {
            circular = false;
          });
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },

      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight), //let's create a common header widget
            ),
            SafeArea(
              child: Container( 
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                child: Column(
                  children: [
                    Text(
                      'MeetBook',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: formkey,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                validator: (val) {
                                  return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                      ? null
                                      : "please provide a valid email address";
                                },
                                controller: emailTextEditingController,
                                decoration: ThemeHelper().textInputDecoration('email', 'Enter your email address'),
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              child: TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val!.length > 6
                                      ? null
                                      : "please provide password 6+ character";
                                },
                                controller: passwordTextEditingController,
                                decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 15.0),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(10,0,10,20),
                            //   alignment: Alignment.topRight,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                            //     },
                            //     child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: circular
                                      ? CircularProgressIndicator(
                                      valueColor:AlwaysStoppedAnimation<Color>(Palette.deepBlue))
                                  : Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),
                                onPressed: (){
                                  //After successful login we will redirect to profile page. Let's create profile page now
                                  signIn();
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10,20,10,20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(builder: (context) => RegistrationPage()),
                                                  (Route<dynamic> route) => false);
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                                )
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );

  }
}
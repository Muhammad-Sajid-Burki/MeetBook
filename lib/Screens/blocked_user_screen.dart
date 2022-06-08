import 'dart:async';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class BlockedUserScreen extends StatelessWidget {
  BlockedUserScreen({Key? key,}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final userProvider =  Provider.of<UserProvider>(context, listen: false);


    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/block_user.png", height: 200, width: 200,),
                Text(
                  'User Blocked',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                ElevatedButton(
                    onPressed: () async {

                      await userProvider.logout();

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false);
                    },
                    child: Text('Tap Here'))
              ],
            ),
          ),
        ),

    );
  }
}
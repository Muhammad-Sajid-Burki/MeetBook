import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/AllUsersProvider.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/MainPage.dart';
import 'package:dating_app_flutter/Screens/login_page.dart';
import 'package:dating_app_flutter/Screens/splash_screen.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AllUsersProvider()),
    ],

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: HexColor('#c7e9ff'),
            accentColor: HexColor('#a4dbfc'),
            scaffoldBackgroundColor:
                ThemeHelper().generateMaterialColor(Palette.primary),
            primarySwatch:
                ThemeHelper().generateMaterialColor(Palette.secondary),
          ),
          home: AuthWrapper(),

        )
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider =  Provider.of<UserProvider>(context, listen: false);
    final allUsersProvider =  Provider.of<AllUsersProvider>(context, listen: false);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(snapshot.data?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                print("this is the data ${snapshot.data}");
                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  if (userDoc!['isBlocked'] == 'false') {
                    return MainScreen();
                  }
                  else{
                    return LoginPage();
                  }

                } else {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
            return SplashScreen(title: 'Flutter Login UI');
        });
  }
}

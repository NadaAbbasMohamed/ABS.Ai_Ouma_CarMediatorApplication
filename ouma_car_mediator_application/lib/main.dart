import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:ouma_car_mediator_application/Screens/Welcoming/UserSelectPage.dart';
import 'package:ouma_car_mediator_application/Screens/Welcoming/welcomeScreen.dart';



// this is for testing

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(OumaApp());
  //runApp(TempApp());
}

class OumaApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      //future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('Could not load app'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(fontFamily: 'NovaSlim'),
            debugShowCheckedModeBanner: false,
            home: WelcomePage(), //UserSelectPage(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
            theme: ThemeData(fontFamily: 'NovaSlim'),
            debugShowCheckedModeBanner: false,
            home: WelcomePage());
      },
    );
  }
}


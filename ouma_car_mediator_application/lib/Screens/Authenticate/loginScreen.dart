/*
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Authenticate/loggedinScreen.dart';
import 'package:flutter_auth/Screens/Authenticate/components/logInVideo.dart';
import 'package:flutter_auth/components/roundedButton.dart';
import 'package:flutter_auth/components/inputFieldController.dart';
import 'package:flutter_auth/Screens/Authenticate/signupScreen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:google_fonts/google_fonts.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController numberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();
  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';
  var canResend = false;

  int _counter = 60;
  StreamController<int> _events;
  Timer _timer;

  @override
  initState() {
    super.initState();
    _events = new StreamController<int>.broadcast();
    _events.add(60);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    numberController.dispose();
    otpController.dispose();
    _events.close();
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context){
    return returnLoginScreen();
  }


  void _startTimer() {
    _counter = 60;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(_counter > 0){
        _counter--;
        canResend = false;
      }
      else{
        _timer.cancel();
        canResend = true;
      }
      _events.add(_counter);
    });
  }

  Widget returnLoginScreen() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      key: _scaffoldKey,
      backgroundColor: DarkBlueBG,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top:50.0,bottom:20.0),
                child: VideoPlayerScreen(),

              ),
              Padding(
                  padding: const EdgeInsets.only(top:20.0,bottom:20.0, right: 30.0),
                  child: InputFieldController(
                    width: size.width* 0.75,
                    isEnabled: !isLoading,
                    authController: numberController,
                    keyboardType: TextInputType.phone,
                    icon: Icons.phone,
                    hintText: "0 100 000 0000",
                    hintStyle: GoogleFonts.novaSlim(fontSize: 20.0, color: GraySeparation),
                    labelText: "Phone",
                    validator: (value) {
                      if (value.isEmpty) {
                        displaySnackBar("Please enter phone number"); // TODO: prevent signingIn if this field is empty
                        //return 'Enter phone number';
                      }
                    },
                  )),
              !isLoading
                  ? new RoundedButton(
                width: size.width * 0.75,
                text: "Log In",
                onPressed: () async {
                  if (!isLoading) {
                    if (_formKey.currentState.validate()) {
                      displaySnackBar(
                          'Please wait ...');
                      await login();
                    }
                  }
                  if(isOTPScreen){
                    _startTimer();
                    popupVerification(context);
                  }
                },
              )
                  : CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),

              Text("Don't have an account ?",
                  style:GoogleFonts.novaSlim(
                      textStyle: TextStyle(color: TextWhite),fontSize: 20)),
              InkWell(
                child: Text('Sign up',
                  style:GoogleFonts.novaSlim(
                      textStyle: TextStyle(color: TextWhite),fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  popupVerification(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _startTimer();
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
            content: StreamBuilder<int>(
              stream: _events.stream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                return Container(
                    width: size.width * 0.95,
                    height: size.height * 0.55,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: BottomAppBarColor,
                                borderRadius: BorderRadius.only(topLeft:Radius.circular(40),topRight: Radius.circular(40))),
                            height:size.height * 0.1,
                            child: Padding(
                                padding: EdgeInsets.only(left:25.0, right:15.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _timer.cancel();
                                        _events.close();
                                        setState(() {
                                          isResend = false;
                                          isLoading = false;
                                        });
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext
                                            context) =>
                                                LoginScreen(),
                                          ),
                                              (route) => false,
                                        );
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: LightBlueBG,
                                      ),
                                    ),
                                    Text("Verification",
                                        style:GoogleFonts.novaSlim(fontSize: 26.0, color: DarkBlueBG)),
                                    SizedBox(width:size.width*0.12)
                                  ],
                                )),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key:_formKeyOTP,
                              child: Column( // TODO: remove unnecessary padding
                                children: [
                                  Text(!isLoading? "Enter OTP Code Sent":"Sending OTP Code SMS ...",
                                    style:GoogleFonts.novaSlim(fontSize: 20.0, color: DarkBlueBG),
                                    textAlign: TextAlign.left,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:30,top:20,bottom:0.0),
                                      child: InputFieldController(
                                        isEnabled: !isLoading,
                                        authController: otpController,
                                        validator:(value){
                                          if(value.isEmpty){
                                            return "Please Enter OTP";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.numberWithOptions(),
                                        charMaxLength: 6,
                                        enforcement: MaxLengthEnforcement.enforced,
                                        width: size.width *0.7,
                                        height: size.height *0.2,
                                        textAlign: TextAlign.center,
                                        letterSpacing: 10,
                                        textSize: 30,
                                        textColor:TextWhite,
                                        labelText: "OTP",
                                        labelColor: DarkBlueBG,
                                        labelTextSize: 30,
                                        labelLetterSpacing:0,
                                        borderColor: DarkBlueBG,
                                        hintText: "123456",
                                        hintStyle: GoogleFonts.novaSlim(fontSize: 25, color: TextWhite.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                  Padding(

                                    padding: EdgeInsets.only(left:25.0,top:0.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:[
                                          Text("00:${snapshot.data.toString()}",style:GoogleFonts.novaSlim(fontSize: 20.0, color: TextWhite),),

                                          TextButton(onPressed:!canResend? null :() async {
                                            _startTimer();

                                            setState(() {
                                              isResend = false;
                                              isLoading = true;
                                            });

                                            if (!isLoading) {
                                              if (_formKey.currentState.validate()) {
                                                displaySnackBar(
                                                    'Please wait ...');
                                                await login();
                                              }
                                            }
                                          },
                                              child:Text("Resend\n Code",
                                                  style: GoogleFonts.novaSlim(fontSize:20, color:!canResend?LightGreyText:TextWhite))
                                          ),

                                          RoundedButton(
                                            text:"Verify",
                                            width:size.width*0.3,
                                            fontSize:15,
                                            textColor:DarkBlueBG,
                                            backGroundColor:BottomAppBarColor,
                                            horizontalPadding: 15,
                                            onPressed: () async {
                                              if (_formKeyOTP.currentState.validate()) {
                                                // If the form is valid, we want to show a loading Snackbar
                                                setState(() {
                                                  isResend = false;
                                                  isLoading = true;
                                                });
                                                try {
                                                  await _auth
                                                      .signInWithCredential(
                                                      PhoneAuthProvider.credential(
                                                          verificationId:
                                                          verificationCode,
                                                          smsCode: otpController.text
                                                              .toString()))
                                                      .then((user) async =>
                                                  [
                                                    //sign in was successful
                                                    if (user != null)
                                                      { _timer.cancel(),
                                                        //store registration details in fire store database
                                                        setState(() {
                                                          isLoading = false;
                                                          isResend = false;
                                                        }),
                                                        Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                            context) =>
                                                                LoggedInScreen(), // TODO: Change to the correct Route
                                                          ),
                                                              (route) => false,
                                                        )
                                                      }
                                                  ])
                                                      .catchError((error) =>
                                                  {
                                                    setState(() {
                                                      isLoading = false;
                                                      isResend = true;
                                                    }),
                                                  });
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                } catch (e) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                        ]),
                                  )

                                ],
                              ),
                            ),


                          ),


                        ])
                );
              },
            ),
            backgroundColor: LightBlueBG,
          );
        });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+2 ' + numberController.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = numberController.text.trim();

    await _fireStore
        .collection('users')
        .where('Phone number', isEqualTo: number)
        .get()
        .then((result) {
      print("\n\n\n");
      print(result.docs.length);
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
            if (user != null)
              {
                //redirect
                setState(() {
                  isLoading = false;
                  isOTPScreen = false;
                }),
                _timer.cancel(),
                _events.close(),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoggedInScreen(), // TODO: Change this to the correct route
                  ),
                      (route) => false,
                )
              }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Validation error, please try again later');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
            popupVerification(context);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 90),
      );
      await verifyPhoneNumber;
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('Number not found, please sign up first');
    }
  }
}

*/
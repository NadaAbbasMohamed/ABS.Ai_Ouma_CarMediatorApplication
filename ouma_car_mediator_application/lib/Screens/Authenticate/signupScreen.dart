/*
import 'dart:async';
import 'package:flutter_auth/Screens/BusinessExist/BusinessExist_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:flutter_auth/Screens/MainPages/TodoList.dart';
import 'package:flutter_auth/components/dropDownBoxConstants.dart';
import 'package:flutter_auth/components/dropDownBox.dart';
import 'package:flutter_auth/components/orDivider.dart';
import 'package:flutter_auth/components/inputFieldController.dart';
import 'package:flutter_auth/components/roundedButton.dart';
import 'package:flutter_auth/constants.dart';

import '../../constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController secondNameController =
  new TextEditingController();
  final TextEditingController cellNumberController =
  new TextEditingController();
  final TextEditingController shopNameController = new TextEditingController();
  String shopTypeController;
  String shopSizeController;
  final TextEditingController shopAddressController =
  new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';
  var canResend = false;

  int _counter = 60;
  StreamController<int> _events;
  Timer _timer;

  //Form controllers
  @override
  void initState() {
    super.initState();
    _events = new StreamController<int>.broadcast();
    _events.add(60);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    firstNameController.dispose();
    secondNameController.dispose();
    cellNumberController.dispose();
    shopNameController.dispose();
    //shopTypeController.dispose();
    shopAddressController.dispose();
    //shopSizeController.dispose();

    otpController.dispose();
    _events.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return registerScreen();
  }

  Widget registerScreen() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: LightBlueBG,
            ),
          ),
          backgroundColor: DarkBlueBG,
          foregroundColor: LightBlueBG,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          title: Text(
            'Sign up',
            style: GoogleFonts.novaSlim(
                textStyle: TextStyle(color: LightBlueBG),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: DarkBlueBG,
        key: _scaffoldKey,
        body:
        ListView(padding: EdgeInsets.symmetric(vertical: 15.0), children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OrDivider(text: "User\nInformation"),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, right: 30.0),
                        child: InputFieldController(
                          width: size.width * 0.95,
                          isEnabled: !isLoading,
                          authController: firstNameController,
                          labelText: "First Name:",
                          hintStyle: GoogleFonts.novaSlim(
                              textStyle: TextStyle(color: TextWhite),
                              fontSize: 20),
                          hintText: "First name",
                          validator: (value) {
                            if (value.isEmpty) {
                              displaySnackBar('Please enter a first name');
                            }
                            return null;
                          },
                        ),
                      ),



                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, right: 30.0),
                        child: InputFieldController(
                          width: size.width * 0.95,
                          isEnabled: !isLoading,
                          authController: secondNameController,
                          labelText: "Second Name:",
                          hintStyle: GoogleFonts.novaSlim(
                              textStyle: TextStyle(color: TextWhite),
                              fontSize: 20),
                          hintText: "Second name",
                          validator: (value) {
                            if (value.isEmpty) {
                              displaySnackBar('Please enter a second name');
                            }
                            return null;
                          },
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 30.0, right: 30.0),
                        child: InputFieldController(
                          hintStyle: GoogleFonts.novaSlim(
                              textStyle: TextStyle(color: TextWhite),
                              fontSize: 20),
                          hintText: "0100 000 0000",
                          isEnabled: !isLoading,
                          keyboardType: TextInputType.phone,
                          authController: cellNumberController,
                          labelText: "Phone Number:",
                          validator: (value) {
                            if (value.isEmpty) {
                              displaySnackBar("Please enter a phone number");
                            }
                            return null;
                          },
                        ),
                      ),
                      OrDivider(text: "Shop\nInformation"),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, right: 30.0),
                        child: InputFieldController(
                          isEnabled: !isLoading,
                          authController: shopNameController,
                          hintText: "Market Name",
                          hintStyle: GoogleFonts.novaSlim(
                              textStyle: TextStyle(color: TextWhite),
                              fontSize: 20),
                          labelText: "Shop name:",
                          validator: (value) {
                            if (value.isEmpty) {
                              displaySnackBar('Please enter a shop name');
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                        child: DropdownBox(
                            options: shopType,
                            titleImageUrl: "assets/images/shopIcon1.png",
                            title: "Shop Type"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20.0, right: 30.0),
                        child: InputFieldController(
                          isEnabled: !isLoading,
                          authController: shopAddressController,
                          hintText: "Market Address",
                          hintStyle: GoogleFonts.novaSlim(
                              textStyle: TextStyle(color: TextWhite),
                              fontSize: 20),
                          labelText: "Shop Address:",
                          validator: (value) {
                            if (value.isEmpty) {
                              displaySnackBar("Please enter a shop Address");
                            }
                            setState(() {
                              shopTypeController = getController();
                            });
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                        child: DropdownBox(
                            options: shopSize,
                            titleImageUrl: "assets/images/shopIcon2.png",
                            title: "Shop Size     "),
                      ),
                      new RoundedButton(
                        width: size.width * 0.75,
                        text: "Sign up",
                        onPressed: () async {
                          setState(() {
                            shopSizeController = getController();
                          });

                          if (!isLoading) {
                            if (_formKey.currentState.validate()) {
                              displaySnackBar('Please wait ...');
                              await signUp();
                            }
                          }
                          if (isOTPScreen) {
                            popupVerification(context);
                          }
                        },
                      )
                    ],
                  ))
            ],
          )
        ]));
  }

  void _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  popupVerification(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _startTimer();
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            content: StreamBuilder<int>(
              stream: _events.stream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Container(
                    width: size.width * 0.95,
                    height: size.height * 0.55,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: BottomAppBarColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            height: size.height * 0.1,
                            child: Padding(
                                padding:
                                EdgeInsets.only(left: 25.0, right: 15.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                            builder: (BuildContext context) =>
                                                RegisterScreen(),
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
                                        style: GoogleFonts.novaSlim(
                                            fontSize: 26.0, color: DarkBlueBG)),
                                    SizedBox(width: size.width * 0.12),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKeyOTP,
                              child: Column(
                                children: [
                                  Text(
                                    !isLoading
                                        ? "Enter OTP Code Sent"
                                        : "Sending OTP Code SMS ...",
                                    style: GoogleFonts.novaSlim(
                                        fontSize: 20.0, color: DarkBlueBG),
                                    textAlign: TextAlign.left,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 30, top: 20, bottom: 0.0),
                                      child: InputFieldController(
                                        isEnabled: !isLoading,
                                        authController: otpController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please Enter OTP"; //TODO: display snack bar
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                        TextInputType.numberWithOptions(),
                                        charMaxLength: 6,
                                        enforcement:
                                        MaxLengthEnforcement.enforced,
                                        width: size.width * 0.7,
                                        height: size.height * 0.2,
                                        textAlign: TextAlign.center,
                                        letterSpacing: 10,
                                        textSize: 30,
                                        textColor: TextWhite,
                                        labelText: "OTP",
                                        labelColor: DarkBlueBG,
                                        labelTextSize: 30,
                                        labelLetterSpacing: 0,
                                        borderColor: DarkBlueBG,
                                        hintText: "123456",
                                        hintStyle: GoogleFonts.novaSlim(
                                            fontSize: 25,
                                            color: TextWhite.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 25.0, top: 0.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "00:${snapshot.data.toString()}",
                                            style: GoogleFonts.novaSlim(
                                                fontSize: 20.0,
                                                color: TextWhite),
                                          ),
                                          TextButton(
                                              onPressed: !canResend
                                                  ? null
                                                  : () async {
                                                _startTimer();

                                                if (!isLoading) {
                                                  if (_formKeyOTP
                                                      .currentState
                                                      .validate()) {
                                                    displaySnackBar(
                                                        'Please wait ...');
                                                    await signUp();
                                                  }
                                                }
                                              },
                                              child: Text("Resend\n Code",
                                                  style: GoogleFonts.novaSlim(
                                                      fontSize: 20,
                                                      color: !canResend
                                                          ? LightGreyText
                                                          : TextWhite))),
                                          RoundedButton(
                                            text: "Verify",
                                            width: size.width * 0.3,
                                            fontSize: 15,
                                            textColor: DarkBlueBG,
                                            backGroundColor: BottomAppBarColor,
                                            horizontalPadding: 15,
                                            onPressed: () async {
                                              if (_formKeyOTP.currentState
                                                  .validate()) {
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
                                                          smsCode:
                                                          otpController
                                                              .text
                                                              .toString()))
                                                      .then((user) async => {
                                                    //sign in was successful
                                                    if (user != null)
                                                      {
                                                        await _fireStore
                                                            .collection(
                                                            'users')
                                                            .doc(_auth
                                                            .currentUser
                                                            .uid)
                                                            .set({
                                                          'First name':
                                                          firstNameController
                                                              .text
                                                              .trim(),
                                                          'Second name':
                                                          secondNameController
                                                              .text
                                                              .trim(),
                                                          'Phone number':
                                                          cellNumberController
                                                              .text
                                                              .trim(),
                                                          'Shop name':
                                                          shopNameController
                                                              .text
                                                              .trim(),
                                                          'Shop type':
                                                          shopTypeController,
                                                          'Shop Address':
                                                          shopAddressController
                                                              .text
                                                              .trim(),
                                                          'Shop Size': shopSizeController,
                                                        }, SetOptions(merge: true)).then(
                                                                (value) =>
                                                            {
                                                              setState(() {
                                                                isLoading = false;
                                                                canResend = false;
                                                              })
                                                            }),

                                                        _timer.cancel(),
                                                        //store registration details in fire store database
                                                        setState(() {
                                                          isLoading =
                                                          false;
                                                          canResend =
                                                          false;
                                                        }),
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                            context) =>
                                                                BusinessExistScreen(),
                                                          ),
                                                              (route) =>
                                                          false,
                                                        )
                                                      }
                                                  })
                                                      .catchError((error) => {
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
                        ]));
              },
            ),
            backgroundColor: LightBlueBG,
          );
        });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('Gideon test 1');
    var phoneNumber = '+2 ' + cellNumberController.text.toString();
    debugPrint('Gideon test 2');
    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
          if (user != null)
            {
              //store registration details in fire store database
              await _fireStore
                  .collection('users')
                  .doc(_auth.currentUser.uid)
                  .set({
                'First name': firstNameController.text.trim(),
                'Second name': secondNameController.text.trim(),
                'Phone number': cellNumberController.text.trim(),
                'Shop name': shopNameController.text.trim(),
                'Shop type': shopTypeController,
                'Shop Address': shopAddressController.text.trim(),
                'Shop Size': shopSizeController,
              }, SetOptions(merge: true))
                  .then((value) => {
                //then move to authorised area
                setState(() {
                  isLoading = false;
                  isRegister = false;
                  isOTPScreen = false;

                  //navigate to is
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          BusinessExistScreen(),
                    ),
                        (route) => false,
                  );
                }),
                _timer.cancel(),
                _events.close(),
              })
                  .catchError((onError) => {
                debugPrint('Error saving user to db.' +
                    onError.toString()),
                displaySnackBar("Error saving user to db.")
              })
            }
        });
        debugPrint('Gideon test 4');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Gideon test 5' + error.message);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        debugPrint('Gideon test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
          isOTPScreen = true;
          popupVerification(context);
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Gideon test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 90),
    );
    debugPrint('Gideon test 7');
    await verifyPhoneNumber;
    debugPrint('Gideon test 8');
  }
}
*/
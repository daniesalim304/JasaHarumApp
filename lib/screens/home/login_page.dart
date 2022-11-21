import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasaharum/home.dart';
import 'package:jasaharum/screens/authenticate/login_box.dart';
import 'package:jasaharum/services/auth.dart';
import 'package:jasaharum/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final _formKey = GlobalKey<FormState>();
  String phoneNo;
  String smsCode;
  String verificationId;
  String status;
  String smsOTP;
  String errorMessage = '';

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print('Auth Credential Error : $e');
    });
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      HomeApp();
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
        HomeApp();
      });
    };

    final PhoneVerificationCompleted verifiedSucess = (AuthCredential user) {
      print('verified');
      HomeApp();
    };

    final PhoneVerificationFailed veriFailed = (AuthException execption) {
      print('${execption.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSucess,
        verificationFailed: veriFailed);
  }

  Future<void> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Masukkan Kode OTP yang masuk ke Inbox'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) {
                      if (user != null) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/homepage');
                      } else {
                        Navigator.of(context).pop();
                        signIn();
                      }
                    });
                  },
                  child: Text('Done'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    routes:
    <String, WidgetBuilder>{
      '/homepage': (BuildContext context) => HomeApp(),
      '/landingpage': (BuildContext context) => SignIn()
    };
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        'assets/image/logo.png',
                        height: 315,
                        width: 315,
                      ),
                      Container(
                          height: 175,
                          width: 320,
                          padding: EdgeInsets.only(
                              top: 9, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(211, 211, 211, 1),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: SingleChildScrollView(
                              child: Container(
                                  child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text("Login",
                                    style: TextStyle(
                                        fontFamily: 'GoogleFont',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 30.0)),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          validator: (val) => val.isEmpty
                                              ? 'Masukkan terlebih dahulu nomor telepon'
                                              : null,
                                          decoration: InputDecoration(
                                            labelText:
                                                "+62 (Nomor Telepon Tanpa Angka 0)",
                                          ),
                                          onChanged: (value) {
                                            this.phoneNo = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color:
                                                Color.fromRGBO(15, 76, 117, 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        6)),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                verifyPhone();
                                              }
                                            },
                                            child: Text(
                                              "Kirim OTP",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'GoogleFont',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )))),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Jasa Harum Driver Login",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color.fromRGBO(15, 76, 117, 1),
                            fontSize: 13,
                          )),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                          "Hubungi admin via telepon jika mengalami gangguan login",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color.fromRGBO(15, 76, 117, 1),
                            fontSize: 10,
                          )),
                      FlatButton(
                        onPressed: () {
                          _makePhoneCall('tel:081217950820');
                        },
                        child: Text(
                          "Hubungi Operator",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Color.fromRGBO(98, 194, 208, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
// onPressed: () async {

//   // if (_formKey.currentState.validate()) {
//   //   setState(() => loading = true);
//   //   dynamic result = await _auth
//   //       .signInWithEmailAndPassword(email, password);
//   //   // print(_auth.)
//   //   print(result.toString());
//   //   if (result == null) {
//   //     setState(() {
//   //       error = 'Tidak bisa login.';
//   //       loading = false;
//   //     });
//   //   }
//   // }
// },

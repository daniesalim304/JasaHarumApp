import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jasaharum/services/auth.dart';
import 'package:jasaharum/shared/loading.dart';
import 'package:jasaharum/home.dart';

class LoginBox extends StatefulWidget {
  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String phoneNo;
  String smsCode;
  String verificationId;

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });
    };

    final PhoneVerificationCompleted verifiedSucess = (AuthCredential user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
      print('verified');
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
            title: Text('Enter SMS Code'),
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

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print('Auth Credential Error : $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      labelText: "(+62) Nomor Telepon",
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
                      color: Color.fromRGBO(15, 76, 117, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          verifyPhone();
                        }
                      },
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
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

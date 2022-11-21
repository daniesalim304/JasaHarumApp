import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(211, 211, 211, 1),
      child: Center(
        child: SpinKitChasingDots(
          color: Color.fromRGBO(21, 25, 101, 1),
          size: 75,
        ),
      ),
    );
  }
}
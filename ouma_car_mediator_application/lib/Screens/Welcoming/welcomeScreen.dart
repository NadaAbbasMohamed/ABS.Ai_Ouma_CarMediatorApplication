import 'package:flutter/material.dart';
import '../../constants.dart';

class WelcomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SizedBox.expand(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        //  gradient: IntroPagesGradient,
        )

      ),
    );
  }
}


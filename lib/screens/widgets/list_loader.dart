import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListLoader extends StatelessWidget {
  final double? screenWidth;

  const ListLoader({Key? key, this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: 100,
      child: Center(
        child: SizedBox(height: 200.0, width: 200.0, child: Lottie.asset('assets/animations/loading.json')),
      ),
    );
  }
}

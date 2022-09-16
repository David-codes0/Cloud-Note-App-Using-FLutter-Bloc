import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAni extends StatefulWidget {
  const LottieAni({Key? key}) : super(key: key);

  @override
  State<LottieAni> createState() => _LottieAniState();
}

class _LottieAniState extends State<LottieAni> {
  late Widget lottie;
  @override
  void initState() {
    lottie = Lottie.asset(
      "assets/svgs/99318-hms-loading.json",
      fit: BoxFit.fill,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return lottie;
  }
}

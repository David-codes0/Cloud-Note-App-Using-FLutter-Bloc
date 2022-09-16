import 'package:flutter/cupertino.dart';
import 'package:mynotes/widgets/size_configs.dart';





const Color kPurpleColor = Color(0xff5041ff);
const Color kYellowColor = Color(0xffffB41c);
const Color kDarkWhiteColor = Color(0xffebedf1);
const Color kBlackColor = Color(0xFFE1ECFF);
const Color kLightBlackColor = Color(0xFF8A9099);
const Color kAppBackground = Color(0xff3B3B3B);

final kTitleOnboarding = TextStyle(
  fontSize: SizeConfig.blockSizeHorizontal! * 7,
  color: kBlackColor,
  fontWeight: FontWeight.bold,
);

final kSubtitleOnboarding = TextStyle(
    fontSize: SizeConfig.blockSizeHorizontal! * 4,
    color: kLightBlackColor,
    overflow: TextOverflow.ellipsis,
    fontStyle: FontStyle.italic
    );

final kTextButton = TextStyle(
  color: kPurpleColor,
  fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
  fontWeight: FontWeight.bold,
);

import 'package:flutter/material.dart';

class Constants {
  static const Color kBgColour = Color(0XFF3450A1);
  static const Color kIconColour = Color(0XFF8DAAF5);
  static const Color kReusableCardColour = Color(0XFF041955);
  static const Color kTaskItemColour = Color(0XFFC9226A);
  static const Color kFabColour = Color(0XFFC9226A);
  static const Color kProgBarColour = Color(0XFF42568E);
  static const Color kDrawerBackIcon = Color(0XFFB4BACC);

  static const double kIconSize = 30;

  static const String kWelcomeText = 'What\'s up,';
  static const String kLblCategory = 'CATEGORIES';
  static const String kLblToday = 'TODAY\'S TASKS';
  static const String kCardTitle = ' tasks';
  static const String kCardType = 'Business';
  static const String kTaskItemName = 'Daily meeting with team';
  static const String kUserName = 'Heloise Viegas';
  static const String kCategoryTile = 'Categories';
  static const String kTempTile = 'Templates';
  static const String kAnalyticsTile = 'Analytics';
  static const String kConsistency = 'Consistency';
  static const String kInputHintText = 'Enter new task';
  static const String kBtnText = 'Add Task';
  static const String kUserNameText = 'Gmail Id';
  static const String kSignInBtn = 'Sign in with Google';

  static const TextStyle kWelcomeTextStyle = TextStyle(
    fontSize: 40,
    color: Color(0XFFFCFDFE),
    fontWeight: FontWeight.bold,
  );
  static const TextStyle kLblCategoryStyle =
      TextStyle(fontSize: 18, color: Color(0XFF6784D2), letterSpacing: 1);

  static const TextStyle kCardTitleStyle = TextStyle(
    fontSize: 18,
    color: Color(0XFF42568E),
  );
  static const TextStyle kCardTypeStyle = TextStyle(
    fontSize: 25,
    color: Color(0XFFE8E9EF),
    fontWeight: FontWeight.bold,
  );
  static const TextStyle kTaskItemStyle = TextStyle(
    fontSize: 23,
    color: Color(0XFFB4BACC),
  );
  static const TextStyle kTaskItemStrikeStyle = TextStyle(
    fontSize: 23,
    color: Color(0XFFB4BACC),
    decoration: TextDecoration.lineThrough,
  );
  static const TextStyle kInputTextStyle = TextStyle(
    fontSize: 30,
    color: Color(0xFF546E7A),
  );
  static const TextStyle kInputHintStyle = TextStyle(
    fontSize: 30,
    color: Color(0xFFB0BEC5),
    // fontWeight: FontWeight.bold,
  );

  static const TextStyle kSignInBtnStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}

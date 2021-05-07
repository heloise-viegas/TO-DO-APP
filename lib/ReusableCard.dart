import 'package:flutter/material.dart';

import 'constants.dart';

class ReusableCard extends StatelessWidget {
  final Animation progressBarColour =
      new AlwaysStoppedAnimation<Color>(Constants.kTaskItemColour);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130,
        width: 210,
        decoration: BoxDecoration(
          color: Constants.kReusableCardColour,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constants.kCardTitle,
                style: Constants.kCardTitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                Constants.kCardType,
                style: Constants.kCardTypeStyle,
              ),
              SizedBox(
                height: 20,
              ),
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Constants.kProgBarColour,
                valueColor: progressBarColour,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

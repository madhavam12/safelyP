import 'package:flutter/material.dart';

void showInLoading({
  @required String value,
  @required Color color,
  @required BuildContext context,
}) {
  FocusScope.of(context).requestFocus(new FocusNode());

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "WorkSansSemiBold"),
        ),
        Container(
          margin: EdgeInsets.only(left: 5.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    ),
    backgroundColor: color,
  ));
}

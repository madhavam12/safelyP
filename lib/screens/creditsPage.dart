import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Text(
              "All the illustrations(graphics) used in the app are downloaded from https://icons8.com/ and flaticon.com. I'm really thankful to them for letting me use their graphics for free.",
              maxLines: 15,
              style: TextStyle(
                color: Colors.orange,
                fontFamily: "QuickSand",
                fontSize: 25,
              )),
        ),
      ),
    );
  }
}

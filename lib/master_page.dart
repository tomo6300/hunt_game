import 'package:flutter/material.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Text(
          "Master Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

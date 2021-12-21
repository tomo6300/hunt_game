import 'package:flutter/material.dart';
import 'package:hunt_game/beast_page.dart';
import 'package:hunt_game/human_page.dart';
import 'package:hunt_game/master_page.dart';

class TabPage extends StatelessWidget {
  final _tab = <Tab>[
    const Tab(text: 'Human', icon: Icon(Icons.person)),
    const Tab(text: 'Master', icon: Icon(Icons.remove_red_eye)),
    const Tab(text: 'Beast', icon: Icon(Icons.grass)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("狩猟ボードゲーム"),
          bottom: TabBar(
            tabs: _tab,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HumanPage(),
            MasterPage(),
            BeastPage(),
          ],
        ),
      ),
    );
  }
}

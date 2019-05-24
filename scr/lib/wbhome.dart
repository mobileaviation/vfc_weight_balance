import 'package:flutter/material.dart';
import 'wb_settings.dart';
import 'wb_text.dart';
import 'wbhome-content.dart';
import 'Airplanes.dart';

class WBHomePage extends StatelessWidget {
  WBHomePage({Key key, this.title, this.airplane}) : super(key: key);

  String title;
  Airplane airplane;

  void _selected(Choice choice, BuildContext context)
  {
    switch (choice.type) {
      case ChoiceType.settings : {
        // Navigate to settings screen
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                WBSettingsPage()));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      new Scaffold(
        appBar: new AppBar(

          title: new Text(
            title,
            style: new TextStyle(
                color: Colors.white, fontFamily: 'Nunito', letterSpacing: 1.0, fontSize: 15),
          ),
          backgroundColor: new Color(0xFF2979FF),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (Choice choice) => { _selected(choice, context) } ,
              itemBuilder: (BuildContext context) {
                return menus.map((Choice menu) {
                  return PopupMenuItem<Choice> ( value: menu, child: ChoiceCard(choice: menu,),);
                }).toList();
              },
            )
          ],
        ),
        body: new WBHomepageContent(title: title, airplane: airplane,));
  }
}

enum ChoiceType {
  settings
}

class Choice {
  const Choice({this.title, this.icon, this.type});

  final ChoiceType type;
  final String title;
  final IconData icon;
}

const List<Choice> menus = const <Choice>[
  const Choice(title: 'Settings', icon: Icons.settings, type: ChoiceType.settings)
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return
    Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 20, color: textStyle.color),
            getText("  " + choice.title, 20),
          ],

    );
  }
}
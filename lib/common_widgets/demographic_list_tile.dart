import "package:flutter/material.dart";

class DemographicListTile extends StatelessWidget {
  DemographicListTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.fontColor: Colors.white,
    this.color: Colors.black45,
  });
  final String title;
  final String subtitle;
  final icon;
  final Color fontColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Center(
        child: Card(
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: icon,
                title: Text(
                  '$title',
                  style: TextStyle(fontFamily: 'Futura', color: fontColor),
                ),
                subtitle: Text(
                  '$subtitle',
                  style: TextStyle(fontFamily: 'Futura', color: fontColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

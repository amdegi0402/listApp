import 'package:flutter/material.dart';
import 'main.dart';
import 'package:campers_item/editList.dart';

//drawerメニューリスト
Widget drawerMenu(BuildContext context) {
  return ListView(
    children: <Widget>[
      /*DrawerHeader(
              child: Text("Drawer", style: TextStyle(fontSize: 24, color: Colors.blue,),),
              decoration: BoxDecoration(color: Colors.black,),
            ),*/
      ListTile(
          leading: Icon(Icons.home),
          title: Text(
            "HOME",
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  //settings: RouteSettings(name: "/rooms/<roomId>"),
                  builder: (BuildContext context) =>
                      MyApp(), //引数に県ナンバーを挿入して値を渡す
                ));
          }),
      ListTile(
          leading: Icon(Icons.add),
          title: Text(
            "追加・削除",
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  //settings: RouteSettings(name: "/rooms/<roomId>"),
                  builder: (BuildContext context) =>
                      MyApp2(), //編集画面へ
                ));
          }),
    ],
  );
}

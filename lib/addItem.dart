import 'package:flutter/material.dart';
import 'db_start.dart';
import 'main.dart';
//import 'editList.dart';
import 'drawerMenu.dart';
import 'package:campers_item/editList.dart';

class AddList extends StatefulWidget {
  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final myController_1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("新規追加"),backgroundColor: Colors.lightGreen.withOpacity(0.5)),
        drawer: Drawer(
          child: drawerMenu(context),
        ),
        body: Stack(children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(),
          ),
          Column(
            children: <Widget>[
              //Padding(padding: EdgeInsets.all(10.0), child: Text(date(0))),
              Padding(
                padding: EdgeInsets.only(
                    top: 50.0, left: 10.0, right: 10.0, bottom: 20.0),
                child: TextField(
                  obscureText: false, //文字にマスク処理 true or false
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '追加するアイテム名を入力してください',
                  ),
                  controller: myController_1,
                ),
              ),

              RaisedButton(
                child: Text("登録"),
                shape: UnderlineInputBorder(),
                onPressed: () async {
                  if (myController_1.text == "") {
                    //print("科目名が入力されていません");
                  } else {
                    var str = myController_1.text;
                    print(myController_1.text);
                    addItem(str);
                    myController_1.clear();

                    //完了ダイアログ表示
                    var result = await showDialog<int>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('登録完了'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () => Navigator.pushNamed(context, '/MyApp2'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ]));
  }
}

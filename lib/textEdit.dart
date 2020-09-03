import 'package:flutter/material.dart';
//import '../../function/dateFunc.dart';
import 'package:campers_item/db_start.dart';
import 'package:campers_item/main.dart';
import 'package:campers_item/drawerMenu.dart';

/*リスト内編集ファイル*/

class TextEdit extends StatefulWidget {
  String catch_id; //main.dartから受け取ったid

  TextEdit({this.catch_id}); //受け取った変数の値をセット

  @override
  State createState() {
    return TextEditState(name_id: catch_id);
  }
}

class TextEditState extends State<TextEdit> {
  String name;
  String name_id;
  Map<String, bool> data;

  TextEditingController controller_name;

  //List<String> listItem;

  TextEditState({this.name_id});

  _initReadItem(String id) async {
    data = await readValue(id);
    name = data.keys.toString();
    //data.keysを確認すると不要な（）が入るため文字のみを帰抜き出す処理
    String sname = name.substring(1, name.length - 1);
    setState(() {
      controller_name = TextEditingController(text: sname);
    });
  }

  @override
  void initState() {
    super.initState();
    _initReadItem(name_id);
    /*
    var data = readValue(name_id); //タイトル,キーワード読み込み
    data.then((var ndatas) => setState(() {
          String sname = ndatas.keys.toString();
          name = sname.substring(1, sname.length - 1);
          //keyword = ndatas[1];
          controller_name = TextEditingController(text: name);
          //controller_keyword = TextEditingController(text: keyword);
        }));
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text("アイテム名を編集"),
            backgroundColor: Colors.blueGrey.withOpacity(0.5)),
        drawer: Drawer(
          child: drawerMenu(context),
        ),
        body: Stack(children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(
                /*
              image: new DecorationImage(
                image: new AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
              */
                ),
          ),
          //showText(context, title, keyword, id)
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: false, //文字にマスク処理 true or false
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'アイテム名',
                  ),
                  controller: controller_name,
                ),
              ),
              RaisedButton(
                child: Text("登録"),
                shape: UnderlineInputBorder(),
                onPressed: () async {
                  //編集内容を更新する処理
                  //print(controller_name.text);
                  updateName(controller_name.text, name_id);

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
                },
              ),
            ],
          ),
        ]));
  }
}
// StatelessWidgetを使用する
// TextFieldの変更が反映されない
/*
class MyStatelessWidget extends StatelessWidget {
  TextEditingController controller;

  MyStatelessWidget() {
    controller = TextEditingController(text: "default1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyStatelessWidget"),
      ),
      body: TextField(
        controller: controller,
      ),
    );
  }
}


// StatefullWidgetを使用する
// TextFieldの変更が反映される
class MyStatefullWidget extends StatefulWidget {
  @override
  State createState() {
    return MyStatefullWidgetState();
  }
}

class MyStatefullWidgetState extends State<MyStatefullWidget> {
  TextEditingController controller;

  MyStatefullWidgetState() {
    controller = TextEditingController(text: "test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyStatelessWidget"),
      ),
      body: TextField(
        controller: this.controller,
      ),
    );
  }
}
*/

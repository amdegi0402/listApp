import 'package:flutter/material.dart';
import 'package:campers_item/db_start.dart';
import 'package:campers_item/drawerMenu.dart';
import 'package:campers_item/editList.dart';
//import 'package:campers_item/addItem.dart';

void main() {
  runApp(MaterialApp(
      //画面遷移の初期設定
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => MyApp(),
        '/MyApp2': (context) => MyApp2(),
      }));
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'CamperdItems';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
/*Field*/
  Map<String, bool> values = {};

/*myFunction*/
  //initState内の初期化処理
  _readInitFunc() async {
    await createDatabase();
    //await Future.delayed(new Duration(seconds: 5));
    var result = await readValue();

    setState(() {
      values = result;
    });
  }

  //荷物チェック処理（すべてにチェックが入っているかどうか確認）
  _checkItems() async {
    int cnt = 0;
    var data = await readItemData(2);
    //print("data=$data");
    data.forEach((String juge) {
      if (juge == "0") {
        cnt += 1;
      }
    });
    if (cnt == 0) {
      print("true");
      return 0;
    } else {
      print("false");
      return 1;
    }
  }

  //荷物チェック後結果に応じて表示するダイアログ処理
  _resultMessage(var juge) {
    String message;
    if (juge == 0) {
      message = "荷物チェック完了";
    } else {
      message = "チェックしていない荷物があります！";
    }
    return message;
  }

/*メイン処理 */
  //初期化処理
  @override
  initState() {
    super.initState();
    _readInitFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => {
              setChecks(0),
              Navigator.pushNamed(context, '/')
            },
          ),
        ], title: Text("アイテムリスト"), backgroundColor: Colors.lightGreen.withOpacity(0.5)),
        //brightness: Brightness.dark),
        drawer: Drawer(
          child: drawerMenu(context),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: ListView(
            children: values.keys.map((String key) {
              return CheckboxListTile(
                activeColor: Colors.red,
                title: Text(key),
                value: values[key],
                onChanged: (bool value) {
                  setState(() {
                    values[key] = value;
                  });
                },
              );
            }).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            updateEditList(values);
            var juge = await _checkItems(); //荷物がすべてチェックされている確認する処理
            //完了ダイアログ表示
            showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(_resultMessage(juge)), //jugeの結果によってメッセージを変える処理
                  actions: <Widget>[
                    FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(1);
                          //updateInitJuge();
                        }),
                  ],
                );
              },
            );
          },
          label: Text('OK'),
          icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.pink,
        ));
  }
}

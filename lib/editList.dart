//import 'package:flutter/rendering.dart';
import 'package:campers_item/db_start.dart';
import 'package:flutter/material.dart';
//import 'package:campers_item/db_start.dart';
//import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:campers_item/drawerMenu.dart';
import 'package:campers_item/main.dart';
import 'addItem.dart';
import 'package:campers_item/addItem.dart';
import 'package:campers_item/textEdit.dart';
//import 'package:flutter/foundation.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "キャンテムCheck", home: EditList(), routes: {
      '/AddList': (context) => AddList(),
    });
  }
}

class EditList extends StatefulWidget {
  @override
  Edits createState() => Edits();
}

class Edits extends State<EditList> {
  List<String> itemName = [];
  List<String> itemId = [];
  //int _count = 0;

  //initState内の初期化処理
  _readInitFunc() async {
    //await createDatabase();
    //await Future.delayed(new Duration(seconds: 5));

    List<String> nresult = await readItemData(1);
    List<String> iresult = await readItemData(0);

    setState(() {
      itemName = nresult;
      itemId = iresult;
      //print("itemName.length=${itemName.length}");
    });
  }

  //データベース初期化
  _initDb() async {
    await removeRecord();
    createDatabase();
    _dialog();
  }

  _dialog() async {
    await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('リストの内容を初期値に戻しますがよろしいですか？'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => {Navigator.pushNamed(context, '/MyApp2')},
            ),
            FlatButton(
              child: Text('キャンセル'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _setDeleteItem(String itemNames) async {
    await deleteDb(itemNames);
    //itemName.removeWhere((t) => t == itemNames);
    //await Future.delayed(const Duration(seconds: 3));
  }

  @override
  initState() {
    super.initState();
    _readInitFunc(); //database読み込み処理
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("追加と削除"),
        backgroundColor: Colors.lightGreen.withOpacity(0.5),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {Navigator.pushNamed(context, '/AddList')},
          ),
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: () => _initDb(),
          ),
        ],
      ),
      drawer: Drawer(
        child: drawerMenu(context),
      ),
      body: listBuild(context),
    );
  }

  @override
  Widget listBuild(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: itemName.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                //リストの区切り線
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black38),
                  ),
                ),
                child: Dismissible(
                  //スワイプでリストを削除する処理
                  key: Key(itemName[index]),
                  child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text(itemName[index]),
                      //subtitle: Text("${day[index]}に登録  NEXT ${next_day[index]}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextEdit(
                                catch_id: itemId[
                                    index]), //次のページへ　科目名,キーワード,idを渡す処理　EditListクラスが呼び出される edit.dart
                            //builder: (context) => MyStatefullWidget(),
                          ),
                        );
                      }),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    //データベースからリストを削除
                    // 削除アニメーションが完了し、リサイズが終了したときに呼ばれる
                    itemName.removeWhere((t) => t == itemName[index]);
                    _setDeleteItem(itemId[index]);
                    //setState(() {});
                  },
                ),
              );
            }));

    
  }
}

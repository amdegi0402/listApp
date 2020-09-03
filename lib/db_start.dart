import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:collection';

//テーブル書式設定
void populateDb(Database database, int version) async {
  //id:プライマリキー name:アイテムネーム juge:チェックボックス　true=1,false=0
  await database.execute(
      "CREATE TABLE MyDatas(id INTEGER PRIMARY KEY, name TEXT, juge INTEGER)" //テーブル作成
      );
}

//database start(初期設定)
createDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db'); //データベース　テーブル作成

  var database =
      await openDatabase(dbPath, version: 1, onCreate: populateDb); //
  //print("データベース登録OK");
  var result = await database.rawQuery("select count(id) from MyDatas");
  var val = result[0]["count(id)"]; //テーブルにデータが1つ以上入っているか確認
  print("val=$val");
  if (val == 0) {
    //print("初期データセット");
    database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("テント", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("グラウンドシード", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("パーソナルマット", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("寝袋", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ランタン", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ペグ一式", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ハンマー", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ヘッドライト", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("テーブル", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("チェアー", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ガスコンロ", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ケトル", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("インスタントコーヒー", 0)');
      await txn.rawInsert(
          'INSERT INTO MyDatas(name, juge) VALUES("各種燃料（炭・ボンベ・着火剤）", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("まな板・ナイフ", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("食器", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("クーラーボックス", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("保冷剤", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ライター・バーナー", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("軍手", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("うちわ", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("新聞紙", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ゴミ袋", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ゴム手袋（水仕事用）", 0)');
      await txn.rawInsert(
          'INSERT INTO MyDatas(name, juge) VALUES("洗剤・スポンジ・たわし", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("洗顔セット・歯ブラシ", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("アルミホイル", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("ぞうきん", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("救急セット", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("虫よけスプレー", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("防寒着", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("着替え", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("タオル", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("帽子", 0)');
      await txn
          .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("レインウェア", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("食材", 0)');
      await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("タープ", 0)');
      print("databaseOK");
    });
  }
}

//データ挿入
addDatabase(String name, [int juge = 0]) async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db'); //データベース　テーブル作成
  var database =
      await openDatabase(dbPath, version: 1, onCreate: populateDb); //
  //データベースへ値を挿入
  database.transaction((txn) async {
    await txn
        .rawInsert('INSERT INTO MyDatas(name, juge) VALUES("$name", "$juge")');
    //print("databaseOK");
  });
}

//データ読み込み nameとjugeをmap型で返す処理
Future readValue([String id]) async {
  Map<String, bool> data = LinkedHashMap();
  bool juges;
  String ids = id;
  //List<String> result = []; //DBアクセス

  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);

  //idの指定が無ければすべてのレコード,idの指定ありであれば該当のレコードを読み込み
  if (ids == null) {
    List name = await database.rawQuery('SELECT name FROM MyDatas');
    List juge = await database.rawQuery('SELECT juge FROM MyDatas');

    for (int i = 0; i < name.length; i++) {
      juges = returnJuge(juge[i]["juge"].toString());
      data[name[i]["name"].toString()] = juges;
    }
  } else {
    List name =
        await database.rawQuery('SELECT name FROM Mydatas WHERE id="$ids"');
    List juge =
        await database.rawQuery('SELECT juge FROM Mydatas WHERE id="$ids"');

    for (int i = 0; i < name.length; i++) {
      juges = returnJuge(juge[i]["juge"].toString());
      data[name[i]["name"].toString()] = juges;
    }
  }
  //print("data=$data");
  return data;
}

//データ読み込み name or idをリスト型で返す処理 0:id 1:name 2:juge
Future readItemData(int num) async {
  List<String> data = [];
  //List<String> result = []; //DBアクセス

  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);

  if (num == 0) {
    List result = await database.rawQuery('SELECT id FROM MyDatas');
    for (int i = 0; i < result.length; i++) {
      data.add(result[i]["id"].toString());
    }
  } else if (num == 1) {
    List result = await database.rawQuery('SELECT name FROM MyDatas');
    //print("data=$result");
    for (int i = 0; i < result.length; i++) {
      data.add(result[i]["name"].toString());
    }
  } else if (num == 2) {
    List result = await database.rawQuery('SELECT juge FROM MyDatas');
    //print("data=$result");
    for (int i = 0; i < result.length; i++) {
      data.add(result[i]["juge"].toString());
    }
  }

  return data;
}

//juge データベースから呼び出した値が0であればfalse,1であればtrueに変換する処理
bool returnJuge(String juge) {
  bool result;
  if (juge == "0") {
    result = false;
  } else {
    result = true;
  }
  return result;
}

//update 削除したリストのresultを0に変更（これによりリスト検索から外れるようにする）
deleteDb(String itemId) async {
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  //指定テーブルから選択した山データのsel値を更新　0->1
  await database.rawQuery('DELETE FROM MyDatas WHERE id="$itemId"');
  //print("DELETE compleate!");
}

//特定の文字列を含むレコードを探す
searchStr(String searchStr) async {
  List<String> data = [];
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  //print("str=$searchStr");
  var value = await database
      .rawQuery("SELECT name FROM MyDatas WHERE name LIKE '%$searchStr%'");
  //print("科目名={$value}");
  //print("データは${value.length}");
  for (var i = 0; i < value.length; i++) {
    data.add(value[i]["name"].toString());
  }
  return data;
}

//テーブルレコードをすべて削除
removeRecord() async {
  List<String> data = [];
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  //print("str=$searchStr");
  await database.rawQuery("DELETE FROM MyDatas");
}

//アイテムを新規追加
addItem(String name) async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db'); //データベース　テーブル作成
  var database =
      await openDatabase(dbPath, version: 1, onCreate: populateDb); //
  //データベースへ値を挿入
  database.transaction((txn) async {
    await txn.rawInsert('INSERT INTO MyDatas(name, juge) VALUES("$name", "0")');
    //print("databaseOK");
  });
}

//update Mapの内容を編集して登録する処理(id: リストのid num 0: タイトル編集　1:キーワード編集　value:編集内容)
updateEditList(Map<String, bool> itemList) async {
  int ivalue;
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  //bool値を整数型に変換（true:1 false:0)
  //var juges = itemList.values;
  //List<String> names = itemList.keys;
  itemList.forEach((var key, var value){
    if (value == true) {
      ivalue = 1;
    } else {
      ivalue = 0;
    }
    database.rawQuery('UPDATE MyDatas SET juge="$ivalue" WHERE name="$key"');
  });
}

//update アイテム名を編集して登録する処理(iname: 編集後のアイテム名, itemID:対象のアイテムID)
updateName(String iname, String itemId) async {
 
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  
  await database.rawQuery('UPDATE MyDatas SET name="$iname" WHERE id="$itemId"');

}

//リストすべてに一括チェック処理 0:すべてのチェックを外す　1:すべてのチェックを入れる
setChecks(int num)async{
  //databaseへ接続
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');
  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  if(num == 1){
    await database.rawQuery('UPDATE MyDatas SET juge=1');
  }else if(num == 0){
    await database.rawQuery('UPDATE MyDatas SET juge=0');
  }
  
}

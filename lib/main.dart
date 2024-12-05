import 'package:flutter/material.dart';
import 'package:campers_item/db_start.dart';
import 'package:campers_item/drawerMenu.dart';
import 'package:campers_item/editList.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': MyApp.new,
        '/MyApp2': MyApp2.new,
      }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'CamperItems';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Map<String, bool> values = {};

  Future<void> _readInitFunc() async {
    await createDatabase();
    final result = await readValue();

    setState(() {
      values.addAll(result);
    });
  }

  Future<int> _checkItems() async {
    final data = await readItemData(2);
    final uncheckedCount = data.where((value) => value == "0").length;
    
    return uncheckedCount == 0 ? 0 : 1;
  }

  String _resultMessage(int status) {
    return status == 0 
        ? "荷物チェック完了"
        : "チェックしていない荷物があります！";
  }

  @override
  void initState() {
    super.initState();
    _readInitFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'チェックをクリア',
            onPressed: () {
              setChecks(0);
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
        title: const Text("アイテムリスト"),
      ),
      drawer: Drawer(
        child: drawerMenu(context),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: ListView(
          children: values.keys.map((String key) {
            return CheckboxListTile(
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text(key),
              value: values[key],
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    values[key] = value;
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await updateEditList(values);
          final status = await _checkItems();
          
          if (!mounted) return;
          
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(_resultMessage(status)),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        label: const Text('OK'),
        icon: const Icon(Icons.thumb_up),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notesimple/database_instance.dart';

import 'insert_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomeState();
  }
}

class MyHomeState extends State<MyHome> {
  DatabasesInstance? databasesInstance;

  Future<void> initDatabases() async {
    await databasesInstance!.databases();
    setState(() {});
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  Future deleteItem(int id) async {
    await databasesInstance!.deleted(id);
    setState(() {});
  }

  @override
  void initState() {
    databasesInstance = DatabasesInstance();
    initDatabases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0X0F121212),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Note Simple',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Sarabun',
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(110, 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Color.fromARGB(255, 62, 119, 111)),
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InsertData()))
                    .then((value) {
                  setState(() {});
                });
              },
              child: Text(
                'Add',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sarabun',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: RefreshIndicator(
          color: Colors.amber,
          backgroundColor: Colors.white,
          onRefresh: _refreshData,
          child: databasesInstance != null
              ? FutureBuilder(
                  future: databasesInstance!.all(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Center(
                          child: emptyData(),
                        );
                      }
                      return Center(
                        child: Text(
                          'Example',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                  }))
              : Center(
                  child: Text(
                    'Not Have Data',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
    );
  }

  Widget emptyData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/writing.png',
          height: 280,
          width: 280,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Writing Now',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 233, 232),
              fontFamily: 'Sarabun',
              fontSize: 28,
              fontWeight: FontWeight.w900),
        )
      ],
    );
  }
}

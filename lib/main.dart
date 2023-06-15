import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notesimple/database_instance.dart';
import 'package:notesimple/datamodel.dart';
import 'package:notesimple/edit_data.dart';
import 'package:notesimple/view.data.dart';

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
      backgroundColor: const Color(0xFF282a36),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Note Simple',
          style: TextStyle(
              color: Color(0xfff8f8f2),
              fontFamily: 'Sarabun',
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => InsertData())))
                    .then((value) {});
              },
              icon: Icon(
                Icons.add,
                color: Color(0xff50fa7b),
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: RefreshIndicator(
          color: Color(0xff50fa7b),
          backgroundColor: const Color(0xFF282a36),
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
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                hasDataNote(
                                    snapshot.data?[index].id,
                                    snapshot.data![index].title,
                                    snapshot.data![index].description,
                                    snapshot.data![index].create_at,
                                    snapshot.data![index]),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          });
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

  Widget hasDataNote(
    int? id,
    String titile,
    String description,
    String create_at,
    DataModel dataUser,
  ) {
    return Container(
      height: 160,
      width: 360,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xffBEE3DB)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, top: 12, right: 12),
            child: Text(
              '${titile}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 46,
            child: Container(
              padding: EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Text(
                '${description}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 83,
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    '${create_at}',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 115),
                child: IconButton(
                  onPressed: () {
                    deleteItem(id ?? 0);
                  },
                  icon: Icon(Icons.remove_circle_outlined),
                ),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditData(
                                  dataModel: dataUser,
                                )));
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Color(0xff89B0AE),
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewData(
                                    dataModel: dataUser,
                                  )));
                    },
                    icon: Icon(Icons.keyboard_arrow_right)),
              )
            ],
          )
        ],
      ),
    );
  }
}

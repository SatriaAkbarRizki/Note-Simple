import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:notesimple/model/database_instance.dart';
import 'package:notesimple/model/datamodel.dart';
import 'package:notesimple/controller/edit_data.dart';
import 'package:notesimple/controller/insert_data.dart';
import 'package:notesimple/controller/view.data.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyHomeState();
  }
}

class MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  DatabasesInstance? databasesInstance;
  late FlutterGifController _controller;

  Future<void> initDatabases() async {
    setState(() {});
  }

  Future<void> _refreshData() async {
    await databasesInstance != null;
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
    _controller = FlutterGifController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282a36),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
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
                context.pushTransparentRoute(const InsertData()).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(
                Icons.add,
                color: Color(0xff50fa7b),
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: RefreshIndicator(
          color: const Color(0xff50fa7b),
          backgroundColor: const Color(0xFF282a36),
          onRefresh: _refreshData,
          child: databasesInstance != null
              ? FutureBuilder<List<DataModel>?>(
                  future: databasesInstance!.all(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: emptyData(),
                        );
                      }
                      return SafeArea(
                          child: ListView.builder(
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
                                        snapshot.data![index],
                                        context),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                );
                              }));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                  }))
              : const Center(
                  child: Text(
                    'Not Have Data',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
    );
  }

  Widget emptyData() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: SvgPicture.asset(
              'assets/images/writing.svg',
              width: 400,
            ),
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
      ),
    );
  }

  Widget hasDataNote(int? id, String titile, String description,
      String createAt, DataModel dataUser, BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: 160,
      width: 300 * _mediaQuery.width, // Not Fix
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffBEE3DB)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
            child: Text(
              titile,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 46,
            child: Container(
              padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 83,
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    createAt,
                    style: const TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 115),
                child: IconButton(
                  onPressed: () {
                    deleteItem(id ?? 0);
                  },
                  icon: const Icon(Icons.remove_circle_outlined),
                ),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    context.pushTransparentRoute(
                        transitionDuration: const Duration(seconds: 1),
                        EditData(
                          dataModel: dataUser,
                        ));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff89B0AE),
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                    onPressed: () {
                      context.pushTransparentRoute(
                          transitionDuration: const Duration(seconds: 1),
                          ViewData(
                            dataModel: dataUser,
                          ));
                    },
                    icon: const Icon(Icons.keyboard_arrow_right)),
              )
            ],
          )
        ],
      ),
    );
  }
}

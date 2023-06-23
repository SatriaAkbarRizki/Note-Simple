import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:notesimple/model/database_instance.dart';
import 'package:notesimple/model/datamodel.dart';
import 'package:notesimple/controller/edit_data.dart';
import 'package:notesimple/controller/insert_data.dart';
import 'package:notesimple/controller/view.data.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282a36),
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          Hero(tag: Text('insert'), child: IconButton(
              onPressed: () {
                context.pushTransparentRoute(
                          transitionDuration: const Duration(milliseconds: 600),
                   InsertData()).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(
                Icons.add,
                color: Color(0xff50fa7b),
              ))),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: RefreshIndicator(
          color: const Color(0xff50fa7b),
          backgroundColor: const Color(0xFF282a36),
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'My',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'lufga',
                          fontSize: 55),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'lufga',
                          fontSize: 50),
                    ),
                  ),
                  databasesInstance != null
                      ? FutureBuilder<List<DataModel>?>(
                          future: databasesInstance!.all(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: emptyData(),
                                );
                              }
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: Duration(seconds: 2),
                                        child: FadeInAnimation(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            hasDataNote(
                                                snapshot.data?[index].id,
                                                snapshot.data![index].title,
                                                snapshot
                                                    .data![index].description,
                                                snapshot.data![index].create_at,
                                                snapshot.data![index],
                                                context),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        )));
                                  });
                            } else {
                              return const Center(
                                child: SizedBox(
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                ),
                              );
                            }
                          }))
                      : const Center(
                          child: Text(
                            'Not Have Data',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                ],
              )
            ],
          )),
    );
  }

  Widget emptyData() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: SvgPicture.asset(
              'assets/images/notfound.svg',
              height: 300,
              width: 400,
            ),
          ),
          Text(
            'no records here',
            style: TextStyle(
                color: Color.fromARGB(255, 231, 233, 232),
                fontFamily: 'Sarabun',
                fontSize: 22,
                fontWeight: FontWeight.w500),
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
      width: _mediaQuery.width / 1.1, // Not Fix
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
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
                child: IconButton(
                  onPressed: () {
                    deleteItem(id ?? 0);
                  },
                  icon: const Icon(Icons.remove_circle_outlined),
                ),
              ),
              Container(
                child: Hero(
                  tag: Text('edit'),
                  child: IconButton(
                    onPressed: () {
                      context.pushTransparentRoute(
                          transitionDuration: const Duration(milliseconds: 600),
                          EditData(
                            dataModel: dataUser,
                          ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: const Color(0xff89B0AE),
                    borderRadius: BorderRadius.circular(15)),
                child: Hero(
                    tag: Text('View'),
                    child: IconButton(
                        onPressed: () {
                          context.pushTransparentRoute(
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              ViewData(
                                dataModel: dataUser,
                              ));
                        },
                        icon: const Icon(Icons.keyboard_arrow_right))),
              )
            ],
          )
        ],
      ),
    );
  }
}

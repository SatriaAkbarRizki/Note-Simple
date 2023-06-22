import 'package:flutter/material.dart';
import 'package:notesimple/model/database_instance.dart';
import 'package:notesimple/model/datamodel.dart';
import 'package:dismissible_page/dismissible_page.dart';

class ViewData extends StatefulWidget {
  final DataModel? dataModel;
  const ViewData({super.key, this.dataModel});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  DatabasesInstance databasesInstance = DatabasesInstance();
  TextEditingController tittleText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  @override
  void initState() {
    databasesInstance.databases();
    tittleText.text = widget.dataModel!.title ?? '';
    descriptionText.text = widget.dataModel!.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    print(descriptionText);
    return DismissiblePage(
        child: Hero(
            tag: 'view',
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xFF282a36),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
                title: Container(
                  height: 50,
                  width: 500 * _mediaQuery.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(115, 54, 57, 73)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Color(0xff50fa7b))),
                      ),
                      Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: 230 * _mediaQuery.width,
                          )),
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.done_outlined,
                              color: Color(0xff50fa7b),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 16, top: 10),
                    child: TextField(
                      readOnly: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color(0xffFFFBF5), fontSize: 24),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              color: Color(0xffe9ecef), fontSize: 24)),
                      controller: tittleText,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextField(
                      readOnly: true,
                      style: const TextStyle(
                          color: Color(0xffe9ecef), fontSize: 18),
                      controller: descriptionText,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintStyle:
                            TextStyle(color: Color(0xffe9ecef), fontSize: 18),
                        hintText: 'Description',
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            )),
        onDismissed: () {
          Navigator.pop(context);
        });
  }
}

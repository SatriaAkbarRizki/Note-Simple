import 'package:flutter/material.dart';
import 'database_instance.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';

class InsertData extends StatefulWidget {
  const InsertData({super.key});

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  DatabasesInstance databasesInstance = DatabasesInstance();
  TextEditingController tittleText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  @override
  void initState() {
    databasesInstance.databases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(descriptionText);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF282a36),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(110, 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color.fromARGB(255, 62, 119, 111)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sarabun',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(110, 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color.fromARGB(255, 62, 119, 111)),
                    onPressed: () {
                      print(descriptionText);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sarabun',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Text',
                  hintStyle: TextStyle(color: Colors.white)),
              controller: tittleText,
            ),
          ),
          MarkdownField(
            controller: descriptionText,
            emojiConvert: true,
            style: TextStyle(color: Colors.white, fontFamily: 'Sarabun'),
          )
        ],
      ),
    );
  }

  // Widget writingNote(){

  // }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqllite_database/editnotes.dart';
import 'package:sqllite_database/my_bottom_navigation_bar.dart';
import 'package:toast/toast.dart';

import 'addnotes.dart';
import 'mydatabase.dart';

void main() {
  runApp(new GetMaterialApp(
    debugShowCheckedModeBanner:false,
    title: "Notes application",
    home: Notes(),
  ));
}

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final storage = new FlutterSecureStorage();
  @override
  int _currentIndex = 0;
  DatabaseHelper db = DatabaseHelper.createInstance();
  var result;
  int length=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentIndex();
    FetchNotes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notes (all)"),
      ),
      body: Material(
          color: Colors.grey.withOpacity(0.20),
          child: ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        InkWell(
                          child: Icon(Icons.delete),
                          onTap: () {
                            DeleteNote(result[index]['_id'],index);

                          },
                        ),
                        InkWell(
                          child: Icon(Icons.edit),
                          onTap: () {
                            Get.to(EditNote(result[index]['_id']));
                          },

                        ),
                        InkWell(
                          child: Icon(Icons.mobile_friendly),
                          onTap: () {
                            showDialog(context: context, builder:(context)
                            {
                              return AlertDialog(
                                title: Text("Confirm"),
                                content: Text("would you like to mark this note completed?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      String sql = "update notes set notestype=4 where _id=${result[index]['_id']}";
                                      int response = await db.RunQuery(sql);
                                      print(response);
                                      if(response==DatabaseHelper.SUCCESS)
                                        {
                                          ToastContext().init(context);
                                          Toast.show(
                                              "Notes marked as completed....",
                                              duration: Toast.lengthLong,
                                              gravity:  Toast.bottom);
                                        }
                                      Navigator.pop(context, false); //to hide dialog box
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false); //to hide dialog box
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    tileColor: Colors.white,
                    title: Container(
                        child: Text(
                          result[index]['title'],
                          textDirection: TextDirection.ltr,
                          textScaleFactor: 1.5,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black,
                          width: 3.0,
                        )))),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        result[index]['detail'],
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Get.to(AddNote());
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          setState(() => _currentIndex = value);
          MyBottomNavigationBar.ChangeScreen(context, _currentIndex);
        },
        items: MyBottomNavigationBar.getItems(),
      ),
    );
  }

  Future<void> setCurrentIndex() async {
    print('setCurrentIndex() method is called');
    await storage.write(key: 'index', value: '0');
  }

  Future<void> FetchNotes() async {
    String sql = "select * from notes";
    result = await db.FetchRow(sql);
    print(result);
    print(result.length);
    setState(() {
        length = result.length;
    });
  }

  void DeleteNote(int id,int index) {
    String sql = "delete from notes where _id=$id";
    var response = db.RunQuery(sql);
    if(response == DatabaseHelper.SUCCESS)
      {
        setState(() {
          // result.removeAt(index);
          result = List.from(result)..removeAt(index);
          length = result.length;
        });
        Toast.show(
            "Notes Deleted....",
            duration: Toast.lengthLong,
            gravity:  Toast.bottom);
      }
  }
}

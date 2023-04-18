import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqllite_database/my_bottom_navigation_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'mydatabase.dart';
import 'package:toast/toast.dart';
class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);
  @override
  _AddNoteState createState() => _AddNoteState();
}
class _AddNoteState extends State<AddNote> {
  int _currentIndex = 0,SelectedType = 1;
  double ScreenHeight = 0,ScreenWidth = 0;
  TextEditingController TitleController = new TextEditingController();
  TextEditingController DetailController = new TextEditingController();
  String title='',detail='';
  DatabaseHelper db = DatabaseHelper.createInstance();
  void initState() {
    // TODO: implement initState
    super.initState();
    TitleController.addListener(() {
      if(TitleController.text!='')
        title = TitleController.text;
    });
    DetailController.addListener(() {
      if(DetailController.text!='')
        detail = DetailController.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    ScreenWidth = MediaQuery.of(context).size.width;
    ToastContext().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: "Notes application",
      home: Builder(
        builder: (context) {
          return Scaffold(
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
                MyBottomNavigationBar.ChangeScreen(context,_currentIndex);
              },
              items: MyBottomNavigationBar.getItems(),
            ),
            appBar: AppBar(
              title: Text("Add new note"),
              backgroundColor: Colors.black,
            ),
            body : Material(
              color: Colors.cyanAccent.withOpacity(0.50),
              child: Center(
                child: SizedBox(
                  width: ScreenWidth * 0.80,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Create note",textDirection: TextDirection.ltr,textScaleFactor: 2.0,),
                            TextFormField(
                              controller: TitleController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.keyboard),
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  color: Color(0xFF6200EE),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: DetailController,
                              minLines: 5,
                              maxLines: 5,
                              decoration: InputDecoration(
                                icon: Icon(Icons.keyboard),
                                labelText: 'Detail',
                                labelStyle: TextStyle(
                                  color: Color(0xFF6200EE),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10),
                            child: Text("select type",textDirection: TextDirection.ltr,),),
                            ListTile(
                              title: Text("Urgent"),
                              leading: Radio(
                                value: 1,
                                groupValue: SelectedType,
                                onChanged: (val){
                                  setState(() {
                                    SelectedType = int.parse(val.toString());
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("Important"),
                              leading: Radio(
                                value: 2,
                                groupValue: SelectedType,
                                onChanged: (val){
                                  setState(() {
                                    SelectedType = int.parse(val.toString());
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("Normal"),
                              leading: Radio(
                                value: 3,
                                groupValue: SelectedType,
                                onChanged: (val){
                                  setState(() {
                                    SelectedType = int.parse(val.toString());
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: ScreenWidth * 0.80,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Respond to button press
                                  String sql = "insert into notes (title,notestype,detail) "
                                      "values ('$title','$SelectedType','$detail')";
                                  int response = db.RunQuery(sql);
                                  if(response== DatabaseHelper.SUCCESS)
                                  {
                                      print("Notes added");
                                      Toast.show(
                                          "Notes added....",
                                          duration: Toast.lengthLong,
                                          gravity:  Toast.bottom);
                                          Get.to(Notes());
                                          // Get.to(Notes());
                                  }
                                  else
                                  {
                                    print("Error...");
                                  }
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text("Add Notes"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
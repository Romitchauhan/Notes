import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqllite_database/my_bottom_navigation_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'addnotes.dart';
import 'main.dart';

class Urgent extends StatefulWidget {
  const Urgent({Key? key}) : super(key: key);

  @override
  _UrgentState createState() => _UrgentState();
}

class _UrgentState extends State<Urgent> {
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentIndex();
  }

  Future<void> setCurrentIndex() async {
    print('setCurrentIndex() method is called');

    storage.read(key: 'index').then((val) {
      int value = int.parse(val!.toString());
      setState(() {
        _currentIndex = value;
      });
    });
  }

  @override
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes application",
      home: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text("Urgent"),
              ),
              body: Material(
                  color: Colors.redAccent.withOpacity(0.20),
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            trailing: Wrap(
                              spacing: 12,
                              children: [
                                InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: (){

                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: (){

                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.mobile_friendly),
                                  onTap: (){

                                  },
                                ),
                              ],
                            ),
                            tileColor: Colors.redAccent.withOpacity(0.40),
                            title: Container(
                                child: Text("Urgent Notes Title",textDirection:
                                TextDirection.ltr,textScaleFactor: 1.5,),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.brown,width: 3.0,)
                                    )
                                )),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10,bottom: 10),
                              child: Text("Urgent Notes detail will be displayed here. it can be few "
                                  "line long and should be in way easy to read",
                                textDirection: TextDirection.ltr
                                ,
                              ),
                            )
                            ,
                          )
                          ,
                        );
                      })),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(PageTransition(child: AddNote(),
                      type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
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
      ),
    );
  }
}

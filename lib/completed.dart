import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqllite_database/my_bottom_navigation_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentIndex();

  }
  Future<void> setCurrentIndex() async {
    print('setCurrentIndex() method is called');
    storage.read(key: 'index').then((val){
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
      debugShowCheckedModeBanner:false,
      title: "Notes application",
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Completed"),
            ),
            body :  Material(
                color: Colors.black.withOpacity(0.20),
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          trailing: InkWell(
                            child: Icon(
                                color:Colors.white,
                                Icons.delete),
                            onTap: (){

                            },
                          ),
                          tileColor: Colors.black.withOpacity(0.40),
                          title: Container(
                              child: Text("completed Notes Title",textDirection:
                              TextDirection.ltr,textScaleFactor: 1.5,
                              style: TextStyle(
                                color: Colors.white
                              ),),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white,width: 3.0,)
                                  )
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top:10,bottom: 10),
                            child: Text("Urgent Notes detail will be displayed here. it can be few "
                                "line long and should be in way easy to read",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.white
                            )
                              ,
                            ),
                          )
                          ,
                        )
                        ,
                      );
                    })),
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
          );
        }
      ),
    );
  }
}

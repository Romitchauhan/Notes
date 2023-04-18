import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqllite_database/important.dart';
import 'package:sqllite_database/addnotes.dart';
import 'package:sqllite_database/urgent.dart';
import 'completed.dart';
import 'main.dart';
import 'normal.dart';
class MyBottomNavigationBar
{
   static List<BottomNavigationBarItem> getItems()
   {
     return [
       BottomNavigationBarItem(
         label: 'Notes',
         icon: Icon(Icons.library_books),
       ),
       BottomNavigationBarItem(
         label: 'Urgent',
         icon: Icon(Icons.airplanemode_active),
       ),
       BottomNavigationBarItem(
         label: 'Important',
         icon: Icon(Icons.timer),
       ),
       BottomNavigationBarItem(
         label: 'normal',
         icon: Icon(Icons.star),
       ),
       BottomNavigationBarItem(
         label: 'Done',
         icon: Icon(Icons.mobile_friendly),
       ),
     ];
   }
  static Future<void> ChangeScreen(BuildContext context, int currentIndex) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'index', value: currentIndex.toString());
    switch(currentIndex)
    {
      case 0:
        Navigator.of(context).push(PageTransition(child: Notes(),
            type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
        break;
      case 1:
        Navigator.of(context).push(PageTransition(child: Urgent(),
            type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
        break;
      case 2:
        Navigator.of(context).push(PageTransition(child: Important(),
            type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
        break;
      case 3:
        Navigator.of(context).push(PageTransition(child: Normal(),
            type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
        break;
      case 4:
        Navigator.of(context).push(PageTransition(child:  Completed(),
            type: PageTransitionType.leftToRight, duration: Duration(seconds: 1)));
        break;
    }
  }
}
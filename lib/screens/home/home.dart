import 'package:art_platform/models/post.dart';
import 'package:art_platform/models/user.dart';
import 'package:art_platform/screens/home/advertisement_list.dart';
import 'package:art_platform/screens/home/dashboard.dart';
import 'package:art_platform/screens/other/decorations.dart';
import 'package:art_platform/services/auth.dart';
import 'package:art_platform/screens/other/input_decoration.dart';
import 'package:art_platform/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int selectedIndex = 0;
   _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  bool _dialVisible = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Widget> widgets = [
    Dashboard(userId: user.uid,),
    AdvertisementList()
  ];
    return StreamProvider<List<Post>>.value(
      value: DatabaseService().posts,
          child: SafeArea(
            child: Scaffold(
          
          body: Container(
            child: widgets[selectedIndex],
          ),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Image.asset('assets/logo.png',width: 140,),
              flexibleSpace: Container(
                
                decoration: appBarDecoration,
              ),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Color(0xff820000),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  label: Text(
                    'Logout',
                    style: TextStyle(color: Color(0xff820000))
                  ),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.grey[400],
            backgroundColor: Color(0xff820000),
              elevation: 0,
              selectedItemColor: Colors.white,
              currentIndex: selectedIndex,
            onTap: _onItemTapped,
              items: [

                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.table),
                title: Text('Dashboard')),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.dollarSign),
                  title: Text('Advertisements')),
              ],
            ),
            floatingActionButton: SpeedDial(
              
              backgroundColor:Color(0xff820000),
              foregroundColor:Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => setState,
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              foregroundColor: Colors.white,
              child: Icon(FontAwesomeIcons.bullhorn),
              backgroundColor: Color(0xff820000),
              label: 'Add advertisement',
              labelStyle: TextStyle(fontSize: 18,color: Color(0xff820000)),
              onTap: () => Navigator.pushNamed(context, 'addAdvert')
            ),
            SpeedDialChild(
              
              child: Icon(FontAwesomeIcons.thumbtack),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xff820000),
              label: 'Add post',
              labelStyle: TextStyle(fontSize: 18,color: Color(0xff820000)),
              onTap: () => Navigator.pushNamed(context, '/addPost'),
            ),
            
          ],
        ),
            ),
      ),
    );
  }
}

import 'package:art_platform/screens/home/add_post.dart';
import 'package:art_platform/screens/wrapper.dart';
import 'package:art_platform/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => Wrapper(),
              '/addPost': (context) => AddPost(),
              
            },
            theme: ThemeData(
              
              fontFamily: 'Montserrat',
            ),
            
      ),
    );
  }
}

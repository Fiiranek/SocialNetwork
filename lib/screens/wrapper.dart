import 'package:art_platform/models/user.dart';
import 'package:art_platform/screens/authenticate/authenticate.dart';
import 'package:art_platform/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    if (user == null) {
      return SafeArea(child: Authenticate());
    }
    else{
      return Home();
    }
  }
}
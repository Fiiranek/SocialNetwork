import 'package:art_platform/models/post.dart';
import 'package:art_platform/models/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  String userId;
  String userName;
  String userSurname;
  Dashboard({this.userId,this.userName,this.userSurname});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index){
          return PostTile(index: index,post: posts[index],userId:widget.userId);
        },
      ),
    );
  }
}
import 'package:art_platform/models/comment.dart';
import 'package:art_platform/models/comment_tile.dart';
import 'package:art_platform/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  String userId;
  Post post;
  CommentList({this.userId,this.post});
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context) ?? [];
    return Container(
        padding: EdgeInsets.all(10),
        child:ListView.builder(
          shrinkWrap: true,
             itemCount: comments.length,
              itemBuilder: (context, index){
             final comments = Provider.of<List<Comment>>(context) ?? [];
                              
               return CommentTile(index: index,comment: comments[index],userId:widget.userId,post: widget.post,);
            },
            ),
    );
  }
}
import 'package:art_platform/models/comment.dart';
import 'package:art_platform/models/post.dart';
import 'package:art_platform/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentTile extends StatefulWidget {
  int index;
  Comment comment;
  String userId;
  Post post;
  CommentTile({this.index,this.comment,this.userId,this.post});
  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

   final f = DateFormat('yyyy-MM-dd');
  final hourFormat = DateFormat('Hm');
   String timeToDisplay;
  String dateToDisplay;
  String hourToDisplay;
  
  @override
  Widget build(BuildContext context) {
    Comment comment = widget.comment;
    bool isAuthor = comment.authorId == widget.userId ? true : false;
   int now = DateTime.now().millisecondsSinceEpoch;
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(comment.date + 3600000);
      if ((now - comment.date) < 86400000) {
      //display hour instead of normal date if news is generated before 24 hours
      timeToDisplay = hourFormat.format(date);
      }
      // display normal date
      else {
        timeToDisplay = f.format(date);
      }
      hourToDisplay = hourFormat.format(date);
    dateToDisplay = f.format(date);

    return Container(
      padding: EdgeInsets.symmetric(vertical:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(backgroundColor: Color(0xff820000),child: 
                    Text(comment.authorName[0].toUpperCase()+comment.authorSurname[0].toUpperCase(),style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${comment.authorName} ${comment.authorSurname}',style: TextStyle(fontSize: 16),),
                            Text(timeToDisplay)
                          ],
                        ),
                ],
              ),
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (val){
                            if(val == 'delete'){
                              try{
                                CommentDatabaseService(postId: comment.postId).deleteComment(comment.id,widget.post.commentsCount);
                                print('Post ID'+comment.postId);
                                print('Comment ID'+comment.id);
                              }
                              catch(e){print(e.toString());}
                            }
                            else if(val == 'report'){
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Comment has been reported"),
                              ));
                            }
                          },
                          itemBuilder: (comment)=>
                          <PopupMenuEntry<String>>[
                            isAuthor ?
                            PopupMenuItem(
                            value: 'delete',
                            child: Row(children: <Widget>[
                              Icon(Icons.delete),
                              SizedBox(width: 5,),
                              Text('Delete')
                            ],),
                          )
                          :
                          PopupMenuItem(
                            value: 'report',
                            child: Row(children: <Widget>[
                              Icon(Icons.report),
                              SizedBox(width: 5,),
                              Text('Report')
                            ],),
                          )
                          ],
                        )
            ],
          ),
          SizedBox(height: 10,),
          Text(comment.content,style: TextStyle(fontSize: 16),)
        ],
      ),
    );
  }
}
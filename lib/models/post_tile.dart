import 'package:art_platform/models/add_comment.dart';
import 'package:art_platform/models/comment.dart';
import 'package:art_platform/models/comment_list.dart';
import 'package:art_platform/models/comment_tile.dart';
import 'package:art_platform/models/post.dart';
import 'package:art_platform/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostTile extends StatefulWidget {
  String userId;
  Post post;
  int index;
  PostTile({this.index,this.post,this.userId});
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  String comment = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  bool isCommentVisible = false;
  final f = DateFormat('yyyy-MM-dd');
  final hourFormat = DateFormat('Hm');
   String timeToDisplay;
  String dateToDisplay;
  String hourToDisplay;
  @override
  Widget build(BuildContext context) {

    Post post = widget.post;
    bool isLiked = post.userIdLikes.contains(widget.userId) ? true : false;
    bool isAuthor = post.authorId == widget.userId ? true : false;
    int now = DateTime.now().millisecondsSinceEpoch;
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(post.date + 3600000);
      if ((now - post.date) < 86400000) {
      //display hour instead of normal date if news is generated before 24 hours
      timeToDisplay = hourFormat.format(date);
      }
      // display normal date
      else {
        timeToDisplay = f.format(date);
      }
      hourToDisplay = hourFormat.format(date);
    dateToDisplay = f.format(date);
    
    return StreamProvider<List<Comment>>.value(
      value: CommentDatabaseService(postId: post.id).comments,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color:Color(0xff820000)),
              borderRadius: BorderRadius.circular(10)
            ),
        margin: EdgeInsets.symmetric(vertical:5),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(backgroundColor: Color(0xff820000),child: 
                    Text(post.authorName[0].toUpperCase()+post.authorSurname[0].toUpperCase(),style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${post.authorName} ${post.authorSurname}',style: TextStyle(fontSize: 16),),
                        Text(timeToDisplay)
                      ],
                    )
                  ],
                ),
                 PopupMenuButton(
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                   onSelected: (val){
                      if(val == 'delete'){
                        DatabaseService()
                        .deletePost(post.id);
                      }
                       else if(val == 'report'){
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Post has been reported"),
                              ));
                            }
                   },
                   itemBuilder: (context) => 
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
              ],),
              SizedBox(height: 10,),
              Text(post.content,style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              Container(
                height: 1,
                color: Color(0xff820000),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(post.likesCount.toString()),
                    IconButton(icon: Icon(FontAwesomeIcons.paintBrush,size: 14,color: isLiked ? Color(0xff820000) : Colors.black,),onPressed: (){
                      DatabaseService().likePost(isLiked, post.id, post.likesCount,post.userIdLikes,widget.userId);
                      isLiked = !isLiked;
                    },),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(post.commentsCount.toString()),
                    IconButton(icon: Icon(FontAwesomeIcons.comment,size: 14,),onPressed: (){
                      setState(() {
                        isCommentVisible = !isCommentVisible;
                      });
                    },),
                  ],
                )
              ],),
              SizedBox(height: 5,),
              Visibility(
                
                visible: isCommentVisible,
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       Container(
                        height: 1,
                        color: Color(0xff820000),
                      ),
                      AddComment(formKey: _formKey,textEditingController: _textEditingController,comment: comment,post: post,userId: widget.userId,),
                      // Form(
                      //   key: _formKey,
                      //   child: TextFormField(
                      //     controller: _textEditingController,
                      //     onChanged: (val){
                      //       setState(() {
                      //         comment = val;
                      //       });
                      //     },
                      //     validator: (val)=> val.isEmpty ? 'Field is empty' : null,
                      //   maxLines: 2,
                      //   decoration: InputDecoration(
                      //     suffix: RaisedButton(
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      //       color: Color(0xff820000),
                      //       onPressed: () {
                      //         if(_formKey.currentState.validate()){
                      //           CommentDatabaseService(postId: post.id).addComment(comment, post.id, widget.userId, post.authorName, post.authorSurname, now,post.commentsCount);
                      //           FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
                      //         _textEditingController.clear();
                              
                      //         }
                      //       },
                      //       child: Text('Add',style:TextStyle(color: Colors.white)),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide.none
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide.none
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide.none
                      //     ),
                      //     hintText: 'Start typing comment...'
                      //   ),
                      //   ),
                      // ),
                      SizedBox(height: 5,),
                      Text('Comments'),
                      SizedBox(height: 5,),
                      CommentList(userId: widget.userId,post: post,)
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
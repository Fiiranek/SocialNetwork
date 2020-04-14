import 'package:art_platform/models/post.dart';
import 'package:art_platform/models/user_data.dart';
import 'package:art_platform/services/database.dart';
import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  String userId;
  Post post;
  String comment;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  AddComment({this.formKey,this.textEditingController,this.comment,this.post,this.userId});
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  @override
  Widget build(BuildContext context) {
    int now = DateTime.now().millisecondsSinceEpoch;
    Post post = widget.post;
    return StreamBuilder<UserData>(
      stream: UserDatabaseService(uid: widget.userId).userData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        return Form(
                            key: widget.formKey,
                            child: TextFormField(
                              controller: widget.textEditingController,
                              onChanged: (val){
                                setState(() {
                                  widget.comment = val;
                                });
                              },
                              validator: (val)=> val.isEmpty ? 'Field is empty' : null,
                            maxLines: 2,
                            decoration: InputDecoration(
                              suffix: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                color: Color(0xff820000),
                                onPressed: () {
                                  if(widget.formKey.currentState.validate()){
                                    CommentDatabaseService(postId: post.id).addComment(widget.comment, post.id, widget.userId, userData.name, userData.surname, now,post.commentsCount);
                                    FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
                                  widget.textEditingController.clear();
                                  
                                  }
                                },
                                child: Text('Add',style:TextStyle(color: Colors.white)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              hintText: 'Start typing comment...'
                            ),
                            ),
                          );
      }
    );
  }
}
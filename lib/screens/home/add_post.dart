import 'package:art_platform/models/user.dart';
import 'package:art_platform/models/user_data.dart';
import 'package:art_platform/screens/other/decorations.dart';
import 'package:art_platform/screens/other/input_decoration.dart';
import 'package:art_platform/screens/other/loading.dart';
import 'package:art_platform/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  String title = '';
  String content = '';
  String tagsNoSplit = '';
  List<String> tags = [];
  final _formKey = GlobalKey<FormState>();
  int date = new DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
      double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<UserData>(
      stream: UserDatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          print(userData.name);
          print(userData.surname);
        return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon:Icon(Icons.arrow_back,color: Color(0xff820000),),
                    onPressed: (){
                    Navigator.pop(context);
                  },),
                elevation: 0,
                title: Text('New post',style: TextStyle(color: Colors.black),),
                flexibleSpace: Container(
                  decoration: appBarDecoration
                ),
                actions: <Widget>[
                  FlatButton.icon(onPressed: () async {
                    if(_formKey.currentState.validate()){
                      tags = tagsNoSplit.split(' ').toList();
                      for (var i = 0;i<tags.length;i++){
                        tags[i] = tags[i].replaceFirst(RegExp(r'#'),'');
                      }
                      print(title);
                      print(content);
                      print(tags);
                                await DatabaseService().addPost(title , content, user.uid,date,tags,
                                userData.name,userData.surname,0
                                );
                                Navigator.pop(context);
                              }
                  }, icon: Icon(Icons.add,color: Color(0xff820000),), label: Text('Add',style: TextStyle(color: Color(0xff820000)),))
                ],
              ),
            body: Container(
              height: screenHeight,
              color: Colors.white,
                child: Container(
                    
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      
                    ),
                  child: Form(
                    key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color:Color(0xff820000)))
                        ),
                        child: TextFormField(
                          decoration: addPostInputDecoration.copyWith(hintText:'Title'),
                             style: inputTextStyle,
                             validator: (val) => val.isEmpty
                                            ? 'Field is empty'
                                            : null,
                            onChanged: (val) {
                              setState(() => title= val);
                            },
                         ),
                      ),
                       Container(
                         decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color:Color(0xff820000)))
                        ),
                         child: TextFormField(
                           keyboardType: TextInputType.multiline,
                           minLines: 3,
                           maxLines: 3,
                          decoration: addPostInputDecoration.copyWith(hintText:"What's on Your mind?"),
                             style: inputTextStyle,
                             validator: (val) => val.isEmpty
                                            ? 'Field is empty'
                                            : null,
                            onChanged: (val) {
                              setState(() => content= val);
                            },
                         ),
                       ),
                       Container(padding: EdgeInsets.only(top: 10,left:10),child: Text('Tags',style: TextStyle(color: Color(0xff820000),fontSize: 18),)),
                       TextFormField(
                          decoration: addPostInputDecoration.copyWith(hintText:'Add # to start typing tag...'),
                             style: inputTextStyle,
                            onChanged: (val) {
                              setState(() => tagsNoSplit= val);
                            },
                         ),
                    ],),
                  ),
              ),
            ),
          ),
        );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
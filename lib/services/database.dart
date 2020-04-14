import 'package:art_platform/models/comment.dart';
import 'package:art_platform/models/post.dart';
import 'package:art_platform/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final CollectionReference postsCollection = Firestore.instance.collection('posts');

Future addPost (String title, String content, String authorId, int date, List tags, String authorName, String authorSurname, int likesCount) async {
    // var querySnapshot = await usersCollection.document(uid).collection('expenses').getDocuments();
    // var length = querySnapshot.documents.length;
    return await postsCollection.add({
        'content': content,
        'authorId': authorId,
        'date':date,
        'tags':tags,
        'authorName':authorName,
        'authorSurname':authorSurname,
        'likesCount': 0,
        'commentsCount':0
     });
  }

  Future likePost(bool isLiked, String postId, int currentLikesCount, List userIdLikes, String userId) async {
    
      if(isLiked == true){
        userIdLikes.removeWhere((item) => item.toString() == userId);
        return await postsCollection.document(postId).updateData({
          'likesCount': currentLikesCount - 1,
          'userIdLikes': userIdLikes
        });
      }
      else if(isLiked == false){
        userIdLikes.add(userId);
        return await postsCollection.document(postId).updateData({
          'likesCount': currentLikesCount + 1,
          'userIdLikes': userIdLikes
        });
      }
    
  }

  Future deletePost (String postId) async {
    return await postsCollection.document(postId).delete();
  }

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
      return Post(
        id: doc.documentID,
        authorId: doc.data['authorId'] ?? '',
        authorName: doc.data['authorName'],
        authorSurname: doc.data['authorSurname'],
        content: doc.data['content'] ?? '',
        date: doc.data['date'] ?? 0, 
        tags: doc.data['tags'] ?? [],
        likesCount: doc.data['likesCount'] ?? 0,
        commentsCount: doc.data['commentsCount'] ?? 0,
        userIdLikes: doc.data['userIdLikes'] ?? [],
        comments: doc.data['comments'] ?? []
      );
    }).toList();
  }

  Stream<List<Post>> get posts  {
      return postsCollection.orderBy('date', descending:true).snapshots()
        .map(_postListFromSnapshot);
    }
}

class UserDatabaseService{
  String uid;
  UserDatabaseService({this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('users');


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      name: snapshot.data['name'],
      surname: snapshot.data['surname'],
    );
  }

  // get user data stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).collection('data').document('personalData').snapshots().map(_userDataFromSnapshot);
  }

Future addUserData(String name, String surname) async {
  return await usersCollection.document(uid).collection('data').document('personalData').setData({
    'name':name,
    'surname':surname
  });
}
}

class CommentDatabaseService{

  final CollectionReference postsCollection = Firestore.instance.collection('posts');

  String postId;
  CommentDatabaseService({this.postId});

  Future addComment (String content, String postId, String authorId, String authorName, String authorSurname,int date,int currentCommentsCount) async {
    var querySnapshot = await postsCollection.document(postId).collection('comments').getDocuments();
    var commentsCount = querySnapshot.documents.length;
    postsCollection.document(postId).updateData({
      'commentsCount': currentCommentsCount + 1
    });
    return await postsCollection.document(postId).collection('comments').add({
        'content': content,
        'authorId': authorId,
        'date':date,
        'postId':postId,
        'authorName':authorName,
        'authorSurname':authorSurname,
     });
  }

  Future deleteComment(String id, int currentCommentsCount) async {
    postsCollection.document(postId).updateData({
      'commentsCount': currentCommentsCount - 1
    });
    return await postsCollection.document(postId).collection('comments').document(id).delete();
  }

  List<Comment> _commentListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
      return Comment(
        id: doc.documentID,
        postId: doc.data['postId'],
        authorId: doc.data['authorId'],
        authorName:doc.data['authorName'],
        authorSurname:doc.data['authorSurname'],
        content:doc.data['content'],
        date:doc.data['date'],
      );
    }).toList();
  }

  Stream<List<Comment>> get comments {
      return postsCollection.document(postId).collection('comments').snapshots()
        .map(_commentListFromSnapshot);
    }
}
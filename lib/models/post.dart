class Post{
  String id;
  String authorId;
  String authorName;
  String authorSurname;
  String content;
  int likesCount;
  int commentsCount;
  List userIdLikes;
  List comments;
  int date;
  List tags;
  Post({this.id,this.authorId,this.authorName,this.authorSurname,this.content,this.date,this.tags,this.likesCount,this.commentsCount,this.userIdLikes,this.comments});
}
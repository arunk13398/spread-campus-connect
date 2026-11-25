
class FeedModel {
  String id;
  String userName;
  String desigUser;
  String description;
  String imageUrl;
  String UpdatedTime;
  String profImg;
  String toPublish;
  String RegisterLink;
  String Phone;
  String College;
  int? likedCount;
  bool? isLiked;
  int commentCount;

  FeedModel({
    required this.id,
    required this.userName,
    required this.desigUser,
    required this.description,
    required this.imageUrl,
    required this.UpdatedTime,
    required this.profImg,
    required this.toPublish,
    required this.RegisterLink,
    required this.Phone,
    required this.College,
    this.likedCount=0,
    this.isLiked=true,
    this.commentCount=0,
  });

}

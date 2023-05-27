
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
  int? likedCount;
  bool? isLiked;

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
    this.likedCount=0,
    this.isLiked=true,
  });

}

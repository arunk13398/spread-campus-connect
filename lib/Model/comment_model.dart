class CommentModel{
  String id;
  String username;
  String description;
  String Time;
  String UserProfImg;
  String userNumber;

  CommentModel({
    required this.id,
    required this.username,
    required this.description,
    required this.Time,
    required this.UserProfImg,
    this.userNumber = '',
});
}
import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/comment_model.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/functions.dart';
import 'package:miniq/functions/widgets.dart';

class CommentViewScreen extends StatefulWidget {
  final FeedModel feedModel;
  const CommentViewScreen({Key? key, required this.feedModel}) : super(key: key);

  @override
  State<CommentViewScreen> createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  final List<CommentModel> commentList = [];
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  final TextEditingController commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  String username = '';
  String userProfImg = '';
  String userNumber = '';
  int _likedCount = 0;
  bool _isLiked = false;

  StreamSubscription<DatabaseEvent>? _commentsSub;
  StreamSubscription<DatabaseEvent>? _likesSub;

  String get _bucket => widget.feedModel.toPublish.isNotEmpty
      ? widget.feedModel.toPublish
      : 'All';

  @override
  void initState() {
    super.initState();
    _likedCount = widget.feedModel.likedCount ?? 0;
    _isLiked = widget.feedModel.isLiked ?? false;
    _initUserAndListeners();
  }

  @override
  void dispose() {
    _commentsSub?.cancel();
    _likesSub?.cancel();
    commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initUserAndListeners() async {
    await getDataF1();
    loadComment();
    _listenLikes();
  }

  void _listenLikes() {
    _likesSub = mRootReference
        .child('Feeds')
        .child(_bucket)
        .child(widget.feedModel.id)
        .child('Likes')
        .onValue
        .listen((event) {
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        if (!mounted) return;
        setState(() {
          _likedCount = raw.length;
          _isLiked = userNumber.isNotEmpty && raw[userNumber] != null;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _likedCount = 0;
          _isLiked = false;
        });
      }
    });
  }

  Future<void> _setLike(bool like) async {
    if (userNumber.isEmpty) return;
    final likeRef = mRootReference
        .child('Feeds')
        .child(_bucket)
        .child(widget.feedModel.id)
        .child('Likes')
        .child(userNumber);
    if (like) {
      await likeRef.set(username);
    } else {
      await likeRef.remove();
    }
  }

  void _openFullScreenImage() {
    if (widget.feedModel.imageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(
          imageUrl: widget.feedModel.imageUrl,
          heroTag: 'feed-image-${widget.feedModel.id}',
          title: widget.feedModel.userName,
          subtitle: widget.feedModel.College.isNotEmpty
              ? '${widget.feedModel.desigUser} • ${widget.feedModel.College}'
              : widget.feedModel.desigUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.feedModel;
    final timeAgo = formatTimeAgo(post.UpdatedTime);
    final hasImage = post.imageUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1.8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [MyColors.Colorgreen3, MyColors.Colorgreen2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: liveProfileAvatar(
                  fallbackUrl: post.profImg,
                  phone: post.Phone,
                  college: post.College,
                  designation: post.desigUser,
                  name: post.userName,
                  radius: 17,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    [
                      if (post.desigUser.isNotEmpty) post.desigUser,
                      if (post.College.isNotEmpty) post.College,
                      if (timeAgo.isNotEmpty) timeAgo,
                    ].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (hasImage)
            IconButton(
              tooltip: 'Full screen',
              icon: const Icon(Icons.fullscreen_rounded, color: Colors.black87),
              onPressed: _openFullScreenImage,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.045),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasImage)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.black,
                                    width: double.infinity,
                                    child: DoubleTapPinchImage(
                                      onTap: _openFullScreenImage,
                                      onDoubleTapLike: () {
                                        if (!_isLiked) {
                                          _setLike(true);
                                        }
                                      },
                                      child: Hero(
                                        tag: 'feed-image-${post.id}',
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.46,
                                          ),
                                          child: CachedNetworkImage(
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            imageUrl: post.imageUrl,
                                            placeholder: (context, url) =>
                                                const SizedBox(
                                              height: 240,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const SizedBox(
                                              height: 220,
                                              child: Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Colors.white54,
                                                  size: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    height: 76,
                                    child: IgnorePointer(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black
                                                  .withValues(alpha: 0.44),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    bottom: 10,
                                    child: Row(
                                      children: [
                                        PostActionBar(
                                          keyPrefix: 'detail',
                                          postId: post.id,
                                          isLiked: _isLiked,
                                          likedCount: _likedCount,
                                          commentCount: commentList.length,
                                          isOverlay: true,
                                          registerLink: post.RegisterLink,
                                          onToggleLike:
                                              (currentlyLiked) async {
                                            await _setLike(!currentlyLiked);
                                            return !currentlyLiked;
                                          },
                                          onCommentTap: () => _commentFocusNode
                                              .requestFocus(),
                                          onApplyTap: post
                                                  .RegisterLink.isNotEmpty
                                              ? () => openBrowserUrl(
                                                  url: post.RegisterLink,
                                                  inApp: true)
                                              : null,
                                        ),
                                        const Spacer(),
                                        ClipOval(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 16, sigmaY: 16),
                                            child: Material(
                                              color: Colors.black
                                                  .withValues(alpha: 0.44),
                                              child: InkWell(
                                                onTap: _openFullScreenImage,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(7.5),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withValues(
                                                              alpha: 0.24),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.fullscreen_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!hasImage)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                            child: PostActionBar(
                              keyPrefix: 'detail',
                              postId: post.id,
                              isLiked: _isLiked,
                              likedCount: _likedCount,
                              commentCount: commentList.length,
                              isOverlay: false,
                              registerLink: post.RegisterLink,
                              onToggleLike: (currentlyLiked) async {
                                await _setLike(!currentlyLiked);
                                return !currentlyLiked;
                              },
                              onCommentTap: () =>
                                  _commentFocusNode.requestFocus(),
                              onApplyTap: post.RegisterLink.isNotEmpty
                                  ? () => openBrowserUrl(
                                      url: post.RegisterLink, inApp: true)
                                  : null,
                            ),
                          ),
                        if (post.description.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  height: 1.45,
                                  color: Color(0xFF1E293B),
                                ),
                                children: [
                                  TextSpan(
                                    text: '${post.userName}  ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(text: post.description),
                                ],
                              ),
                            ),
                          )
                        else if (hasImage)
                          const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    child: Row(
                      children: [
                        const Text(
                          "Comments",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: MyColors.Colorgreen3.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${commentList.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: MyColors.Colorgreen3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (commentList.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  MyColors.Colorgreen3.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.forum_outlined,
                              size: 28,
                              color: MyColors.Colorgreen3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Start the conversation",
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Be the first to share your thoughts on this post",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => CommentAdaptor(index),
                        childCount: commentList.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  profileAvatar(userProfImg, radius: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      focusNode: _commentFocusNode,
                      minLines: 1,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.black, fontSize: 14.5),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: const Color(0xFFF2F4F7),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: MyColors.Colorgreen3,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final text = commentController.text.trim();
                        if (text.isEmpty) return;
                        addComment(text);
                        commentController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addComment(String text) async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.feedModel.id;
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    data["Description"] = text;
    data["UserName"] = username;
    data["UserNumber"] = userNumber;
    data["UserProfilImage"] = userProfImg;
    data["Date"] = DateTime.now().toString();
    data["Time"] = id1;

    await mRootReference
        .child('Feeds')
        .child(_bucket)
        .child(id)
        .child('Comments')
        .child(id1)
        .update(data);
  }

  Future<void> getDataF1() async {
    username = (await getString(UserPreferences.USER_Name)) ?? '';
    userNumber = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    final college = await getString(UserPreferences.COLLEGE);
    final designation = await getString(UserPreferences.DESIGNATION);
    if (college == null || userNumber.isEmpty || designation == null) return;
    final value = await mRootReference
        .child("UsersList")
        .child(college)
        .child(userNumber)
        .child(designation)
        .once();
    if (value.snapshot.exists && value.snapshot.value is Map) {
      Map<dynamic, dynamic> data = value.snapshot.value as Map;
      if (!mounted) return;
      setState(() {
        username = (data['Name'] ?? username).toString();
        userProfImg = (data['ImageUrl'] ?? '').toString();
      });
      UserAvatarCache.instance.seed(
        phone: userNumber,
        name: username,
        imageUrl: userProfImg,
      );
    }
  }

  void loadComment() {
    String id = widget.feedModel.id;
    _commentsSub = mRootReference
        .child('Feeds')
        .child(_bucket)
        .child(id)
        .child('Comments')
        .onValue
        .listen((event) {
      commentList.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            commentList.add(CommentModel(
              id: key.toString(),
              username: (value['UserName'] ?? '').toString(),
              description: (value['Description'] ?? '').toString(),
              Time: (value['Time'] ?? '').toString(),
              UserProfImg: (value['UserProfilImage'] ?? '').toString(),
              userNumber: (value['UserNumber'] ?? '').toString(),
            ));
          }
        });
        commentList.sort((a, b) {
          final at = int.tryParse(a.Time) ?? 0;
          final bt = int.tryParse(b.Time) ?? 0;
          return at.compareTo(bt);
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget CommentAdaptor(int index) {
    final item = commentList[index];
    final timeAgo = formatTimeAgo(item.Time);
    final isOwnComment = item.userNumber.isNotEmpty
        ? item.userNumber == userNumber
        : item.username == username;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          liveProfileAvatar(
            fallbackUrl: item.UserProfImg,
            phone: item.userNumber,
            name: item.username,
            radius: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    if (timeAgo.isNotEmpty)
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (isOwnComment)
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => showAlertDialogMore(context, index),
              child: Padding(
                padding: const EdgeInsets.only(left: 6, top: 2),
                child: Icon(
                  Icons.more_horiz,
                  size: 19,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showAlertDialogMore(BuildContext context, int index) {
    final commentId = commentList[index].id;
    showAppConfirmDialog(
      context: context,
      title: "Delete Comment?",
      message: "Are you sure you want to delete this comment?",
      confirmLabel: "Delete",
      icon: Icons.delete_outline_rounded,
      accentColor: Colors.red.shade600,
      onConfirm: () {
        mRootReference
            .child('Feeds')
            .child(_bucket)
            .child(widget.feedModel.id)
            .child('Comments')
            .child(commentId)
            .remove();
      },
    );
  }
}

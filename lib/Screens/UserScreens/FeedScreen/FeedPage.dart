import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chip_list/chip_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/comment_view.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/camera.dart';
import 'package:miniq/functions/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../Model/access_model.dart';
import '../../../Model/listdata_model.dart';
import '../../../functions/functions.dart';
import '../AdditionalScreens/about_screen.dart';
import '../AdditionalScreens/help.dart';




class FeedPage extends StatefulWidget {
  const FeedPage({Key? key,}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  List<ListDataModel> datalist=[];

  // List<LikeModel> likelist=[];
  String numberId = '';
  String UserName = '';
  String UserName1 = '';
  String College = '';
  String Designation = '';
  String Phone = '';
  String UidLike = '';
  String UidName = '';
  String ProfimageUrl = '';
  String UserType = '';
  String Status = '';

  bool isLiked = false;
  int isColorSelected=0;
  bool isConnected = false;
  final Set<String> _expandedPosts = {};
  var size, height, width;

  int _currentIndex = 0;


  var top=0.0;
  late ScrollController _scrollController;

  @override void initState() {
    load(hashCode);
    getDataF1();
    getData();
    getDataAccess();
    loadNotification();
    checkRealtimeConnection();
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openCreatePost() {
    if (Status == "blocked") {
      showAlertDialogBloked(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Camera()),
      );
    }
  }

  Widget _createPostButton() {
    return Material(
      color: MyColors.Colorgreen3,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _openCreatePost,
        child: const SizedBox(
          height: 38,
          width: 38,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Future<void> _setLike(FeedModel post, bool like) async {
    if (numberId.isEmpty) return;
    final targetBucket = post.toPublish.isNotEmpty ? post.toPublish : 'All';
    final likeRef = mRootReference
        .child('Feeds')
        .child(targetBucket)
        .child(post.id)
        .child('Likes')
        .child(numberId);
    if (like) {
      await likeRef.set(UserName);
    } else {
      await likeRef.remove();
    }
  }

  void _openDetailPage(FeedModel post) {
    if (Status == "blocked") {
      showAlertDialogBloked(context);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentViewScreen(feedModel: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final double expandedHeight = datalist.isEmpty ? 102 : 148;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              pinned: true,
              expandedHeight: expandedHeight,
              flexibleSpace: LayoutBuilder(
                builder: (ctx, cons) {
                  top = cons.biggest.height;
                  final collapsed = top <= kToolbarHeight + 24;
                  return FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    centerTitle: false,
                    title: IgnorePointer(
                      ignoring: !collapsed,
                      child: AnimatedOpacity(
                        opacity: collapsed ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 160),
                        child: Row(
                          children: [
                            const Text(
                              "Trending Feeds",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            _createPostButton(),
                          ],
                        ),
                      ),
                    ),
                    background: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                      child: AnimatedOpacity(
                        opacity: collapsed ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 160),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        UserName.isEmpty ? 'Welcome' : UserName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (College.isNotEmpty)
                                        Text(
                                          College,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                _createPostButton(),
                                const SizedBox(width: 8),
                                profileAvatar(ProfimageUrl, radius: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Trending Feeds",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                                letterSpacing: -0.4,
                                color: Colors.black,
                              ),
                            ),
                            if (datalist.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 38,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: datalist.length,
                                  itemBuilder: (context, index) =>
                                      AdaptoItemList(index),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (list.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.dynamic_feed_outlined,
                            size: 52, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          "No feeds yet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap + to share the first post",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(top: 6, bottom: 14),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        AdaptorNew(index, list[index].isLiked),
                    childCount: list.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    UserName = (await getString(UserPreferences.USER_Name)) ?? '';
    final college = await getString(UserPreferences.COLLEGE);
    final designation = await getString(UserPreferences.DESIGNATION);
    if (college == null || numberId.isEmpty || designation == null) return;
    mRootReference
        .child("UsersList")
        .child(college)
        .child(numberId)
        .child(designation)
        .onValue
        .listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        College = (data["College"] ?? '').toString();
        Designation = (data["Designation"] ?? '').toString();
        Phone = (data['Phone'] ?? '').toString();
        ProfimageUrl = (data['ImageUrl'] ?? '').toString();
        UserAvatarCache.instance.seed(
          phone: Phone.isNotEmpty ? Phone : numberId,
          name: (data['Name'] ?? UserName).toString(),
          imageUrl: ProfimageUrl,
        );
        if (mounted) {
          setState(() {});
        }
      }
    });
  }


  getData() async {
    String id=College;
    String id1=Designation;
    mRootReference
        .child("UsersList")
        .child(id)
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(id1)
        .child("Profile")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("abcd ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserName1 = data["Course"];
        setState(() {});
      }
    });
  }
  load(int index) async {
    String NewItem="";
   if(isColorSelected==0){
     NewItem="All";
   }else{
     NewItem=datalist[index].id;
   }
    print("ggffgffgfgfgfgf${NewItem}");
    mRootReference.child("Feeds").child(NewItem).onValue.listen((event) {
      list.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          if (value is! Map<dynamic, dynamic>) return;
          int count = 0;
          bool isLiked = false;
          if (value['Likes'] is Map) {
            Map<dynamic, dynamic> like = value['Likes'] as Map;
            count = like.length;
            isLiked = numberId.isNotEmpty && like[numberId] != null;
          }
          final int commentCount =
              value['Comments'] is Map ? (value['Comments'] as Map).length : 0;
          list.add(FeedModel(
            id: key.toString(),
            userName: (value['UserName'] ?? '').toString(),
            desigUser: (value['Designation'] ?? '').toString(),
            description: (value['Description'] ?? '').toString(),
            imageUrl: (value['ImageUrl'] ?? '').toString(),
            UpdatedTime: (value['ImageUrlTime'] ?? '').toString(),
            profImg: (value['ProfileImage'] ?? '').toString(),
            toPublish: (value['ToPublish'] ?? NewItem).toString(),
            RegisterLink: (value['RegisterLink'] ?? '').toString(),
            likedCount: count,
            isLiked: isLiked,
            commentCount: commentCount,
            Phone: (value['Phone'] ?? '').toString(),
            College: (value['College'] ?? '').toString(),
          ));
        });
        list.sort((a, b) {
          final bt = int.tryParse(b.UpdatedTime) ?? 0;
          final at = int.tryParse(a.UpdatedTime) ?? 0;
          return bt.compareTo(at);
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget AdaptorNew(int index, bool? isLiked) {
    final post = list[index];
    final timeAgo = formatTimeAgo(post.UpdatedTime);
    final isExpanded = _expandedPosts.contains(post.id);
    final hasLongDescription = post.description.length > 120;
    final hasImage = post.imageUrl.isNotEmpty;

    final actionBar = PostActionBar(
      keyPrefix: 'feed',
      postId: post.id,
      isLiked: post.isLiked == true,
      likedCount: post.likedCount ?? 0,
      commentCount: post.commentCount,
      isOverlay: hasImage,
      registerLink: post.RegisterLink,
      onToggleLike: (currentlyLiked) async {
        await _setLike(post, !currentlyLiked);
        return !currentlyLiked;
      },
      onCommentTap: () => _openDetailPage(post),
      onApplyTap: post.RegisterLink.isNotEmpty
          ? () => openBrowserUrl(url: post.RegisterLink, inApp: true)
          : null,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(1.8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        MyColors.Colorgreen3,
                        MyColors.Colorgreen2,
                      ],
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
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 1),
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
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => showAlertDialogMore(context),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasImage)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    DoubleTapPinchImage(
                      onTap: () => _openDetailPage(post),
                      onDoubleTapLike: () {
                        if (post.isLiked != true) {
                          _setLike(post, true);
                        }
                      },
                      child: Hero(
                        tag: 'feed-image-${post.id}',
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => getShimmerLoading(),
                          errorWidget: (context, url, error) =>
                              const SizedBox.shrink(),
                          imageBuilder: (context, image) => ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 410),
                            child: Image(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              image: image,
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
                                Colors.black.withValues(alpha: 0.42),
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
                          actionBar,
                          const Spacer(),
                          ClipOval(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.44),
                                child: InkWell(
                                  onTap: () => _openDetailPage(post),
                                  child: Container(
                                    padding: const EdgeInsets.all(7.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.24),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.open_in_full_rounded,
                                      color: Colors.white,
                                      size: 16,
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
          if (post.description.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                14,
                hasImage ? 10 : 2,
                14,
                hasImage ? 12 : 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: isExpanded ? null : 3,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
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
                  if (hasLongDescription)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedPosts.remove(post.id);
                          } else {
                            _expandedPosts.add(post.id);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isExpanded ? "Show less" : "Read more",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: MyColors.Colorgreen3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else if (hasImage)
            const SizedBox(height: 8),
          if (!hasImage)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 12),
              child: actionBar,
            ),
        ],
      ),
    );
  }

  void checkRealtimeConnection() {
    Connectivity().onConnectivityChanged.listen((my_result) {
      if (my_result.contains(ConnectivityResult.mobile) ||
          my_result.contains(ConnectivityResult.wifi)) {
        print("connected");
        setState(() {
          isConnected = true;
        });
      } else if (my_result.contains(ConnectivityResult.none) ||
          my_result.isEmpty) {
        print("not connected");
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  Shimmer getShimmerLoading(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      // enabled: _enabled,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0,left:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   width: double.infinity,
                        //   height: 8.0,
                        //   color: Colors.white,
                        // ),

                        Container(
                          width: 150,
                          height: 12.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 60.0,
                          height: 12.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height:10),
            Container(
              width: double.infinity,
              height: 12.0,
              color: Colors.white,
            ),
            SizedBox(height:10),
            Container(
              width: double.infinity,
              height: 180.0,
              color: Colors.white,
            ),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: 30.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addLike() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    // String id1 = list[index].id
    String id2 = Phone;
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    await mRootReference.child('Feeds').child('Public').child(id2).child('Comments').child(id1).update(data);

    // HashMap<String, dynamic> data = HashMap<String, dynamic>();
    // String id2= list[index].id;
    // String id3= numberId;
    // print("tutututu ${UserName}");
    // data["UserName"] = UserName;
    // mRootReference.child('Feeds').child('Public').child(id2).child('Likes').child(id3).update(data);
    //
  }

  void showAlertDialogMore(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/letterblacknewcolor.png", height: 34),
                const SizedBox(height: 8),
                Text(
                  "More options",
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.Colorgreen3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                dialogOptionRow(
                  icon: Icons.info_outline_rounded,
                  title: "About",
                  subtitle: "App info & community details",
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                dialogOptionRow(
                  icon: Icons.help_outline_rounded,
                  title: "Help",
                  subtitle: "Support & FAQs",
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int? getLikedCount(String id){
    int? isLiked=0;
    mRootReference.child('Likes').child(id).once().then((value) {
      if(value.snapshot.exists) {
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        isLiked=data.length;
      }
    });
   return isLiked;
  }

  bool? getLiked(String id) {
    bool? isLiked=false;
    mRootReference.child('Likes').child(id).child(numberId).once().then((value) {
      isLiked=value.snapshot.exists;
    });
   return isLiked;
  }


  newLike(){
    if(isLiked==true){
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id3= numberId;
      data[numberId] = numberId;
      mRootReference.child('Likes').child(id3).update(data);
    }
    else{
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id3= numberId;
      print("tutututu ${UserName}");
      data["UserName"] = UserName;
      mRootReference.child('Likes').child(id3).remove();
    }
  }

  Widget AdaptoItemList(int index){
    return Container(
      child: Center(
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: (){
              load(index);
             setState(() {
               isColorSelected=index;
             });

            },
            child: Container(
              height: 50,
                decoration: BoxDecoration(
                    color: isColorSelected==index?MyColors.Colorgreen2:Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                  color: MyColors.Colorgreen2,
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15,top:7,bottom:7),
                  child: Center(
                    child: Text(datalist[index].id,
                      style: TextStyle(color:isColorSelected==index?Colors.white:Colors.black,fontSize: 16),),
                  ),
                )),
          ),
        ),),
    );
  }

  loadNotification() {
    mRootReference.child("AccessManagement").child("ViewCategoryList").onValue.listen((event) {
      datalist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          datalist.add(ListDataModel(
            id: key,
          ));
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE));
    Designation = (await getString(UserPreferences.DESIGNATION));
    mRootReference
        .child("AccessControl")
        .child(await getString(UserPreferences.USER_NUMBER))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("fffffff ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        UserType = data["AcessName"];
        Status = data["Status"];
        setState(() {});
      }
    });
  }
}


Future openBrowserUrl({
  required String url,
  bool inApp = false,
}) async {
  if(await canLaunch(url)){
    await launch(url,
        forceWebView: inApp,
        enableJavaScript: true,
        forceSafariVC: inApp);
  }
}

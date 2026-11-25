import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

import '../Contraints/user_preference.dart';
import '../Theme/theme.dart';

Shimmer getShimmerLoading(){
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade500,
    // enabled: _enabled,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
            height: 230.0,
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

Shimmer getShimmerAllFeedsLoading(){
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade500,
    // enabled: _enabled,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 120,
            color: Colors.white,
          ),

        ],
      ),
    ),
  );
}


void checkRealtimeConnection(my_result,ConnectivityResult) {
  Connectivity().onConnectivityChanged.listen((my_result) {
    if (my_result == ConnectivityResult.mobile ||
        my_result == ConnectivityResult.wifi) {
      // print("connected");
      // setState(() {
      //   isConnected = true;
      // });
    } else if (my_result == ConnectivityResult.none) {
      print("not connected");
      // setState(() {
      //   isConnected = false;
      // });
    }
  });
}


initAuth(String Uid,user) async {
  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;

  await Future.delayed(const Duration(seconds: 2));
  _auth = FirebaseAuth.instance;
  _authStateChanges = _auth.authStateChanges();
  _authStateChanges.listen((User? user) {

    // setState(() {
    //   Uid = user?.uid??"";
    // });
    // print("...user id ${user?.uid}....");
  });
}



getDataF1() async {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  var numberId = (await getString(UserPreferences.USER_NUMBER));
  var UserName = (await getString(UserPreferences.USER_Name));
  // College = (await getString(UserPreferences.COLLEGE));

  mRootReference
      .child("AccessControl")
      .child(await getString(UserPreferences.USER_NUMBER))
      .once()
      .then((value) {
    if (value.snapshot.exists) {
      print("efgh ${value.snapshot.value}");
      Map<dynamic, dynamic> data = value.snapshot.value as Map;
      var College = data["College"];
      var  Designation = data["Designation"];
      // setState(() {});
    }
  });
}


Widget profileAvatar(String imageUrl, {double radius = 22}) {
  Widget fallback() => CircleAvatar(
        backgroundColor: Colors.blue.shade300,
        radius: radius,
        child: Icon(Icons.person, size: radius * 1.1, color: Colors.white),
      );

  if (imageUrl.isEmpty) {
    return fallback();
  }
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => CircleAvatar(
      backgroundColor: Colors.blue.shade300,
      radius: radius,
    ),
    errorWidget: (context, url, error) => fallback(),
    imageBuilder: (context, image) => CircleAvatar(
      backgroundImage: image,
      radius: radius,
    ),
  );
}

/// Caches live user profile image URLs from RTDB so older posts and comments
/// reflect updated profile pictures rather than stale creation-time snapshots.
class UserAvatarCache {
  UserAvatarCache._();
  static final UserAvatarCache instance = UserAvatarCache._();

  final ValueNotifier<int> version = ValueNotifier<int>(0);
  final Map<String, String> _byPhone = {};
  final Map<String, String> _byName = {};
  final Set<String> _fetchedUserKeys = {};
  bool _listening = false;

  void ensureListening() {
    if (_listening) return;
    _listening = true;
    FirebaseDatabase.instance.ref().child('AccessControl').onValue.listen((event) {
      final raw = event.snapshot.value;
      if (raw is! Map<dynamic, dynamic>) return;
      bool changed = false;
      raw.forEach((key, value) {
        if (value is! Map<dynamic, dynamic>) return;
        final img = (value['ImageUrl'] ?? '').toString();
        if (img.isEmpty) return;
        final phone = (value['Phone'] ?? key).toString();
        final name = (value['Name'] ?? '').toString();
        if (phone.isNotEmpty && _byPhone[phone] != img) {
          _byPhone[phone] = img;
          changed = true;
        }
        if (name.isNotEmpty && _byName[name] != img) {
          _byName[name] = img;
          changed = true;
        }
      });
      if (changed) {
        version.value++;
      }
    });
  }

  void seed({String phone = '', String name = '', String imageUrl = ''}) {
    if (imageUrl.isEmpty) return;
    bool changed = false;
    if (phone.isNotEmpty && _byPhone[phone] != imageUrl) {
      _byPhone[phone] = imageUrl;
      changed = true;
    }
    if (name.isNotEmpty && _byName[name] != imageUrl) {
      _byName[name] = imageUrl;
      changed = true;
    }
    if (changed) {
      version.value++;
    }
  }

  void _fetchFromUsersListIfNeeded(
      String college, String phone, String designation, String name) {
    final key = '$college|$phone|$designation';
    if (_fetchedUserKeys.contains(key)) return;
    _fetchedUserKeys.add(key);
    FirebaseDatabase.instance
        .ref()
        .child('UsersList')
        .child(college)
        .child(phone)
        .child(designation)
        .child('ImageUrl')
        .once()
        .then((event) {
      final img = (event.snapshot.value ?? '').toString();
      if (img.isNotEmpty) {
        seed(phone: phone, name: name, imageUrl: img);
      }
    }).catchError((_) {});
  }

  String? resolve({
    String phone = '',
    String name = '',
    String college = '',
    String designation = '',
  }) {
    ensureListening();
    if (phone.isNotEmpty) {
      final byPhone = _byPhone[phone];
      if (byPhone != null && byPhone.isNotEmpty) {
        return byPhone;
      }
      if (college.isNotEmpty && designation.isNotEmpty) {
        _fetchFromUsersListIfNeeded(college, phone, designation, name);
      }
    }
    if (name.isNotEmpty) {
      final byName = _byName[name];
      if (byName != null && byName.isNotEmpty) {
        return byName;
      }
    }
    return null;
  }
}

/// Renders a circular user avatar preferring the latest cached RTDB profile
/// picture over the snapshot URL saved when the post or comment was created.
Widget liveProfileAvatar({
  required String fallbackUrl,
  String phone = '',
  String college = '',
  String designation = '',
  String name = '',
  double radius = 22,
}) {
  return ValueListenableBuilder<int>(
    valueListenable: UserAvatarCache.instance.version,
    builder: (context, _, __) {
      final resolved = UserAvatarCache.instance.resolve(
        phone: phone,
        name: name,
        college: college,
        designation: designation,
      );
      final effectiveUrl =
          (resolved != null && resolved.isNotEmpty) ? resolved : fallbackUrl;
      return profileAvatar(effectiveUrl, radius: radius);
    },
  );
}


String formatTimeAgo(String epochMs) {
  final ms = int.tryParse(epochMs);
  if (ms == null) return '';
  final dt = DateTime.fromMillisecondsSinceEpoch(ms);
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class DoubleTapPinchImage extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTapLike;

  const DoubleTapPinchImage({
    Key? key,
    required this.child,
    this.onTap,
    this.onDoubleTapLike,
  }) : super(key: key);

  @override
  State<DoubleTapPinchImage> createState() => _DoubleTapPinchImageState();
}

class _DoubleTapPinchImageState extends State<DoubleTapPinchImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _txController = TransformationController();
  late final AnimationController _resetController;
  Animation<Matrix4>? _resetAnimation;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        if (_resetAnimation != null) {
          _txController.value = _resetAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    _txController.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _resetAnimation = Matrix4Tween(
      begin: _txController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOut,
    ));
    _resetController.forward(from: 0);
  }

  void _handleDoubleTap() {
    widget.onDoubleTapLike?.call();
    setState(() {
      _showHeart = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _showHeart = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            transformationController: _txController,
            panEnabled: false,
            minScale: 1.0,
            maxScale: 3.5,
            onInteractionEnd: _onInteractionEnd,
            child: widget.child,
          ),
          IgnorePointer(
            child: AnimatedScale(
              scale: _showHeart ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 220),
              curve: Curves.elasticOut,
              child: AnimatedOpacity(
                opacity: _showHeart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 88,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final String? title;
  final String? subtitle;

  const FullScreenImagePage({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final TransformationController _txController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _txController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_txController.value != Matrix4.identity()) {
      _txController.value = Matrix4.identity();
    } else if (_doubleTapDetails != null) {
      final pos = _doubleTapDetails!.localPosition;
      _txController.value = Matrix4.identity()
        ..translate(-pos.dx * 1.5, -pos.dy * 1.5)
        ..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.title != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                ],
              )
            : null,
      ),
      body: Center(
        child: GestureDetector(
          onDoubleTapDown: (details) => _doubleTapDetails = details,
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _txController,
            minScale: 0.8,
            maxScale: 5.0,
            child: Hero(
              tag: widget.heroTag,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Instagram-inspired like, comment, and optional action bar.
/// When [isOverlay] is true, renders over the bottom of an image inside a
/// frosted smoky blur capsule.
class PostActionBar extends StatelessWidget {
  final String keyPrefix;
  final String postId;
  final bool isLiked;
  final int likedCount;
  final int commentCount;
  final Future<bool?> Function(bool currentlyLiked) onToggleLike;
  final VoidCallback? onCommentTap;
  final String registerLink;
  final VoidCallback? onApplyTap;
  final VoidCallback? onFullscreenTap;
  final bool isOverlay;

  const PostActionBar({
    Key? key,
    required this.keyPrefix,
    required this.postId,
    required this.isLiked,
    required this.likedCount,
    required this.commentCount,
    required this.onToggleLike,
    this.onCommentTap,
    this.registerLink = '',
    this.onApplyTap,
    this.onFullscreenTap,
    this.isOverlay = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fgColor = isOverlay ? Colors.white : Colors.black87;
    final iconColor = isOverlay ? Colors.white : Colors.grey.shade700;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(
          key: ValueKey('$keyPrefix-$postId-$isLiked-$likedCount'),
          isLiked: isLiked,
          onTap: onToggleLike,
          size: 20,
          circleColor: const CircleColor(
            start: Color(0xFF79D71E),
            end: Color(0xFFCEF894),
          ),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Color(0xFF79D71E),
            dotSecondaryColor: Color(0xFFCEF894),
          ),
          likeBuilder: (bool liked) => Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? MyColors.Colorgreen3 : fgColor,
            size: 20,
          ),
          likeCount: likedCount,
          countBuilder: (count, bool liked, String text) => Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              text,
              style: TextStyle(
                color: liked && !isOverlay ? MyColors.Colorgreen3 : fgColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 1,
            height: 14,
            color: isOverlay
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.grey.shade300,
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onCommentTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline_rounded,
                    size: 18, color: iconColor),
                const SizedBox(width: 5),
                Text(
                  '$commentCount',
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (registerLink.isNotEmpty && onApplyTap != null) ...[
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onApplyTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isOverlay
                    ? MyColors.Colorgreen3.withValues(alpha: 0.85)
                    : MyColors.Colorgreen3.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: isOverlay ? Colors.white : MyColors.Colorgreen3,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Apply',
                    style: TextStyle(
                      color: isOverlay ? Colors.white : MyColors.Colorgreen3,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (onFullscreenTap != null) ...[
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onFullscreenTap,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.fullscreen_rounded,
                color: fgColor,
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );

    if (!isOverlay) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: row,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.42),
                  Colors.black.withValues(alpha: 0.56),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.24),
                width: 0.9,
              ),
            ),
            child: row,
          ),
        ),
      ),
    );
  }
}

Color complaintStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'verified':
    case 'resolved':
    case 'approved':
      return MyColors.Colorgreen3;
    case 'rejected':
      return Colors.red.shade600;
    case 'waiting':
      return Colors.amber.shade700;
    case 'forwarded':
      return Colors.blue.shade600;
    default:
      return Colors.orange.shade700;
  }
}

Widget complaintStatusBadge(String status) {
  final color = complaintStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.5,
          height: 6.5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          status.isEmpty ? 'Processing' : status,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

String formatComplaintDateLabel(String rawDate, String idEpoch) {
  final ago = formatTimeAgo(idEpoch);
  if (rawDate.isNotEmpty) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed != null) {
      final d =
          '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
      return ago.isNotEmpty ? '$d • $ago' : d;
    }
  }
  return ago.isNotEmpty ? ago : 'Recently';
}

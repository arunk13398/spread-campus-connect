import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/gallery_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';

class FriendsProfile extends StatefulWidget {
  final UserListModel userListModel;
  const FriendsProfile({Key? key, required this.userListModel})
      : super(key: key);

  @override
  State<FriendsProfile> createState() => _FriendsProfileState();
}

class _FriendsProfileState extends State<FriendsProfile> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  List<GalleryModel> Glist = [];
  int _followersCount = 0;
  bool _isConnected = false;
  bool _isSelf = false;
  String _department = '';
  String _interest = '';
  String _liveImageUrl = '';

  @override
  void initState() {
    super.initState();
    _liveImageUrl = widget.userListModel.imageUrl;
    load();
    _loadFriendProfileMeta();
    _listenConnectionState();
  }

  Future<void> _listenConnectionState() async {
    final college = await getString(UserPreferences.COLLEGE);
    final number = await getString(UserPreferences.USER_NUMBER);
    if (college == null || number == null) return;
    if (number == widget.userListModel.Phone) {
      if (mounted) {
        setState(() {
          _isSelf = true;
        });
      }
      return;
    }
    mRootReference
        .child("UsersList")
        .child(college)
        .child(number)
        .child('Friends')
        .child(widget.userListModel.Phone)
        .onValue
        .listen((event) {
      if (!mounted) return;
      setState(() {
        _isConnected = event.snapshot.exists;
      });
    });
  }

  Future<void> _loadFriendProfileMeta() async {
    final u = widget.userListModel;
    if (u.College.isEmpty || u.Phone.isEmpty) return;
    mRootReference
        .child("UsersList")
        .child(u.College)
        .child(u.Phone)
        .child('Friends')
        .onValue
        .listen((event) {
      final raw = event.snapshot.value;
      if (!mounted) return;
      setState(() {
        _followersCount = raw is Map ? raw.length : 0;
      });
    });

    if (u.desigUser.isNotEmpty) {
      mRootReference
          .child("UsersList")
          .child(u.College)
          .child(u.Phone)
          .child(u.desigUser)
          .onValue
          .listen((event) {
        if (event.snapshot.exists && event.snapshot.value is Map) {
          final data = event.snapshot.value as Map;
          if (!mounted) return;
          setState(() {
            final img = (data['ImageUrl'] ?? '').toString();
            if (img.isNotEmpty) _liveImageUrl = img;
            _department = (data['Department'] ?? '').toString();
            _interest = (data['Interest'] ?? '').toString();
          });
        }
      });
    }
  }

  Future<void> _toggleConnect() async {
    final college = await getString(UserPreferences.COLLEGE);
    final number = await getString(UserPreferences.USER_NUMBER);
    if (college == null || number == null) return;
    final ref = mRootReference
        .child("UsersList")
        .child(college)
        .child(number)
        .child('Friends')
        .child(widget.userListModel.Phone);
    if (_isConnected) {
      await ref.remove();
    } else {
      await ref.update({"Id": widget.userListModel.Phone});
    }
  }

  void _openFullScreenAvatar() {
    final url = UserAvatarCache.instance.resolve(
          phone: widget.userListModel.Phone,
          name: widget.userListModel.userName,
          college: widget.userListModel.College,
          designation: widget.userListModel.desigUser,
        ) ??
        _liveImageUrl;
    if (url.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(
          imageUrl: url,
          heroTag: 'friend-avatar-${widget.userListModel.Phone}',
          title: widget.userListModel.userName,
          subtitle: widget.userListModel.College,
        ),
      ),
    );
  }

  void _openFullScreenPost(GalleryModel item) {
    if (item.gImageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(
          imageUrl: item.gImageUrl,
          heroTag: 'friend-post-${item.id}',
          title: widget.userListModel.userName,
          subtitle: item.Description,
        ),
      ),
    );
  }

  Widget _statColumn(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.isEmpty ? '-' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.userListModel;
    final subtitleParts = [
      if (u.desigUser.isNotEmpty) u.desigUser,
      if (_department.isNotEmpty) _department,
      if (u.College.isNotEmpty) u.College,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          u.userName,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openFullScreenAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
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
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Hero(
                              tag: 'friend-avatar-${u.Phone}',
                              child: liveProfileAvatar(
                                fallbackUrl: _liveImageUrl,
                                phone: u.Phone,
                                college: u.College,
                                designation: u.desigUser,
                                name: u.userName,
                                radius: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          children: [
                            _statColumn('${Glist.length}', 'Posts'),
                            _statColumn('$_followersCount', 'Followers'),
                            _statColumn(u.desigUser, 'Role'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    u.userName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitleParts.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitleParts.join(' • '),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  if (_interest.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _interest.split(',').map((e) => '#${e.trim()}').join(' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: MyColors.Colorgreen3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (!_isSelf) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: _isConnected
                          ? OutlinedButton.icon(
                              onPressed: _toggleConnect,
                              icon: const Icon(Icons.check_rounded, size: 17),
                              label: const Text(
                                'Connected',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: const Color(0xFFF5F6F8),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _toggleConnect,
                              icon: const Icon(Icons.person_add_outlined,
                                  size: 17),
                              label: const Text(
                                'Connect',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.Colorgreen3,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade200),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.grid_on_rounded,
                          size: 19, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text(
                        'Posts (${Glist.length})',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1.5,
                  color: Colors.black87,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          if (Glist.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_library_outlined,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        'No posts yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 2, bottom: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => galleryAdaptor(index),
                  childCount: Glist.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> load() async {
    mRootReference
        .child("UsersList")
        .child(widget.userListModel.College)
        .child(widget.userListModel.Phone)
        .child(widget.userListModel.desigUser)
        .child('Post')
        .onValue
        .listen((event) {
      Glist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            Glist.add(GalleryModel(
              id: key.toString(),
              Description: (value["Description"] ?? '').toString(),
              gImageUrl: (value["ImageUrl"] ?? '').toString(),
              ToPublish: (value["ToPublish"] ?? '').toString(),
            ));
          }
        });
        Glist.sort((a, b) {
          final bt = int.tryParse(b.id) ?? 0;
          final at = int.tryParse(a.id) ?? 0;
          return bt.compareTo(at);
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget galleryAdaptor(int index) {
    final item = Glist[index];
    return InkWell(
      onTap: () => _openFullScreenPost(item),
      child: Hero(
        tag: 'friend-post-${item.id}',
        child: Container(
          color: Colors.grey.shade200,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: item.gImageUrl,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

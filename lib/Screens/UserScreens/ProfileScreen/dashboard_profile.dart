import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/gallery_model.dart';
import '../../../Model/listdata_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/camera.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';
import '../AdditionalScreens/about_screen.dart';
import '../AdditionalScreens/help.dart';
import '../AdditionalScreens/privacy_policy.dart';
import '../LoginScreen/splash_screen.dart';
import 'edit_profile.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  List<GalleryModel> Glist = [];
  List<ListDataModel> userlistdata = [];

  String numberId = '';
  String UserName = '';
  String College = '';
  String Designation = '';
  String department = '';
  String interest = '';
  String imageUrl = '';
  String access = '';

  @override
  void initState() {
    super.initState();
    getDataF1();
    getDataF2();
    load();
    loadItem();
  }

  void _openFullScreenAvatar() {
    if (imageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(
          imageUrl: imageUrl,
          heroTag: 'profile-avatar-$numberId',
          title: UserName,
          subtitle: College,
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
          heroTag: 'profile-post-${item.id}',
          title: UserName,
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
    final subtitleParts = [
      if (Designation.isNotEmpty) Designation,
      if (department.isNotEmpty) department,
      if (College.isNotEmpty) College,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        UserName.isEmpty ? 'My Account' : UserName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'New post',
                      icon: const Icon(Icons.add_box_outlined,
                          color: Colors.black87, size: 24),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Camera()),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Menu',
                      icon: const Icon(Icons.menu_rounded,
                          color: Colors.black87, size: 25),
                      onPressed: () => showOptionsSheet(context),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                                tag: 'profile-avatar-$numberId',
                                child: profileAvatar(imageUrl, radius: 40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            children: [
                              _statColumn('${Glist.length}', 'Posts'),
                              _statColumn(
                                  '${userlistdata.length}', 'Followers'),
                              _statColumn(Designation, 'Role'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (UserName.isNotEmpty)
                      Text(
                        UserName,
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
                    if (interest.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        interest.split(',').map((e) => '#${e.trim()}').join(' '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: MyColors.Colorgreen3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, size: 17),
                              label: const Text(
                                'Edit profile',
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
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Camera()),
                                );
                              },
                              icon: const Icon(Icons.add_photo_alternate_outlined,
                                  size: 17),
                              label: const Text(
                                'Share post',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: const Color(0xFFF5F6F8),
                                side: BorderSide(color: Colors.grey.shade300),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        const SizedBox(height: 4),
                        Text(
                          'Share photos with your campus community',
                          style: TextStyle(
                            fontSize: 13,
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
      ),
    );
  }

  Future<void> getDataF2() async {
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    UserName = (await getString(UserPreferences.USER_Name)) ?? '';
    College = (await getString(UserPreferences.COLLEGE)) ?? '';
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    if (numberId.isEmpty) return;
    final value = await mRootReference
        .child("AccessControl")
        .child(numberId)
        .once();
    if (value.snapshot.exists && value.snapshot.value is Map) {
      Map<dynamic, dynamic> data = value.snapshot.value as Map;
      if (!mounted) return;
      setState(() {
        College = (data["College"] ?? College).toString();
        Designation = (data["Designation"] ?? Designation).toString();
        UserName = (data["Name"] ?? UserName).toString();
      });
    }
  }

  Future<void> getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    UserName = (await getString(UserPreferences.USER_Name)) ?? '';
    College = (await getString(UserPreferences.COLLEGE)) ?? '';
    final designation = await getString(UserPreferences.DESIGNATION);
    if (College.isEmpty || numberId.isEmpty || designation == null) return;
    mRootReference
        .child("UsersList")
        .child(College)
        .child(numberId)
        .child(designation)
        .onValue
        .listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        if (!mounted) return;
        setState(() {
          imageUrl = (data['ImageUrl'] ?? '').toString();
          UserName = (data['Name'] ?? UserName).toString();
          department = (data['Department'] ?? '').toString();
          interest = (data['Interest'] ?? '').toString();
        });
      }
    });
  }

  Future<void> load() async {
    final college = await getString(UserPreferences.COLLEGE);
    final number = await getString(UserPreferences.USER_NUMBER);
    final designation = await getString(UserPreferences.DESIGNATION);
    if (college == null || number == null || designation == null) return;
    mRootReference
        .child("UsersList")
        .child(college)
        .child(number)
        .child(designation)
        .child('Post')
        .onValue
        .listen((event) {
      Glist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          if (value is! Map<dynamic, dynamic>) return;
          Glist.add(GalleryModel(
            id: key.toString(),
            Description: (value["Description"] ?? '').toString(),
            gImageUrl: (value["ImageUrl"] ?? '').toString(),
            ToPublish: (value["ToPublish"] ?? 'All').toString(),
          ));
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
      onLongPress: () => showAlertDialogMoreGallery(context, index),
      onTap: () => _openFullScreenPost(item),
      child: Hero(
        tag: 'profile-post-${item.id}',
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

  void showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded),
                title: const Text('Help'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpScreen()),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setBool(UserPreferences.IS_LOGIN, false);
                  setString(UserPreferences.ACCESS_CODE, "");
                  setString(UserPreferences.USER_NUMBER, "");
                  setString(UserPreferences.USER_Name, "");
                  setString(UserPreferences.USER_TYPE, "");
                  finishAccountCreation(SplashScreen(), context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadItem() async {
    final college = await getString(UserPreferences.COLLEGE);
    final number = await getString(UserPreferences.USER_NUMBER);
    if (college == null || number == null) return;
    mRootReference
        .child("UsersList")
        .child(college)
        .child(number)
        .child('Friends')
        .onValue
        .listen((event) {
      userlistdata.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          userlistdata.add(ListDataModel(
            id: key.toString(),
          ));
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void showAlertDialogMoreGallery(BuildContext context, int index) {
    final item = Glist[index];
    showAppConfirmDialog(
      context: context,
      title: "Delete Post?",
      message: "Are you sure you want to permanently remove this post?",
      confirmLabel: "Delete",
      icon: Icons.delete_outline_rounded,
      accentColor: Colors.red.shade600,
      onConfirm: () async {
        final college = await getString(UserPreferences.COLLEGE);
        final number = await getString(UserPreferences.USER_NUMBER);
        final designation = await getString(UserPreferences.DESIGNATION);
        if (college != null && number != null && designation != null) {
          await mRootReference
              .child("UsersList")
              .child(college)
              .child(number)
              .child(designation)
              .child("Post")
              .child(item.id)
              .remove();
        }
        if (item.ToPublish.isNotEmpty) {
          await mRootReference
              .child('Feeds')
              .child(item.ToPublish)
              .child(item.id)
              .remove();
        }
      },
    );
  }
}

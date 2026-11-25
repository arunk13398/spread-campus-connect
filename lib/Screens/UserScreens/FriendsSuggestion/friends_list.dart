import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';
import 'friends_profile.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  final TextEditingController _searchController = TextEditingController();

  List<UserListModel> userlist = [];
  List<ListDataModel> userlistdata = [];

  String imageUrl = '';
  String College = '';
  String Designation = '';
  String UserType = '';
  String Status = '';
  String numberId = '';
  String _searchQuery = '';
  int _selectedFilter = 0; // 0 = All, 1 = Connected

  @override
  void initState() {
    super.initState();
    load();
    getDataAccess();
    loadItem();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    mRootReference.child("AccessControl").onValue.listen((event) {
      userlist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              value['Name'] != null &&
              value['Name'].toString().isNotEmpty) {
            userlist.add(UserListModel(
              id: key.toString(),
              userName: (value['Name'] ?? '').toString(),
              desigUser: (value['Designation'] ?? '').toString(),
              Phone: (value['Phone'] ?? key).toString(),
              College: (value['College'] ?? '').toString(),
              AccessName: (value['AcessName'] ?? '').toString(),
              imageUrl:
                  (value['ImageUrl'] ?? value['imageUrl'] ?? '').toString(),
              Status: (value['Status'] ?? '').toString(),
            ));
          }
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _toggleConnect(UserListModel user, bool isConnected) async {
    if (Status == "blocked") {
      showAlertDialogBloked(context);
      return;
    }
    final college = await getString(UserPreferences.COLLEGE);
    final userNum = await getString(UserPreferences.USER_NUMBER);
    if (college == null || userNum == null) return;
    final friendsRef = mRootReference
        .child("UsersList")
        .child(college)
        .child(userNum)
        .child('Friends')
        .child(user.Phone);
    if (isConnected) {
      await friendsRef.remove();
    } else {
      await friendsRef.update({"Id": user.Phone});
    }
  }

  List<UserListModel> get _otherUsers {
    return userlist
        .where((u) => numberId.isEmpty || u.Phone != numberId)
        .toList();
  }

  List<UserListModel> get _filteredUsers {
    final q = _searchQuery.trim().toLowerCase();
    return _otherUsers.where((u) {
      if (_selectedFilter == 1 &&
          !userlistdata.any((item) => item.id == u.Phone)) {
        return false;
      }
      if (q.isEmpty) return true;
      return u.userName.toLowerCase().contains(q) ||
          u.College.toLowerCase().contains(q) ||
          u.desigUser.toLowerCase().contains(q);
    }).toList();
  }

  Widget _filterChip(String label, int index) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? MyColors.Colorgreen3 : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherUsers = _otherUsers;
    final visibleUsers = _filteredUsers;
    final connectedCount = otherUsers
        .where((u) => userlistdata.any((item) => item.id == u.Phone))
        .length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Recommended For You",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: MyColors.Colorgreen3.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${otherUsers.length} ${otherUsers.length == 1 ? 'person' : 'people'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Colorgreen3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(fontSize: 14.5, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Search by name, college or role...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: Colors.grey.shade500, size: 21),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded,
                                  color: Colors.grey.shade500, size: 19),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF5F6F8),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _filterChip('All (${otherUsers.length})', 0),
                      const SizedBox(width: 8),
                      _filterChip('Connected ($connectedCount)', 1),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade200),
            Expanded(
              child: visibleUsers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline_rounded,
                                size: 52, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              _selectedFilter == 1
                                  ? 'No connections yet'
                                  : otherUsers.isEmpty
                                      ? 'No people to discover yet'
                                      : 'No matching people',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedFilter == 1
                                  ? 'Tap Connect on profiles to follow them'
                                  : otherUsers.isEmpty
                                      ? 'Other students and faculty will appear here'
                                      : 'Try a different name, college, or role',
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
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                      itemCount: visibleUsers.length,
                      itemBuilder: (context, index) =>
                          _buildPersonCard(visibleUsers[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonCard(UserListModel user) {
    final isConnected = userlistdata.any((item) => item.id == user.Phone);
    final isSelf = numberId.isNotEmpty && user.Phone == numberId;
    final subtitleParts = [
      if (user.desigUser.isNotEmpty) user.desigUser,
      if (user.College.isNotEmpty) user.College,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (Status == "blocked") {
            showAlertDialogBloked(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendsProfile(userListModel: user),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              liveProfileAvatar(
                fallbackUrl: user.imageUrl,
                phone: user.Phone,
                college: user.College,
                designation: user.desigUser,
                name: user.userName,
                radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (isSelf) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'You',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isSelf) ...[
                const SizedBox(width: 10),
                SizedBox(
                  height: 34,
                  child: isConnected
                      ? OutlinedButton.icon(
                          onPressed: () => _toggleConnect(user, true),
                          icon: const Icon(Icons.check_rounded, size: 15),
                          label: const Text(
                            'Connected',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade800,
                            backgroundColor: const Color(0xFFF5F6F8),
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => _toggleConnect(user, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.Colorgreen3,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE)) ?? '';
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
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
        UserType = (data["AcessName"] ?? '').toString();
        numberId = (data["Phone"] ?? numberId).toString();
        Status = (data["Status"] ?? '').toString();
      });
    }
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
}

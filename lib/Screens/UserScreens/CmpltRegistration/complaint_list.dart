import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/complaint_model.dart';
import '../../../Model/listdata_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';
import 'Complaint_details.dart';
import 'complaint_registration.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({Key? key}) : super(key: key);

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ComplaintModel> ComplaintList = [];
  List<ListDataModel> datalist = [];

  String numberId = '';
  String UserName = '';
  String College = '';
  String Designation = '';
  String UserType = '';
  String Status = '';
  int isColorSelected = 0;

  StreamSubscription<DatabaseEvent>? _complaintSub;

  bool get _isReviewer =>
      UserType == "Principal" ||
      UserType == "Hod" ||
      UserType == "Admin" ||
      UserType == "Hos" ||
      UserType == "OfficeStaff" ||
      UserType == "Reviewer";

  @override
  void initState() {
    super.initState();
    getDataAccess();
    loadItem();
    loadComplaint1();
  }

  @override
  void dispose() {
    _complaintSub?.cancel();
    super.dispose();
  }

  void _openDetails(ComplaintModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetails(complaintModel: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Registered Complaints",
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
                          '${ComplaintList.length}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Colorgreen3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isReviewer && datalist.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: datalist.length,
                        itemBuilder: (context, index) => AdaptorNew(index),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade200),
            Expanded(
              child: ComplaintList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 52, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              "No complaints yet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap below to submit a new complaint",
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
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      itemCount: ComplaintList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ComplaintListAdaptor(index);
                      },
                    ),
            ),
            if (Designation != 'Alumni' && Status != "blocked")
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplaintRegistration(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        size: 20),
                    label: const Text(
                      "Register a Complaint",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.Colorgreen3,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _parseComplaintsSnapshot(Object? raw) {
    ComplaintList.clear();
    if (raw is Map<dynamic, dynamic>) {
      raw.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          ComplaintList.add(ComplaintModel(
            id: key.toString(),
            rAdmNumber: (value['AdmissionNo'] ?? '').toString(),
            rClgNo: (value['RegisterNo'] ?? '').toString(),
            rCmptText: (value['Complaint'] ?? '').toString(),
            rDate: (value['Date'] ?? '').toString(),
            rMobNumber: (value['MobileNumber'] ?? '').toString(),
            rName: (value['Name'] ?? '').toString(),
            rSubject: (value['Subject'] ?? '').toString(),
            rTo: (value['To'] ?? '').toString(),
            rStatus: (value['Status'] ?? '').toString(),
          ));
        }
      });
      ComplaintList.sort((a, b) {
        final bt = int.tryParse(b.id) ?? 0;
        final at = int.tryParse(a.id) ?? 0;
        return bt.compareTo(at);
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadComplaint1() async {
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    if (numberId.isEmpty) return;
    _complaintSub?.cancel();
    _complaintSub = mRootReference
        .child("Complaints")
        .child(numberId)
        .onValue
        .listen((event) {
      _parseComplaintsSnapshot(event.snapshot.value);
    });
  }

  Future<void> loadComplaint2() async {
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    UserType = (await getString(UserPreferences.ACCESSTYPE)) ?? '';
    if (UserType.isEmpty) return;
    _complaintSub?.cancel();
    _complaintSub = mRootReference
        .child("Complaints")
        .child("AdminAccess")
        .child(UserType)
        .onValue
        .listen((event) {
      _parseComplaintsSnapshot(event.snapshot.value);
    });
  }

  Widget ComplaintListAdaptor(int index) {
    final item = ComplaintList[index];
    final dateLabel = formatComplaintDateLabel(item.rDate, item.id);

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
        onTap: () => _openDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  liveProfileAvatar(
                    fallbackUrl: '',
                    phone: item.rMobNumber,
                    name: item.rName,
                    radius: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.rSubject.isEmpty ? 'Complaint' : item.rSubject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.rName.isEmpty ? 'User' : item.rName}  •  To: ${item.rTo}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  complaintStatusBadge(item.rStatus),
                ],
              ),
              if (item.rCmptText.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  item.rCmptText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: MyColors.Colorgreen3,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: MyColors.Colorgreen3,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE)) ?? '';
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    final phone = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    if (phone.isEmpty) return;
    final value =
        await mRootReference.child("AccessControl").child(phone).once();
    if (value.snapshot.exists && value.snapshot.value is Map) {
      final Map<dynamic, dynamic> data = value.snapshot.value as Map;
      College = (data["College"] ?? College).toString();
      Designation = (data["Designation"] ?? Designation).toString();
      UserType = (data["AcessName"] ?? '').toString();
      Status = (data["Status"] ?? '').toString();
      numberId = (data["Phone"] ?? phone).toString();
      if (mounted) {
        setState(() {});
      }
      if (_isReviewer && isColorSelected == 0) {
        loadComplaint2();
      } else {
        loadComplaint1();
      }
    }
  }

  Future<void> loadItem() async {
    mRootReference
        .child("AccessManagement")
        .child("ComplaintAccess")
        .onValue
        .listen((event) {
      datalist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          datalist.add(ListDataModel(
            id: key.toString(),
          ));
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget AdaptorNew(int index) {
    final selected = isColorSelected == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          isColorSelected = index;
        });
        if (datalist[index].id == "ToReview") {
          loadComplaint2();
        } else {
          loadComplaint1();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? MyColors.Colorgreen3 : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          datalist[index].id,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

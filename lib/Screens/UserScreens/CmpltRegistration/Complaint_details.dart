import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/complaint_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';
import '../../Adminbottom_navigation.dart';
import '../../bottom_navigation.dart';

class ComplaintDetails extends StatefulWidget {
  final ComplaintModel complaintModel;
  const ComplaintDetails({Key? key, required this.complaintModel})
      : super(key: key);

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  final TextEditingController ReviewComplaintText = TextEditingController();

  bool _showReviewForm = false;
  bool _showTimeline = false;
  bool _isSubmitting = false;

  String numberId = '';
  String UserName = '';
  String College = '';
  String Designation = '';
  String imageUrl = '';
  String UserType = '';

  String _ReviewDpValue = 'Processing';
  final List<String> _ReviewList = const [
    'Processing',
    'Verified',
    'Rejected',
    'Waiting',
    'Forwarded',
  ];

  final List<Map<String, String>> _reviews = [];
  String _currentStatus = '';
  StreamSubscription<DatabaseEvent>? _reviewSub;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.complaintModel.rStatus.isNotEmpty
        ? widget.complaintModel.rStatus
        : 'Processing';
    getDataF1();
    getReviewDetails();
    getDataAccess();
  }

  @override
  void dispose() {
    _reviewSub?.cancel();
    ReviewComplaintText.dispose();
    super.dispose();
  }

  int _timelineStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'rejected':
      case 'resolved':
      case 'approved':
        return 2;
      case 'waiting':
      case 'forwarded':
        return 1;
      default:
        return _reviews.isNotEmpty ? 1 : 0;
    }
  }

  Widget _metaItem(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String status) {
    final step = _timelineStepIndex(status);
    final isRejected = status.toLowerCase() == 'rejected';
    final steps = [
      'Submitted',
      'Under Review',
      isRejected ? 'Rejected' : 'Resolved',
    ];
    final activeColor = isRejected ? Colors.red.shade600 : MyColors.Colorgreen3;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final lineActive = (i ~/ 2) < step;
            return Expanded(
              child: Container(
                height: 2,
                color: lineActive ? activeColor : Colors.grey.shade300,
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx <= step;
          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? activeColor : Colors.grey.shade200,
                ),
                child: Icon(
                  done
                      ? (idx == 2 && isRejected
                          ? Icons.close_rounded
                          : Icons.check_rounded)
                      : Icons.circle_outlined,
                  size: 14,
                  color: done ? Colors.white : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                steps[idx],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                  color: done ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.complaintModel;
    final dateLabel = formatComplaintDateLabel(c.rDate, c.id);
    final isReviewer = UserType.isNotEmpty && UserType == c.rTo;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Complaint Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: complaintStatusBadge(_currentStatus)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main complaint card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.rSubject.isEmpty ? 'Complaint' : c.rSubject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      liveProfileAvatar(
                        fallbackUrl: '',
                        phone: c.rMobNumber,
                        name: c.rName,
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.rName.isEmpty ? 'Student' : c.rName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              dateLabel,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'To: ${c.rTo}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (c.rAdmNumber.isNotEmpty || c.rClgNo.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _metaItem(
                            Icons.badge_outlined, 'Admission No', c.rAdmNumber),
                        if (c.rAdmNumber.isNotEmpty && c.rClgNo.isNotEmpty)
                          const SizedBox(width: 12),
                        _metaItem(Icons.confirmation_number_outlined,
                            'Register No', c.rClgNo),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 12),
                  Text(
                    c.rCmptText,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Track application progress card
            if (!isReviewer)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _showTimeline = !_showTimeline),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timeline_rounded,
                                color: MyColors.Colorgreen3, size: 22),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Application Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              _showTimeline
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                        if (_showTimeline) _buildTimelineRow(_currentStatus),
                      ],
                    ),
                  ),
                ),
              ),

            // Official review replies
            if (_reviews.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Official Response',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              ..._reviews.map((rev) {
                final revStatus = rev['status'] ?? '';
                final revAgo = formatTimeAgo(rev['date'] ?? '');
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          liveProfileAvatar(
                            fallbackUrl: rev['avatar'] ?? '',
                            phone: rev['phone'] ?? '',
                            name: rev['designation'] ?? c.rTo,
                            radius: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (rev['designation'] ?? '').isNotEmpty
                                      ? rev['designation']!
                                      : c.rTo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: Colors.black,
                                  ),
                                ),
                                if (revAgo.isNotEmpty)
                                  Text(
                                    revAgo,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (revStatus.isNotEmpty)
                            complaintStatusBadge(revStatus),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        rev['message'] ?? '',
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.45,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            // Authorizer / Admin review composer
            if (isReviewer) ...[
              const SizedBox(height: 14),
              if (!_showReviewForm)
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _showReviewForm = true),
                    icon: const Icon(Icons.rate_review_outlined, size: 19),
                    label: const Text(
                      'Review Complaint',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _ReviewDpValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: _ReviewList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue == null) return;
                                  setState(() {
                                    _ReviewDpValue = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: ReviewComplaintText,
                        minLines: 3,
                        maxLines: 6,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Review Response',
                          hintText: 'Write your reply or action taken...',
                          filled: true,
                          fillColor: const Color(0xFFF5F6F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () async {
                                  if (ReviewComplaintText.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please enter a review note'),
                                      ),
                                    );
                                    return;
                                  }
                                  await AddReviewComplaint();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.Colorgreen3,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Submit Review',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> AddReviewComplaint() async {
    setState(() => _isSubmitting = true);
    try {
      final HashMap<String, dynamic> data = HashMap<String, dynamic>();
      final String id1 = DateTime.now().millisecondsSinceEpoch.toString();
      final String id = widget.complaintModel.id;
      final String id2 = widget.complaintModel.rMobNumber;
      data["Id"] = id;
      data["ReviewMobileNumber"] = numberId;
      data["ReviewDesignation"] = Designation;
      data["ReviewDate"] = id1;
      data["ReviewStatus"] = _ReviewDpValue;
      data["ReviewerProfImg"] = imageUrl;
      data["ComplaintReview"] = ReviewComplaintText.text.trim();
      data["Date"] = DateTime.now().toString();
      data["Time"] = id1;

      final HashMap<String, dynamic> dataReview = HashMap<String, dynamic>();
      dataReview["Status"] = _ReviewDpValue;

      await mRootReference
          .child("Complaints")
          .child(id2)
          .child(id)
          .child("Review")
          .child(id1)
          .update(data);
      await mRootReference
          .child("Complaints")
          .child(widget.complaintModel.rMobNumber)
          .child(widget.complaintModel.id)
          .update(dataReview);
      await mRootReference
          .child("Complaints")
          .child("AdminAccess")
          .child(widget.complaintModel.rTo)
          .child(widget.complaintModel.id)
          .update(dataReview);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted")),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        finishAccountCreation(
          Designation == 'Admin' ? AdminBottomNavigation() : BottomNavigation(),
          context,
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    UserType = (await getString(UserPreferences.ACCESSTYPE)) ?? '';
    UserName = (await getString(UserPreferences.USER_Name)) ?? '';
    College = (await getString(UserPreferences.COLLEGE)) ?? '';
    Designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    if (College.isEmpty || numberId.isEmpty || Designation.isEmpty) return;
    final value = await mRootReference
        .child("UsersList")
        .child(College)
        .child(numberId)
        .child(Designation)
        .once();
    if (value.snapshot.exists && value.snapshot.value is Map) {
      final Map<dynamic, dynamic> data = value.snapshot.value as Map;
      if (!mounted) return;
      setState(() {
        imageUrl = (data['ImageUrl'] ?? '').toString();
        Designation = (data['Designation'] ?? Designation).toString();
      });
    }
  }

  void getReviewDetails() {
    _reviewSub = mRootReference
        .child("Complaints")
        .child(widget.complaintModel.rMobNumber)
        .child(widget.complaintModel.id)
        .child("Review")
        .onValue
        .listen((event) {
      _reviews.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        if (raw.containsKey('ComplaintReview')) {
          _reviews.add({
            'id': 'legacy',
            'phone': (raw['ReviewMobileNumber'] ?? '').toString(),
            'designation': (raw['ReviewDesignation'] ?? '').toString(),
            'date': (raw['ReviewDate'] ?? '').toString(),
            'status': (raw['ReviewStatus'] ?? '').toString(),
            'avatar': (raw['ReviewerProfImg'] ?? '').toString(),
            'message': (raw['ComplaintReview'] ?? '').toString(),
          });
        } else {
          raw.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              _reviews.add({
                'id': key.toString(),
                'phone': (value['ReviewMobileNumber'] ?? '').toString(),
                'designation': (value['ReviewDesignation'] ?? '').toString(),
                'date': (value['ReviewDate'] ?? value['Time'] ?? '').toString(),
                'status': (value['ReviewStatus'] ?? '').toString(),
                'avatar': (value['ReviewerProfImg'] ?? '').toString(),
                'message': (value['ComplaintReview'] ?? '').toString(),
              });
            }
          });
          _reviews.sort((a, b) {
            final bt = int.tryParse(b['date'] ?? '') ?? 0;
            final at = int.tryParse(a['date'] ?? '') ?? 0;
            return bt.compareTo(at);
          });
        }
        if (_reviews.isNotEmpty && (_reviews.first['status'] ?? '').isNotEmpty) {
          _currentStatus = _reviews.first['status']!;
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
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
      if (!mounted) return;
      setState(() {
        College = (data["College"] ?? College).toString();
        Designation = (data["Designation"] ?? Designation).toString();
        UserType = (data["AcessName"] ?? '').toString();
        numberId = (data["Phone"] ?? phone).toString();
      });
    }
  }
}

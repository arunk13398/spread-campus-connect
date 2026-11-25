import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Theme/theme.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';
import '../../bottom_navigation.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ListDataModel> datalist = [];
  ListDataModel? selectedItem;

  XFile? file;
  String imageUrl = '';
  String numberId = '';
  String UserName = '';
  String College = '';
  String Designation = '';
  String AccessName = '';
  String Phone = '';
  String access = '';
  String UserType = '';
  String Status = '';

  bool _isChecked = false;
  bool _isChecked1 = false;
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isRequesting = false;

  final TextEditingController UserNameController = TextEditingController();
  final TextEditingController UserDesignationController =
      TextEditingController();
  final TextEditingController UserCollegeController = TextEditingController();
  final TextEditingController UserNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataF1();
    getdata();
    loadItem();
    getDataAccess();
  }

  @override
  void dispose() {
    UserNameController.dispose();
    UserDesignationController.dispose();
    UserCollegeController.dispose();
    UserNumberController.dispose();
    super.dispose();
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
        Status = (data["Status"] ?? '').toString();
      });
    }
  }

  Future<void> getDataF1() async {
    final college = (await getString(UserPreferences.COLLEGE)) ?? '';
    final phone = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    final designation = (await getString(UserPreferences.DESIGNATION)) ?? '';
    if (college.isEmpty || phone.isEmpty || designation.isEmpty) return;
    final value = await mRootReference
        .child("UsersList")
        .child(college)
        .child(phone)
        .child(designation)
        .once();
    if (value.snapshot.exists && value.snapshot.value is Map) {
      final Map<dynamic, dynamic> data = value.snapshot.value as Map;
      if (!mounted) return;
      setState(() {
        UserCollegeController.text = (data["College"] ?? '').toString();
        UserDesignationController.text = (data["Designation"] ?? '').toString();
        UserNameController.text = (data["Name"] ?? '').toString();
        UserNumberController.text = (data["Phone"] ?? '').toString();
        AccessName = (data["AcessName"] ?? '').toString();
        imageUrl = (data['ImageUrl'] ?? '').toString();
      });
    }
  }

  Future<void> loadItem() async {
    final designation = await getString(UserPreferences.DESIGNATION);
    if (designation == null || designation.toString().isEmpty) return;
    mRootReference
        .child("AccessManagement")
        .child("Designation")
        .child(designation.toString())
        .child("Access")
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

  Future<void> _pickAndUploadAvatar() async {
    if (Status == "blocked") {
      showAlertDialogBloked(context);
      return;
    }
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Image',
          toolbarColor: MyColors.Colorgreen3,
          toolbarWidgetColor: Colors.white,
          cropStyle: CropStyle.circle,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Profile Image',
          cropStyle: CropStyle.circle,
        ),
      ],
    );
    if (cropped == null) return;

    if (!mounted) return;
    setState(() {
      file = XFile(cropped.path);
      _isUploading = true;
    });

    final String uniqueFileName =
        DateTime.now().millisecondsSinceEpoch.toString();
    final Reference referenceImageToUpload = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('ProfileImage')
        .child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(cropped.path));
      final uploadedUrl = await referenceImageToUpload.getDownloadURL();
      if (!mounted) return;
      setState(() {
        imageUrl = uploadedUrl;
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Photo ready — tap Update Profile to save"),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });
      alertDialog(context, "Upload Failed", error.toString());
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: enabled ? Colors.black : Colors.grey.shade700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13.5,
          color: Colors.grey.shade600,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: enabled ? MyColors.Colorgreen3 : Colors.grey.shade500,
        ),
        filled: true,
        fillColor:
            enabled ? const Color(0xFFF6F7F9) : const Color(0xFFF9FAFB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.Colorgreen3, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          child: Column(
            children: [
              // Avatar card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadAvatar,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
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
                              padding: const EdgeInsets.all(2.5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: file != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          FileImage(File(file!.path)),
                                      radius: 52,
                                    )
                                  : profileAvatar(imageUrl, radius: 52),
                            ),
                          ),
                          if (_isUploading)
                            const CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.black45,
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          else
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: MyColors.Colorgreen3,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickAndUploadAvatar,
                      child: Text(
                        _isUploading
                            ? 'Uploading photo...'
                            : 'Change profile photo',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: MyColors.Colorgreen3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Personal Details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Personal Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                        if (Status != "blocked")
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _isChecked1
                                      ? MyColors.Colorgreen3
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Switch.adaptive(
                                value: _isChecked1,
                                activeTrackColor: MyColors.Colorgreen3,
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked1 = val;
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildField(
                      controller: UserNameController,
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      enabled: _isChecked1,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: UserNumberController,
                      label: 'Mobile Number',
                      icon: Icons.call_outlined,
                      enabled: _isChecked1,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: UserCollegeController,
                      label: 'College',
                      icon: Icons.location_city_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: UserDesignationController,
                      label: 'Designation',
                      icon: Icons.badge_outlined,
                      enabled: false,
                    ),
                    if (Status != "blocked") ...[
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  if (_isUploading) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please wait for photo upload to finish"),
                                      ),
                                    );
                                    return;
                                  }
                                  addCustomer();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.Colorgreen3,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (AccessName != "Admin" && access != "2") ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  MyColors.Colorgreen3.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.admin_panel_settings_outlined,
                              color: MyColors.Colorgreen3,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Request Account Access",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: _isChecked,
                            activeTrackColor: MyColors.Colorgreen3,
                            onChanged: (val) {
                              setState(() {
                                _isChecked = val;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Switch to an elevated campus role after admin verification to unlock additional management features.",
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (_isChecked) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ListDataModel>(
                              value: selectedItem,
                              isExpanded: true,
                              hint: Text(
                                'Select access role',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onChanged: (ListDataModel? newValue) {
                                setState(() {
                                  selectedItem = newValue;
                                });
                              },
                              items: datalist.map<DropdownMenuItem<ListDataModel>>(
                                (ListDataModel value) {
                                  return DropdownMenuItem<ListDataModel>(
                                    value: value,
                                    child: Text(value.id),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: _isRequesting
                                ? null
                                : () async {
                                    if (selectedItem == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Please select an access role first"),
                                        ),
                                      );
                                      return;
                                    }
                                    await PageRequest();
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: MyColors.Colorgreen3,
                              side: BorderSide(color: MyColors.Colorgreen3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isRequesting
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: MyColors.Colorgreen3,
                                    ),
                                  )
                                : const Text(
                                    "Request Admin Approval",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addCustomer() async {
    setState(() {
      _isSaving = true;
    });
    try {
      final id = (await getString(UserPreferences.USER_NUMBER)) ?? '';
      final id1 = (await getString(UserPreferences.DESIGNATION)) ?? '';
      final id2 = (await getString(UserPreferences.COLLEGE)) ?? '';
      if (id.isEmpty || id1.isEmpty || id2.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final HashMap<String, dynamic> updateData = HashMap<String, dynamic>();
      updateData["Name"] = UserNameController.text.trim();
      updateData["Phone"] = UserNumberController.text.trim();
      updateData["College"] = UserCollegeController.text.trim();
      updateData["Designation"] = UserDesignationController.text.trim();
      updateData["ImageUrl"] = imageUrl;

      final HashMap<String, dynamic> updateAcsessControl =
          HashMap<String, dynamic>();
      updateAcsessControl["Name"] = UserNameController.text.trim();
      updateAcsessControl["Phone"] = UserNumberController.text.trim();
      updateAcsessControl["College"] = UserCollegeController.text.trim();
      updateAcsessControl["Designation"] = UserDesignationController.text.trim();
      updateAcsessControl["ImageUrl"] = imageUrl;

      await mRootReference
          .child("UsersList")
          .child(id2)
          .child(id)
          .child(id1)
          .update(updateData);
      await mRootReference
          .child("AccessControl")
          .child(id)
          .update(updateAcsessControl);

      setString(UserPreferences.USER_Name, UserNameController.text.trim());
      setString(UserPreferences.COLLEGE, UserCollegeController.text.trim());
      setString(
          UserPreferences.DESIGNATION, UserDesignationController.text.trim());
      setString(UserPreferences.USER_NUMBER, UserNumberController.text.trim());

      UserAvatarCache.instance.seed(
        phone: UserNumberController.text.trim(),
        name: UserNameController.text.trim(),
        imageUrl: imageUrl,
      );

      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        finishAccountCreation(BottomNavigation(), context);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      alertDialog(context, "Update Failed", error.toString());
    }
  }

  Future<void> PageRequest() async {
    setState(() => _isRequesting = true);
    try {
      final String id = (await getString(UserPreferences.USER_NUMBER)) ?? '';
      if (id.isEmpty || selectedItem == null) return;

      final HashMap<String, dynamic> updateData = HashMap<String, dynamic>();
      updateData["id"] = id;
      updateData["Name"] = UserNameController.text.trim();
      updateData["Phone"] = UserNumberController.text.trim();
      updateData["College"] = UserCollegeController.text.trim();
      updateData["Designation"] = UserDesignationController.text.trim();
      updateData["RequestTo"] = selectedItem!.id;
      updateData["ImageUrl"] = imageUrl;
      await mRootReference.child("PageRequest").child(id).update(updateData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access request submitted")),
      );
    } catch (error) {
      if (!mounted) return;
      alertDialog(context, "Request Failed", error.toString());
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  Future<void> getdata() async {
    AccessName = (await getString(UserPreferences.USER_Name)) ?? '';
    access = (await getString(UserPreferences.ACCESS_CODE)) ?? '';
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/splash_screen.dart';
import 'package:miniq/functions/sliding_right_route.dart';

import '../Theme/theme.dart';

final List<TextInputFormatter> decimalValidation = [
  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
  TextInputFormatter.withFunction((oldValue, newValue) {
    try {
      final text = newValue.text;
      if (text.isNotEmpty) {
        double.parse(text);
      }
      return newValue;
    } catch (e) {}
    return oldValue;
  })];

onLoading(var context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2.8,
                  color: MyColors.Colorgreen3,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Reusable modern confirmation dialog with icon badge, clear message, and
/// balanced Cancel / Confirm actions.
Future<void> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
  IconData icon = Icons.help_outline_rounded,
  Color? accentColor,
  String cancelLabel = 'Cancel',
}) {
  final Color color = accentColor ?? MyColors.Colorgreen3;
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
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
                        child: Text(
                          cancelLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Interactive option row for action/menu dialogs.
Widget dialogOptionRow({
  required IconData icon,
  required String title,
  String? subtitle,
  Color? iconColor,
  required VoidCallback onTap,
}) {
  final Color tint = iconColor ?? MyColors.Colorgreen3;
  return Material(
    color: const Color(0xFFF6F7F9),
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: tint, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    ),
  );
}

showAlertDialog(BuildContext context) {
  showAppConfirmDialog(
    context: context,
    title: 'Log Out?',
    message: 'Are you sure you want to log out of your account?',
    confirmLabel: 'Log Out',
    icon: Icons.logout_rounded,
    accentColor: Colors.red.shade600,
    onConfirm: () {
      setBool(UserPreferences.IS_LOGIN, false);
      setString(UserPreferences.ACCESS_CODE, "");
      setString(UserPreferences.USER_NUMBER, "");
      setString(UserPreferences.USER_Name, "");
      setString(UserPreferences.USER_TYPE, "");
      finishAccountCreation(SplashScreen(), context);
    },
  );
}

alertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/letterblacknewcolor.png", height: 34),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.Colorgreen3,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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

optionDialog(BuildContext context, String title, String content) {
  alertDialog(context, title, content);
}


// Future<void> makePhoneCall(String phoneNumber) async {
//   final Uri launchUri = Uri(
//     scheme: 'tel',
//     path: phoneNumber,
//   );
//   await launch(launchUri.toString());
// }

callNext(var className, var context) {
  Navigator.push(context, SlideRightRoute(page: className));
}

callTo(var className, var context) {
  Navigator.pushReplacement(context, SlideRightRoute(page: className));
}
void finishAccountCreation(var className, var context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => className),
    ModalRoute.withName('/'),
  );
}
Widget space15 = const SizedBox(
  height: 15,
);
Widget space10 = const SizedBox(
  height: 15,
);
Widget space5 = const SizedBox(
  height: 10,
);

back(var context) {
  Navigator.pop(context);
}

void finish(context) {
  Navigator.pop(context);
}

void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

callNextReplacement(var className, var context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => className),
  );
}

Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff$hex' : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getDateOnly(String date) {
  var input = DateFormat('MM/dd/yyyy hh:mm:ss aaa').parse(date);
  String output = DateFormat('dd/MM/yyyy').format(input);
  return output;
}

Stream<String> getTime() async* {
  String time;

  time = DateTime.parse("1969-07-20 20:18:04Z") as String;
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield time;
  }
}
void showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Center(
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2.8,
              color: MyColors.Colorgreen3,
            ),
          ),
        ),
      ),
    ),
  );
}

showAlertDialogBloked(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/letterblacknewcolor.png", height: 34),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.block_rounded,
                    color: Colors.red.shade600, size: 28),
              ),
              const SizedBox(height: 12),
              const Text(
                "Account Restricted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your account is currently blocked for security reasons due to policy violations. Please contact support for assistance.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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

// getDataAccess(mRootReference,String College,String Designation,String UserType,String numberId,) async {
//   DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
//   mRootReference
//       .child("AccessControl")
//       .child(await getString(UserPreferences.USER_NUMBER))
//       .once()
//       .then((value) {
//     if (value.snapshot.exists) {
//       print("fffffff ${value.snapshot.value}");
//       Map<dynamic, dynamic> data = value.snapshot.value as Map;
//       College = data["College"];
//       Designation = data["Designation"];
//       UserType = data["AcessName"];
//       numberId =data["Phone"];
//     }
//   });
// }


// getDataF1() async {
//   numberId = (await getString(UserPreferences.USER_NUMBER));
//   UserName = (await getString(UserPreferences.USER_Name));
//   College = (await getString(UserPreferences.COLLEGE));
//   mRootReference
//       .child("AccessControl")
//       .child(await getString(UserPreferences.USER_NUMBER))
//       .once()
//       .then((value) {
//     if (value.snapshot.exists) {
//       print("efgh ${value.snapshot.value}");
//       Map<dynamic, dynamic> data = value.snapshot.value as Map;
//       College = data["College"];
//       Designation = data["Designation"];
//       setState(() {});
//     }
//   });
// }
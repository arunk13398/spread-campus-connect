import 'package:flutter/material.dart';

class NotificationModel{
  String name;
  String id;
  String college;
  String subject;
  String notificationContent;
  String designation;
  String ProfileImg;


  NotificationModel({
        required this.name,
        required this.college,
        required this.designation,
        required this.id,
        required this.notificationContent,
        required this.subject,
        required this.ProfileImg,
      }
      );
}
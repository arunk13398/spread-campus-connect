class ComplaintModel{
  String id;
  String rName;
  String rMobNumber;
  String rClgNo;
  String rAdmNumber;
  String rTo;
  String rSubject;
  String rCmptText;
  String rDate;
  String rStatus;

  ComplaintModel({
    required this.id,
    required this.rName,
    required this.rAdmNumber,
    required this.rClgNo,
    required this.rCmptText,
    required this.rDate,
    required this.rMobNumber,
    required this.rSubject,
    required this.rTo,
    required this.rStatus,
});
}
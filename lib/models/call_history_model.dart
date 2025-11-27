class CallHistoryModel {
  final int? id;
  final int contactId;
  final String callDate;

  CallHistoryModel({
    this.id,
    required this.contactId,
    required this.callDate,
  });
  // refactor data that come from the data base
  factory CallHistoryModel.fromMap(Map<String, dynamic> json) =>
      CallHistoryModel(
        id: json["id"],
        contactId: json["contact_id"],
        callDate: json["call_date"],
      );

  // refactor  object to a map so I can send it to the database
  Map<String, dynamic> toMap() => {
    "id": id,
    "contact_id": contactId,
    "call_date": callDate,
  };
}

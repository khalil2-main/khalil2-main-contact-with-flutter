import 'package:contact/models/call_history_model.dart';
import 'package:contact/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/widgets/call_history_card.dart';
import 'package:contact/db/db_helper.dart';

class CallHistoryPage extends StatefulWidget {
  final UserModel user;

  const CallHistoryPage({super.key, required this.user});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<CallHistoryModel> history = [];
  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final db = DBHelper.instance;

   /// Load all contacts for that user
    final contactRows = await db.getContactsByUser(widget.user.id!);
    contacts = contactRows.map((row) => ContactModel.fromMap(row)).toList();

    /// use Contacts to load the call history
    List<CallHistoryModel> tempHistory = [];

    for (var contact in contacts) {
      final rows = await db.getCallHistoryByContact(contact.id!);

      for (var row in rows) {
        tempHistory.add(
          CallHistoryModel.fromMap({
            "id": row["id"],
            "contact_id": contact.id,
            "call_date": row["call_date"],
          }),
        );
      }
    }

    // 3. Sort history call by date
    tempHistory.sort((a, b) => b.callDate.compareTo(a.callDate));

    setState(() {
      history = tempHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: history.isEmpty
          ? const Center(child: Text("No call history"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final call = history[index];

          // Find the related contact
          final contact = contacts.firstWhere(
                  (c) => c.id == call.contactId,
              orElse: () => ContactModel(
                  name: "Unknown",
                  phoneNumber: "",
                  isFav: false));

          return CallHistoryCard(
            contact: contact,
            callDate: call.callDate,
          );
        },
      ),
    );
  }
}

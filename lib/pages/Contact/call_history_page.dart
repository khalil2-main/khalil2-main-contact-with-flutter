import 'package:flutter/material.dart';
import 'package:contact/models/call_history_model.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/widgets/call_history_card.dart';
import 'package:contact/db/db_helper.dart';

class CallHistoryPage extends StatefulWidget {
  final UserModel user;
  final String searchInput;

  const CallHistoryPage({
    super.key,
    required this.user,
    required this.searchInput,
  });

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<CallHistoryModel> history = [];
  List<ContactModel> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didUpdateWidget(covariant CallHistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchInput != widget.searchInput) {
      _loadHistory();
    }
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);

    final db = DBHelper.instance;

    // 1. Load all contacts (filtered by search query if provided)
    final contactRows = widget.searchInput.isEmpty
        ? await db.getContactsByUser(widget.user.id!)
        : await db.searchContacts(widget.user.id!, widget.searchInput);

    contacts = contactRows.map((row) => ContactModel.fromMap(row)).toList();

    // 2. Load call history for each contact
    List<CallHistoryModel> tempHistory = [];

    for (var contact in contacts) {
      final rows = await db.getCallHistoryByContact(contact.id!);
      for (var row in rows) {
        tempHistory.add(CallHistoryModel.fromMap({
          "id": row["id"],
          "contact_id": contact.id,
          "call_date": row["call_date"],
        }));
      }
    }

    // 3. Sort by date (newest first)
    tempHistory.sort((a, b) => b.callDate.compareTo(a.callDate));

    setState(() {
      history = tempHistory;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.isEmpty) {
      return const Center(child: Text("No call history"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final call = history[index];

        // Find the contact for this call
        final contact = contacts.firstWhere(
              (c) => c.id == call.contactId,
          orElse: () => ContactModel(name: "Unknown", phoneNumber: "", isFav: false),
        );

        return CallHistoryCard(
          contact: contact,
          callDate: call.callDate,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/theme/app_text_styles.dart';

class CallHistoryCard extends StatelessWidget {
  final ContactModel contact;
  final String callDate;

  const CallHistoryCard({
    super.key,
    required this.contact,
    required this.callDate,
  });

  // function to formate the date to something a person can read
  String formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;

    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    String two(int n) => n < 10 ? "0$n" : "$n";

    return "${months[dt.month - 1]} ${dt.day}, ${dt.year}  •  ${two(dt.hour)}:${two(dt.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundImage: contact.image != null
                  ? MemoryImage(contact.image!)
                  : const AssetImage('assets/images/default_contact.png')
              as ImageProvider,
            ),

            const SizedBox(width: 12),

            // contact information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: AppTextStyles.title),
                  const SizedBox(height: 4),
                  Text(contact.phoneNumber, style: AppTextStyles.subtitle),
                ],
              ),
            ),

            // Date
            Text(
              formatDate(callDate),
              textAlign: TextAlign.end,
              style: AppTextStyles.subtitle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

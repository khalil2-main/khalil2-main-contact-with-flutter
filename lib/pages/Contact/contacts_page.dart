import 'package:flutter/material.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/db/db_helper.dart';
import '../../widgets/contact_card.dart';

class ContactsPage extends StatefulWidget {
  final UserModel user;

  const ContactsPage({super.key, required this.user});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }


  Future<void> loadContacts() async {
    final data = await DBHelper.instance.getContactsByUser(widget.user.id!);

    setState(() {
      contacts = data.map((row) => ContactModel.fromMap(row)).toList();
    });
  }

  // change the the favorite state
  Future<void> toggleFavorite(int index) async {
    final  contact = contacts[index];

    final ContactModel updated = ContactModel(
      id: contact.id,
      userId: contact.userId,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      image: contact.image,
      isFav: !contact.isFav,
    );

    await DBHelper.instance.updateContact(updated.toMap());

    setState(() {
      contacts[index] = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contacts.isEmpty
          ? const Center(child: Text("No contacts found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ContactCard(
            contact: contact

          );
        },
      ),
    );
  }
}

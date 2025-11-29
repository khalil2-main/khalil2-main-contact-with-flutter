import 'package:flutter/material.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/widgets/contact_card.dart';
import 'package:contact/pages/Contact/contacts_services.dart';

class ContactsPage extends StatefulWidget {
  final UserModel user;
  final String searchInput;

  const ContactsPage({super.key, required this.user, required this.searchInput});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContactService cv = ContactService.instance;
  List<ContactModel> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void didUpdateWidget(covariant ContactsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchInput != widget.searchInput) {
      _loadContacts();
    }
  }

  Future<void> _loadContacts() async {
    setState(() => isLoading = true);

    final newContacts = await cv.loadContacts(
      widget.user.id!,
      query: widget.searchInput,
    );

    setState(() {
      contacts = newContacts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty) {
      return const Center(child: Text("No contacts found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: contacts.length,
      itemBuilder: (_, i) => ContactCard(contact: contacts[i]),
    );
  }
}

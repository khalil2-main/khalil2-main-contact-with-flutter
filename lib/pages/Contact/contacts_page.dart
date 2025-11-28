import 'package:flutter/material.dart';
import '../../widgets/contact_card.dart';
import 'package:contact/models/contact_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // creat a moack data for testing
  List<ContactModel> contacts = List.generate(
    10,
        (index) => ContactModel(
      id: index,
      name: "ali bil kahmis",
      phoneNumber: "28457669",
      isFav: index % 2 == 0,
    ),
  );

  void toggleFavorite(int index) {
    setState(() {
      // Create a new ContactModel manually with toggled isFav
      final contact = contacts[index];
      contacts[index] = ContactModel(
        id: contact.id,
        name: contact.name,
        phoneNumber: contact.phoneNumber,
        image: contact.image,
        isFav: !contact.isFav,
      );
    });

    // Optionally update database here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ContactCard(
            contact: contact,
            onFavoriteToggle: () => toggleFavorite(index),
            onEdit: () {
              // Handle edit
            },
            onDelete: () {
              // Handle delete
            },
          );
        },
      ),
    );
  }
}

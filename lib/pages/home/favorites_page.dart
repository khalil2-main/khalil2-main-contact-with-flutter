import 'package:flutter/material.dart';
import '../../widgets/contact_card.dart';
import 'package:contact/models/contact_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample favorite contacts
    final List<ContactModel> favoriteContacts = [
      ContactModel(
        id: 1,
        name: "Ali Bil Kahmis",
        phoneNumber: "28457669",
        isFav: true,
      ),

    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          final contact = favoriteContacts[index];
          return ContactCard(
            contact: contact,
            onFavoriteToggle: () {},
            onEdit: () {},
            onDelete: () {},
          );
        },
      ),
    );
  }
}

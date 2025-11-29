import 'package:flutter/material.dart';
import 'package:contact/db/db_helper.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/widgets/contact_card.dart';

class FavoritesPage extends StatefulWidget {
  final UserModel user;

  const FavoritesPage({super.key, required this.user});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<ContactModel> favoriteContacts = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  /// Load favorites from DB for this user
  Future<void> loadFavorites() async {
    final data = await DBHelper.instance.getContactsByUser(widget.user.id!);

    final contacts = data.map((row) => ContactModel.fromMap(row)).toList();

    setState(() {
      favoriteContacts = contacts.where((c) => c.isFav).toList();
    });
  }

  ///control the favorite state
  Future<void> toggleFavorite(ContactModel contact) async {
    final updated = ContactModel(
      id: contact.id,
      userId: contact.userId,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      image: contact.image,
      isFav: !contact.isFav,
    );

    await DBHelper.instance.updateContact(updated.toMap());
    // refresh page
    await loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteContacts.isEmpty
          ? const Center(
        child: Text(
          "No favorite contacts yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          final contact = favoriteContacts[index];

          return ContactCard(
            contact: contact,

          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/widgets/contact_card.dart';
import 'package:contact/services/contacts_services.dart';

class FavoritesPage extends StatefulWidget {
  final UserModel user;
  final String searchInput;

  const FavoritesPage({
    super.key,
    required this.user,
    required this.searchInput,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late ContactService cv;
  List<ContactModel> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cv = ContactService.instance;
    _loadFavorites();
  }

  @override
  void didUpdateWidget(covariant FavoritesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchInput != widget.searchInput) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);

    final newFavorites = await cv.loadFavorites(
      widget.user.id!,
      query: widget.searchInput,
    );

    setState(() {
      favorites = newFavorites;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favorites.isEmpty) {
      return const Center(child: Text("No favorites"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (_, i) => ContactCard(contact: favorites[i]),
    );
  }
}

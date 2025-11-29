import 'package:contact/db/db_helper.dart';

import 'package:contact/models/contact_model.dart';

class ContactService {
  static final ContactService instance = ContactService._();

  ContactService._();

  final db = DBHelper.instance;

  /// Load contacts from DB (optionally filtered by search query)
  Future<List<ContactModel>> loadContacts(int userId,
      {String query = "",}) async {
    final rows = query.isEmpty
        ? await db.getContactsByUser(userId)
        : await db.searchContacts(userId, query);

    return rows.map(ContactModel.fromMap).toList();
  }

  Future <ContactModel> getContact(int id) async {
    final rows = await db.getContactsById(id);
    return ContactModel.fromMap(rows.first);
  }

  /// Load favorites (using filtered contacts if query provided)
  Future<List<ContactModel>> loadFavorites(int userId, {
    String query = "",
  }) async {
    final list = await loadContacts(userId, query: query);
    return list.where((c) => c.isFav).toList();
  }

}

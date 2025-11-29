import 'package:contact/db/db_helper.dart';
import 'package:contact/pages/actions/call_page.dart';
import 'package:flutter/material.dart';
import 'package:contact/theme/app_colors.dart';
import 'package:contact/theme/app_text_styles.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/pages/Contact/Update_contact_page.dart'; // import your ModifyContactPage

class ContactCard extends StatefulWidget {
  final ContactModel contact;
  final VoidCallback? onRefresh; // parent callback to reload contacts

  const ContactCard({
    super.key,
    required this.contact,
    this.onRefresh,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  late bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = widget.contact.isFav;
  }

  Future<void> toggleFavorite() async {
    setState(() {
      favorite = !favorite;
    });

    final updated = ContactModel(
      id: widget.contact.id,
      userId: widget.contact.userId,
      name: widget.contact.name,
      phoneNumber: widget.contact.phoneNumber,
      image: widget.contact.image,
      isFav: favorite,
    );

    await DBHelper.instance.updateContact(updated.toMap());
    widget.onRefresh?.call();
  }

  Future<void> deleteContact() async {
    if (widget.contact.id != null) {
      await DBHelper.instance.deleteContact(widget.contact.id!);
      widget.onRefresh?.call();
    }
  }

  Future<void> editContact() async {
    if (widget.contact.id != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ModifyContactPage(contact: widget.contact),
        ),
      );
      if (result == true) {
        widget.onRefresh?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.call),
                  title: const Text("Call"),
                  onTap: () async {
                    await DBHelper.instance.insertCallHistory(widget.contact.id!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CallPage(
                          name: widget.contact.name,
                          phoneNumber: widget.contact.phoneNumber,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text("Message"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: widget.contact.image != null
                ? MemoryImage(widget.contact.image!)
                : const AssetImage('assets/images/default_contact.png') as ImageProvider,
          ),
          title: Text(widget.contact.name, style: AppTextStyles.title),
          subtitle: Text(widget.contact.phoneNumber, style: AppTextStyles.subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: toggleFavorite,
                child: Icon(
                  Icons.star,
                  color: favorite ? AppColors.gold : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "edit", child: Text("Edit")),
                  PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
                onSelected: (value) async {
                  if (value == "edit") {
                    await editContact();
                  } else if (value == "delete") {
                    await deleteContact();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


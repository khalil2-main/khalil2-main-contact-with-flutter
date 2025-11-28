import 'package:contact/db/db_helper.dart';
import 'package:contact/pages/actions/call_page.dart';
import 'package:flutter/material.dart';
import 'package:contact/theme/app_colors.dart';
import 'package:contact/theme/app_text_styles.dart';
import 'package:contact/models/contact_model.dart';

class ContactCard extends StatefulWidget {
  final ContactModel contact;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onFavoriteToggle;

  const ContactCard({
    super.key,
    required this.contact,
    this.onEdit,
    this.onDelete,
    this.onFavoriteToggle,
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
  // change the favorite state of the contact
  void toggleFavorite() {
    setState(() {
      favorite = !favorite;
    });


    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
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
                    // create a  callhistory
                    await DBHelper.instance.insertCallHistory(widget.contact.id!,);

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
                : const AssetImage('assets/images/default_contact.png')
            as ImageProvider,
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
                onSelected: (value) {
                  if (value == "edit" && widget.onEdit != null) widget.onEdit!();
                  if (value == "delete" && widget.onDelete != null) widget.onDelete!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

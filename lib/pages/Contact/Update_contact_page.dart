import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact/db/db_helper.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/theme/app_colors.dart';
import 'package:contact/theme/app_text_styles.dart';

class ModifyContactPage extends StatefulWidget {
  final ContactModel contact;

  const ModifyContactPage({super.key, required this.contact});

  @override
  State<ModifyContactPage> createState() => _ModifyContactPageState();
}

class _ModifyContactPageState extends State<ModifyContactPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    phoneController = TextEditingController(text: widget.contact.phoneNumber);
    imageBytes = widget.contact.image; // load existing image
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  Future<void> saveChange() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name")),
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    final updatedContact = ContactModel(
      id: widget.contact.id,
      userId: widget.contact.userId,
      name: nameController.text,
      phoneNumber: phoneController.text,
      image: imageBytes,
      isFav: widget.contact.isFav,
    );

    await DBHelper.instance.updateContact(updatedContact.toMap());

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Contact"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imageBytes != null ? MemoryImage(imageBytes!) : null,
                child: imageBytes == null
                    ? Icon(Icons.camera_alt, size: 40, color: AppColors.textLight)
                    : null,
              ),
            ),

            const SizedBox(height: 30),

            // Name Field
            TextField(
              controller: nameController,
              style: AppTextStyles.title,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: AppTextStyles.subtitle,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Phone Number Field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.subtitle,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: AppTextStyles.subtitle,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            ElevatedButton.icon(
              onPressed: saveChange,
              icon: const Icon(Icons.save),
              label: const Text("Save changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                textStyle: AppTextStyles.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

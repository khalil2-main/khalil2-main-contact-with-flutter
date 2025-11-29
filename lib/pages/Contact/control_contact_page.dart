import 'dart:typed_data';
import 'package:contact/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact/db/db_helper.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';
import 'package:contact/theme/app_colors.dart';
import 'package:contact/theme/app_text_styles.dart';

class AddContactPage extends StatefulWidget {
  final String phoneNumber;
  final UserModel user;

  const AddContactPage({super.key, required this.phoneNumber, required this.user});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController;

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.phoneNumber);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  Future<void> saveContact() async {
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

    final contact = ContactModel(
      name: nameController.text,
      userId: widget.user.id,
      phoneNumber: phoneController.text,
      image: imageBytes,
      isFav: false,
    );

    await DBHelper.instance.insertContact(contact.toMap());


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Contact"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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

            ElevatedButton.icon(
              onPressed: saveContact,
              icon: const Icon(Icons.save),
              label: const Text("Save Contact"),
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

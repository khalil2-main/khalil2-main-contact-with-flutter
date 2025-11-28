import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact/db/db_helper.dart';
import 'package:contact/models/contact_model.dart';
import 'package:contact/models/user_model.dart';

class AddContactPage extends StatefulWidget {
  final String phoneNumber;
  final UserModel user;

  const AddContactPage({super.key, required this.phoneNumber, required this.user});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController newName = TextEditingController();
  late TextEditingController phoneController;

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    // initialize phone controller with the passed number
    phoneController = TextEditingController(text: widget.phoneNumber);
  }

  // pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  // save the new contact in the database
  Future<void> saveContact() async {
    if (newName.text.isEmpty) {
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

    ContactModel contact = ContactModel(
      name: newName.text,
      userId: widget.user.id,
      phoneNumber: phoneController.text,
      image: imageBytes,
      isFav: false,
    );

    await DBHelper.instance.insertContact(contact.toMap());

    // Navigate back to HomePage
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Contact")),
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
                backgroundImage:
                imageBytes != null ? MemoryImage(imageBytes!) : null,
                child: imageBytes == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 30),

            // Name Field
            TextField(
              controller: newName,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Editable Phone Number
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            ElevatedButton.icon(
              onPressed: saveContact,
              icon: const Icon(Icons.save),
              label: const Text("Save Contact"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

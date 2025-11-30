import 'package:contact/models/user_model.dart';
import 'package:contact/pages/actions/call_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact/pages/Contact/control_contact_page.dart';
import 'package:contact/services/auth_service.dart';



class KeypadPage extends StatefulWidget {
  const KeypadPage({super.key});

  @override
  State<KeypadPage> createState() => _KeypadPageState();
}

class _KeypadPageState extends State<KeypadPage> {
  String phoneNumber = "";

  void addDigit(String digit) {
    setState(() {
      phoneNumber += digit;
    });
  }

  void deleteDigit() {
    setState(() {
      if (phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = context.watch<AuthService>().user as UserModel;

    // keypad labels
    List<String> keys = [
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
      "*", "0", "#",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keypad"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //adding a contact function
              builder: (context) => AddContactPage(
                phoneNumber: phoneNumber,
                user: user,
              ),
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),

      body: Column(
        children: [
          const SizedBox(height: 30),
          const Spacer(),

          // Phone number display
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: deleteDigit,
                  iconSize: 30,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Keypad buttons
          GridView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () => addDigit(keys[index]),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                child: Text(
                  keys[index],
                  style: const TextStyle(fontSize: 22),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Call button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(
                  builder: (_)=> CallPage(phoneNumber: phoneNumber),
              ),
              );
            },

            icon: const Icon(Icons.call),
            label: const Text("Call"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

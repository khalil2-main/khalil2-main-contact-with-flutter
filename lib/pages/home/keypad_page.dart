import 'package:flutter/material.dart';
import 'package:contact/pages/Contact/control_contact_page.dart';

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
              builder: (context) => AddContactPage(
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          // Keypad Grid
          GridView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  addDigit(keys[index]);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(50, 50),
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

          ElevatedButton.icon(
            onPressed: () {
              print("Calling $phoneNumber");
            },
            icon: const Icon(Icons.call),
            label: const Text("Call"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}

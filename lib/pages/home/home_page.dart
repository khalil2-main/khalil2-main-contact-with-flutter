import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact/services/auth_service.dart';
import 'package:contact/pages/auth/login_page.dart';

import 'package:contact/pages/Contact/contacts_page.dart';
import 'package:contact/pages/Contact/favorites_page.dart';
import 'package:contact/pages/Contact/call_history_page.dart';

import 'keypad_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  //navigation routes
  final List<Widget> _pages = const [
    ContactsPage(),
    FavoritesPage(),
    CallHistoryPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  //logout function call
  Future<void> _logout(BuildContext context) async {
    final authService = context.read<AuthService>();
    await authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // search bar (still not functional)
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),

        actions: [
          //use poppup menu to logout
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "logout") {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KeypadPage()),
          );
        },
        child: const Icon(Icons.dialpad),
      ),
      //navigation buttons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth.dart';  // Pastikan ini ada untuk autentikasi
// import 'package:todo_list/extensions/space_exs.dart';
//import 'package:todo_list/views/home/home_view.dart';
import 'package:todo_list/login_register_page.dart';  // Pastikan ini ada
import 'package:todo_list/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  //Icons
  final List<IconData> icons = [
    // CupertinoIcons.home,
    // CupertinoIcons.person_fill,
    // CupertinoIcons.settings,
    Icons.logout,
  ];

  //Text
  final List<String> texts = [
    // "Home",
    // "Profile",
    // "Settings",
    "Logout",
  ];

  Future<void> _signOut(BuildContext context) async {
    try {
      await Auth().signOut();
      // Ganti halaman ke login setelah signOut berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      log('Error signing out: $e');
      // Tampilkan pesan error jika sign out gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    // var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // const CircleAvatar(
          //   radius: 50,
          //   backgroundImage: NetworkImage(
          //     "https://avatar.githubusercontent.com/u/91388754?v=4",
          //   ),
          // ),
          // 8.h,
          // Text("Hermione", style: textTheme.displayMedium),
          // Text("Kementrian Ilmu Sihir", style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (buildContext, int index) {
                return InkWell(
                  onTap: () {
                    if (texts[index] == "Logout") {
                      _signOut(context); // Sign out and navigate to LoginPage
                    } else {
                      log('${texts[index]} + Item Tapped!');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(
                        icons[index],
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        texts[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

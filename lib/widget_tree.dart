import 'package:flutter/material.dart';
import 'package:todo_list/auth.dart'; // Pastikan Auth() ada untuk autentikasi
import 'package:todo_list/login_register_page.dart';
import 'package:todo_list/views/home/home_view.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, // Memeriksa status login
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomeView();  // Jika sudah login, tampilkan HomeView (todo app)
        } else {
          return const LoginPage();  // Jika belum login, tampilkan LoginPage
        }
      },
    );
  }
}

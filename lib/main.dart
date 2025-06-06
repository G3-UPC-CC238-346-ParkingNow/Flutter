import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/welcome_page.dart';

void main() {
  runApp(const ParkingNowOwnerApp());
}

class ParkingNowOwnerApp extends StatelessWidget {
  const ParkingNowOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkingNow Dueño',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const WelcomePage(), // 👈 solo esto, sin rutas
    );
  }
}
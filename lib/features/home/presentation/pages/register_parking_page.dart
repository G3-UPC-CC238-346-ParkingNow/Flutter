import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/section_title.dart';

class RegisterParkingPage extends StatelessWidget {
  const RegisterParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Registro de local',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF6FAFE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/owner_icon.png"),
            ),
            const SizedBox(height: 32),
            const SectionTitle(text: 'Registros de locales'),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'Locales registrados y sus calificaciones',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Acción futura
                },
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(text: 'Estadísticas'),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'Control de su estacionamiento',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Acción futura
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
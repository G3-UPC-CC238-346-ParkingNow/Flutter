
import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Configuraciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textTitle,
                ),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 15),
              CustomButton(
                text: 'Privacidad y políticas',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Idioma',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Quejas o reclamos',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Reportar Robo',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Eliminar cuenta',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
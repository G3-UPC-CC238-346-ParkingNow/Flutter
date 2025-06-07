import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/section_title.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF6F9FCFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Seguridad',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 32),
              const SectionTitle(text: 'Automóviles registrados en los locales'),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Ver automóviles',
                onPressed: () {
                  // TODO: Agrega la lógica de navegación o acción aquí
                },
              ),
              const SizedBox(height: 32),
              const SectionTitle(text: 'Últimas alertas registradas'),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Ver alertas',
                onPressed: () {
                  // TODO: Agrega la lógica de navegación o acción aquí
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
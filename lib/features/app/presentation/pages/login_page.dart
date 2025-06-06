import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/ui/custom_text_field.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black12 : Colors.white;
    final accentColor = Colors.blue;
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final secondaryTextColor = isDark ? Colors.grey[300]! : Colors.grey[700]!;

    return Scaffold(
      body: Stack(
        children: [
          // if (!isDark)
          //   Positioned.fill(
          //     child: Image.asset(
          //       AppImages.loginBackground,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          if (!isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    const SizedBox(height: 80),
                    Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [accentColor, const Color(0xFF1976D2)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.local_parking, color: Colors.white, size: 48),
                        ),
                        const SizedBox(height: 20),
                        Text('ParkingNow', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accentColor)),
                        Text(
                          'Administra fácilmente tu estacionamiento',
                          style: TextStyle(fontSize: 16, color: secondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Card(
                      color: cardColor,
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.person, color: accentColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '¡Bienvenido, dueño!',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Accede a tu panel de control',
                                        style: TextStyle(color: secondaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              controller: TextEditingController(),
                              labelText: 'Correo electrónico',
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: TextEditingController(),
                              labelText: 'Contraseña',
                              prefixIcon: Icons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                                icon: const Icon(Icons.help, size: 16),
                                label: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: accentColor)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Iniciar Sesión',
                              icon: Icons.login,
                              onPressed: () => Navigator.pushNamed(context, '/'),
                            ),
                            const SizedBox(height: 24),
                            Row(children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text('O', style: TextStyle(color: secondaryTextColor)),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ]),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Crear una cuenta',
                              icon: Icons.person_add,
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.registerOwner),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/'),
                          icon: const Icon(Icons.visibility_off, size: 16),
                          label: Text('Modo invitado', style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.help, size: 16),
                          label: Text('Ayuda', style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2025 ParkingNow. Todos los derechos reservados.',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
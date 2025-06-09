import 'package:flutter/material.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';
import 'package:parkingnow_owner/core/ui/custom_text_field.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _showConfirmation = false;
  bool _showWarning = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _handleSubmit() {
    final email = _emailController.text;
    if (_isValidEmail(email)) {
      setState(() {
        _showConfirmation = true;
        _showWarning = false;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => _showConfirmation = false);
        Navigator.pushNamed(context, AppRoutes.changePassword);
      });
    } else {
      setState(() {
        _showWarning = true;
        _showConfirmation = false;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => _showWarning = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true, // ✅ importante para teclado
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            if (_showConfirmation)
                              Align(
                                alignment: Alignment.topRight,
                                child: _buildMessageBar(
                                  context,
                                  message: '¡Correo enviado!',
                                  color: Colors.green,
                                  icon: Icons.check_circle,
                                ),
                              ),
                            if (_showWarning)
                              Align(
                                alignment: Alignment.topRight,
                                child: _buildMessageBar(
                                  context,
                                  message: 'Correo inválido',
                                  color: Colors.redAccent,
                                  icon: Icons.error,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [AppColors.primary, Color(0xFF1976D2)],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(Icons.lock_reset, color: Colors.white, size: 40),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Ingresa tu correo y te enviaremos un enlace para restablecerla',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: _emailController,
                                  labelText: 'Correo electrónico',
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(height: 32),
                                CustomButton(
                                  text: 'Enviar enlace de recuperación',
                                  onPressed: _handleSubmit,
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, AppRoutes.login),
                                  child: Text(
                                    'Volver al inicio de sesión',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            '¿Necesitas ayuda? Contacta a nuestro soporte',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Eliminado el Spacer final para evitar overflow con el teclado
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBar(BuildContext context,
      {required String message,
        required Color color,
        required IconData icon}) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
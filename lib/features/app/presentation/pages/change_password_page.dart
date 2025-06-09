import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/ui/custom_text_field.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChangePasswordContent();
  }
}

class _ChangePasswordContent extends StatefulWidget {
  const _ChangePasswordContent({Key? key}) : super(key: key);

  @override
  State<_ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<_ChangePasswordContent> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool _showSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    // Password requirements
    final bool isLengthValid = newPasswordController.text.length >= 8;
    final bool hasUppercase = newPasswordController.text.contains(RegExp(r'[A-Z]'));
    final bool hasNumber = newPasswordController.text.contains(RegExp(r'[0-9]'));
    final bool hasSymbol = newPasswordController.text.contains(RegExp(r'[!@#\$%^&*]'));
    final bool passwordsMatch = newPasswordController.text == confirmPasswordController.text && newPasswordController.text.isNotEmpty;
    final bool isPasswordValid = isLengthValid && hasUppercase && hasNumber && hasSymbol && passwordsMatch;

    // Activar mensaje y redirigir si es válido y aún no mostrado
    if (isPasswordValid && !_showSuccessMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showSuccessMessage = true;
        });
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
      });
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: colorScheme.primary, size: 28),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          if (_showSuccessMessage)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check, size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Contraseña Actualizada",
                                    style: textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: colorScheme.outline),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black26 : Colors.black12,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                // Optionally add a border for dark mode
                                border: isDark ? Border.all(color: Colors.white10, width: 1) : null,
                              ),
                              child: const Icon(Icons.lock_reset, color: Colors.white, size: 40),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Cambiar Contraseña",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textTheme.titleLarge?.color,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Crea una nueva contraseña segura para proteger tu cuenta",
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                color: textTheme.bodySmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              controller: newPasswordController,
                              labelText: 'Nueva contraseña',
                              prefixIcon: Icons.lock,
                              obscureText: !showPassword,
                              suffixIcon: IconButton(
                                icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
                                onPressed: () {
                                  setState(() => showPassword = !showPassword);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: confirmPasswordController,
                              labelText: 'Confirmar contraseña',
                              prefixIcon: Icons.lock_outline,
                              obscureText: !showConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(showConfirmPassword ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
                                onPressed: () {
                                  setState(() => showConfirmPassword = !showConfirmPassword);
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                border: Border.all(
                                  color: isDark
                                      ? colorScheme.outline.withOpacity(0.4)
                                      : colorScheme.outline.withOpacity(0.7),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Requisitos de contraseña:",
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildPasswordRequirement(
                                    "Al menos 8 caracteres",
                                    isLengthValid,
                                  ),
                                  _buildPasswordRequirement(
                                    "Al menos una letra mayúscula (A-Z)",
                                    hasUppercase,
                                  ),
                                  _buildPasswordRequirement(
                                    "Al menos un número (0-9)",
                                    hasNumber,
                                  ),
                                  _buildPasswordRequirement(
                                    "Al menos un símbolo (!@#\$%^&*)",
                                    hasSymbol,
                                  ),
                                  _buildPasswordRequirement(
                                    "Las contraseñas coinciden",
                                    passwordsMatch,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // ElevatedButton removed
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "¿Necesitas ayuda? Contacta a nuestro soporte",
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: textTheme.bodySmall?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Mensaje de éxito eliminado, ahora incluido en el Row superior junto al botón de retroceso.
      ],
    );
  }
  // Widget para mostrar cada requisito de contraseña
  Widget _buildPasswordRequirement(String text, bool met) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: met ? const Color(0xFF4CAF50) : theme.disabledColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: met ? const Color(0xFF4CAF50) : theme.disabledColor,
          ),
        ),
      ],
    );
  }
}
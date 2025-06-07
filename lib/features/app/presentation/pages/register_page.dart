import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/core/ui/custom_text_field.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardOwner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Removed background image as per optional instruction
          Container(
            color: Colors.white.withOpacity(0.85),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const SizedBox(height: 20),
                    const Text(
                      'Crea tu cuenta',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    // Card decorativo actualizado para dueños de estacionamiento
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: const Color(0xFFE8F0FE),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(Icons.store, color: AppColors.primary),
                        ),
                        title: const Text('¡Registra tu Estacionamiento!', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Comparte tu espacio con miles de conductores y gana dinero fácilmente'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Información Personal
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Información Personal", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'Nombre completo',
                              prefixIcon: Icons.person,
                              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Correo electrónico',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Seguridad
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Seguridad", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              labelText: 'Contraseña',
                              obscureText: !_passwordVisible,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() => _passwordVisible = !_passwordVisible);
                                },
                              ),
                              validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirmar contraseña',
                              obscureText: !_confirmPasswordVisible,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(_confirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                                },
                              ),
                              validator: (value) => value != _passwordController.text ? 'No coinciden' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Información del Establecimiento", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: TextEditingController(),
                              labelText: 'RUC',
                              prefixIcon: Icons.business,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: TextEditingController(),
                              labelText: 'Registro del local',
                              prefixIcon: Icons.store_mall_directory,
                              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: TextEditingController(),
                              labelText: 'Dirección del estacionamiento',
                              prefixIcon: Icons.location_on,
                              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Crear Cuenta',
                      onPressed: _register,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          '¿Ya tienes una cuenta? Inicia sesión',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
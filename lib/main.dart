import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/welcome_page.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/login_page.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/forgot_password_page.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/change_password_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/register_parking_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Aplicar estilo global al sistema (barra de estado transparente)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // fondo de barra de estado
      statusBarIconBrightness: Brightness.dark, // íconos oscuros para fondo claro
    ),
  );

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
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomePage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.changePassword: (_) => const ChangePasswordPage(),
        AppRoutes.registerOwner: (context) => const RegisterParkingPage(),
      },
    );
  }
}
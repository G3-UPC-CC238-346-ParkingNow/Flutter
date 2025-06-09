import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/core/theme/app_theme.dart';
import 'package:parkingnow_owner/core/theme/theme_mode_notifier.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/welcome_page.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/login_page.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/forgot_password_page.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/change_password_page.dart';
import 'package:parkingnow_owner/features/app/presentation/pages/register_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/dashboard_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/reservations_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/register_parking_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/notifications_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/security_page.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/settings_page.dart';

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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ParkingNow Dueño',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: AppRoutes.welcome,
          themeMode: currentMode,
          routes: {
            AppRoutes.welcome: (_) => const WelcomePage(),
            AppRoutes.login: (_) => const LoginPage(),
            AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
            AppRoutes.changePassword: (_) => const ChangePasswordPage(),
            AppRoutes.registerOwner: (context) => const RegisterPage(),
            AppRoutes.dashboardOwner: (_) => const DashboardPage(),
            AppRoutes.reservations: (_) => const ReservationsPage(),
            AppRoutes.registerParking: (_) => const RegisterParkingPage(),
            AppRoutes.notifications: (_) => const NotificationsPage(),
            AppRoutes.security: (_) => const SecurityPage(),
            AppRoutes.settings: (_) => const SettingsPage(),
          },
        );
      },
    );
  }
}
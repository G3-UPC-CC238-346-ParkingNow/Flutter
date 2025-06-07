import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';

class DashboardMenuDrawer extends StatelessWidget {
  const DashboardMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/welcome.png'),
                ),
                SizedBox(height: 8),
                Text('John Smith', style: TextStyle(color: Colors.white)),
                Text('Lima, Perú', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Registro de locales'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.registerParking);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Reservas'),
            onTap: () {
              Navigator.pushNamed(context, '/reservations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Seguridad'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.security);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
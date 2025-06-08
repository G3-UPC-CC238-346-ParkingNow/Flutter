import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';

class DashboardMenuDrawer extends StatefulWidget {
  const DashboardMenuDrawer({super.key});

  @override
  State<DashboardMenuDrawer> createState() => _DashboardMenuDrawerState();
}

class _DashboardMenuDrawerState extends State<DashboardMenuDrawer>
    with TickerProviderStateMixin {
  String _currentRoute = '/dashboard';
  int _notificationCount = 3;
  int _reservationCount = 5;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Color azul más suave
  static const Color primaryBlue = Color(0xFF3B82F6); // Azul más suave
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color darkBlue = Color(0xFF1E40AF);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context)?.settings.name ?? '/dashboard';
      setState(() {
        _currentRoute = route;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header mejorado y simplificado
            _buildEnhancedHeader(isDark),

            // Menú principal simplificado
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Solo las 6 opciones principales
                  _buildMainMenuItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Inicio',
                    route: '/dashboard',
                    isDark: isDark,
                    onTap: () => _navigateTo(context, '/dashboard'),
                  ),

                  _buildMainMenuItem(
                    icon: Icons.store_mall_directory_rounded,
                    title: 'Registros de Locales',
                    route: AppRoutes.registerParking,
                    isDark: isDark,
                    onTap: () => _navigateTo(context, AppRoutes.registerParking),
                    badge: '3',
                    badgeColor: Colors.green,
                  ),

                  _buildMainMenuItem(
                    icon: Icons.event_note_rounded,
                    title: 'Reservas',
                    route: '/reservations',
                    isDark: isDark,
                    onTap: () => _navigateTo(context, '/reservations'),
                    badge: '$_reservationCount',
                    badgeColor: primaryBlue,
                  ),

                  _buildMainMenuItem(
                    icon: Icons.security_rounded,
                    title: 'Seguridad',
                    route: AppRoutes.security,
                    isDark: isDark,
                    onTap: () => _navigateTo(context, AppRoutes.security),
                  ),

                  _buildMainMenuItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notificaciones',
                    route: AppRoutes.notifications,
                    isDark: isDark,
                    onTap: () => _navigateTo(context, AppRoutes.notifications),
                    badge: '$_notificationCount',
                    badgeColor: Colors.red,
                  ),

                  _buildMainMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Configuración',
                    route: AppRoutes.settings,
                    isDark: isDark,
                    onTap: () => _navigateTo(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),

            // Botón de logout
            _buildLogoutSection(context, isDark),

            // Versión de la app
            _buildAppVersion(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(bool isDark) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            lightBlue,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y información del usuario
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Juan Pérez',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Propietario',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMainMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isDark,
    required VoidCallback onTap,
    String? badge,
    Color? badgeColor,
  }) {
    final isActive = _currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? primaryBlue.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: primaryBlue.withOpacity(0.3), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? primaryBlue.withOpacity(0.2)
                : (isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isActive
                ? primaryBlue
                : (isDark ? Colors.white70 : Colors.grey[700]),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive
                ? primaryBlue
                : (isDark ? Colors.white : Colors.black87),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: badge != null ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor ?? primaryBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Divider(
            color: isDark ? Colors.white24 : Colors.grey[300],
            thickness: 1,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_parking,
                  color: primaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'ParkingNow v1.0.0',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Todos los derechos reservados',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    if (_currentRoute != route) {
      setState(() {
        _currentRoute = route;
      });
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    } else {
      Navigator.pop(context);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión? Tendrás que volver a iniciar sesión para acceder a tu cuenta.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
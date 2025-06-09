import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/features/home/presentation/pages/settings_page.dart';

// Modelo de datos para vehículos
class Vehicle {
  final String id;
  final String licensePlate;
  final String brand;
  final String model;
  final String color;
  final String ownerName;
  final DateTime registrationDate;
  final bool isActive;

  Vehicle({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.color,
    required this.ownerName,
    required this.registrationDate,
    this.isActive = true,
  });
}

// Modelo de datos para alertas
class SecurityAlert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertType type;
  final AlertSeverity severity;

  SecurityAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.severity,
  });
}

enum AlertType { unauthorized, suspicious, system, access }
enum AlertSeverity { low, medium, high, critical }

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Datos de ejemplo
  List<Vehicle> vehicles = [
    Vehicle(
      id: '1',
      licensePlate: 'ABC-123',
      brand: 'Toyota',
      model: 'Corolla',
      color: 'Blanco',
      ownerName: 'Juan Pérez',
      registrationDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Vehicle(
      id: '2',
      licensePlate: 'XYZ-789',
      brand: 'Honda',
      model: 'Civic',
      color: 'Negro',
      ownerName: 'María García',
      registrationDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Vehicle(
      id: '3',
      licensePlate: 'DEF-456',
      brand: 'Nissan',
      model: 'Sentra',
      color: 'Azul',
      ownerName: 'Carlos López',
      registrationDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  List<SecurityAlert> alerts = [
    SecurityAlert(
      id: '1',
      title: 'Acceso autorizado',
      description: 'Vehículo ABC-123 ingresó al estacionamiento',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: AlertType.access,
      severity: AlertSeverity.low,
    ),
    SecurityAlert(
      id: '2',
      title: 'Actividad sospechosa',
      description: 'Vehículo no registrado detectado en zona A',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: AlertType.suspicious,
      severity: AlertSeverity.medium,
    ),
    SecurityAlert(
      id: '3',
      title: 'Intento de acceso no autorizado',
      description: 'Tarjeta de acceso inválida utilizada',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: AlertType.unauthorized,
      severity: AlertSeverity.high,
    ),
    SecurityAlert(
      id: '4',
      title: 'Sistema actualizado',
      description: 'Actualización de seguridad completada exitosamente',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: AlertType.system,
      severity: AlertSeverity.low,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F172A)
            : Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF334155),
                size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Centro de Seguridad',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF334155)),
              onPressed: () => _showNotifications(context),
            ),
          ),
        ],
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section con diseño mejorado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B82F6),
                      const Color(0xFF1D4ED8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sistema de Seguridad',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monitoreo activo • ${vehicles.length} vehículos registrados',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.directions_car,
                      title: '${vehicles.length}',
                      subtitle: 'Vehículos\nRegistrados',
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.warning_amber_rounded,
                      title: '${alerts.where((a) => a.severity == AlertSeverity.high || a.severity == AlertSeverity.critical).length}',
                      subtitle: 'Alertas\nImportantes',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.access_time,
                      title: '24/7',
                      subtitle: 'Monitoreo\nActivo',
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.security,
                      title: '99.9%',
                      subtitle: 'Tiempo\nOperativo',
                      color: const Color(0xFF06B6D4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Acciones Rápidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _buildQuickActionCard(
                        icon: Icons.add_circle_outline,
                        title: 'Registrar',
                        subtitle: 'Nuevo vehículo',
                        color: const Color(0xFF3B82F6),
                        onTap: () => _navigateToRegisterVehicle(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _buildQuickActionCard(
                        icon: Icons.history,
                        title: 'Historial',
                        subtitle: 'Ver actividad',
                        color: const Color(0xFF10B981),
                        onTap: () => _navigateToHistory(context),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),

              ...alerts.take(3).map((alert) => _buildRecentActivityCard(alert)),

              const SizedBox(height: 16),

              // Ver más actividad
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(bottom: 24),
                child: OutlinedButton(
                  onPressed: () => _navigateToHistory(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3B82F6),
                    side: const BorderSide(color: Color(0xFF3B82F6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ver toda la actividad',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A202C)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A202C)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(SecurityAlert alert) {
    Color getAlertColor() {
      switch (alert.severity) {
        case AlertSeverity.critical:
          return const Color(0xFFEF4444);
        case AlertSeverity.high:
          return const Color(0xFFF59E0B);
        case AlertSeverity.medium:
          return const Color(0xFF3B82F6);
        case AlertSeverity.low:
          return const Color(0xFF10B981);
      }
    }

    IconData getAlertIcon() {
      switch (alert.type) {
        case AlertType.unauthorized:
          return Icons.block;
        case AlertType.suspicious:
          return Icons.warning;
        case AlertType.system:
          return Icons.settings;
        case AlertType.access:
          return Icons.check_circle;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A202C)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: getAlertColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              getAlertIcon(),
              color: getAlertColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(alert.timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(alerts: alerts, vehicles: vehicles),
      ),
    );
  }

  void _navigateToRegisterVehicle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterVehiclePage(
          onVehicleRegistered: (vehicle) {
            setState(() {
              vehicles.add(vehicle);
            });
          },
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationsBottomSheet(alerts: alerts),
    );
  }
}

// Página de Historial
class HistoryPage extends StatelessWidget {
  final List<SecurityAlert> alerts;
  final List<Vehicle> vehicles;

  const HistoryPage({
    super.key,
    required this.alerts,
    required this.vehicles,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark
              ? const Color(0xFF0F172A)
              : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : const Color(0xFF334155)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Historial de Actividad',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            labelColor: const Color(0xFF3B82F6),
            unselectedLabelColor: isDark ? Colors.white54 : const Color(0xFF64748B),
            indicatorColor: const Color(0xFF3B82F6),
            tabs: const [
              Tab(text: 'Alertas'),
              Tab(text: 'Vehículos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAlertsTab(context, isDark: isDark),
            _buildVehiclesTab(context, isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsTab(BuildContext context, {required bool isDark}) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildDetailedAlertCard(alert, isDark: isDark);
      },
    );
  }

  Widget _buildVehiclesTab(BuildContext context, {required bool isDark}) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return _buildVehicleCard(vehicle, isDark: isDark);
      },
    );
  }

  Widget _buildDetailedAlertCard(SecurityAlert alert, {required bool isDark}) {
    Color getAlertColor() {
      switch (alert.severity) {
        case AlertSeverity.critical:
          return const Color(0xFFEF4444);
        case AlertSeverity.high:
          return const Color(0xFFF59E0B);
        case AlertSeverity.medium:
          return const Color(0xFF3B82F6);
        case AlertSeverity.low:
          return const Color(0xFF10B981);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A202C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getAlertColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.severity.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: getAlertColor(),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${alert.timestamp.day}/${alert.timestamp.month}/${alert.timestamp.year} ${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alert.description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle, {required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A202C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: const Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.licensePlate,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: vehicle.isActive
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vehicle.isActive ? 'ACTIVO' : 'INACTIVO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: vehicle.isActive
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildVehicleDetail('Propietario', vehicle.ownerName, isDark: isDark)),
              const SizedBox(width: 24),
              Expanded(child: _buildVehicleDetail('Color', vehicle.color, isDark: isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _buildVehicleDetail(
            'Registrado',
            '${vehicle.registrationDate.day}/${vehicle.registrationDate.month}/${vehicle.registrationDate.year}',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetail(String label, String value, {required bool isDark}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Página de Registro de Vehículo
class RegisterVehiclePage extends StatefulWidget {
  final Function(Vehicle) onVehicleRegistered;

  const RegisterVehiclePage({
    super.key,
    required this.onVehicleRegistered,
  });

  @override
  State<RegisterVehiclePage> createState() => _RegisterVehiclePageState();
}

class _RegisterVehiclePageState extends State<RegisterVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _ownerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF334155)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registrar Vehículo',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B82F6),
                      const Color(0xFF1D4ED8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nuevo Vehículo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa la información del vehículo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _buildFormField(
                controller: _licensePlateController,
                label: 'Placa del Vehículo',
                hint: 'Ej: ABC-123',
                icon: Icons.confirmation_number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la placa';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _brandController,
                      label: 'Marca',
                      hint: 'Ej: Toyota',
                      icon: Icons.branding_watermark,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la marca';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFormField(
                      controller: _modelController,
                      label: 'Modelo',
                      hint: 'Ej: Corolla',
                      icon: Icons.model_training,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el modelo';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildFormField(
                controller: _colorController,
                label: 'Color',
                hint: 'Ej: Blanco',
                icon: Icons.palette,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el color';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFormField(
                controller: _ownerNameController,
                label: 'Nombre del Propietario',
                hint: 'Ej: Juan Pérez',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del propietario';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _registerVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Registrar Vehículo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _registerVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        licensePlate: _licensePlateController.text.toUpperCase(),
        brand: _brandController.text,
        model: _modelController.text,
        color: _colorController.text,
        ownerName: _ownerNameController.text,
        registrationDate: DateTime.now(),
      );

      widget.onVehicleRegistered(vehicle);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vehículo registrado exitosamente'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      Navigator.pop(context);
    }
  }
}

// Bottom Sheet de Notificaciones
class NotificationsBottomSheet extends StatelessWidget {
  final List<SecurityAlert> alerts;

  const NotificationsBottomSheet({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A)
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Notificaciones Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1A202C)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/section_title.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/parking_card.dart';
import 'package:parkingnow_owner/features/home/presentation/views/dashboard_header_view.dart';
import 'package:parkingnow_owner/features/home/presentation/views/income_summary_view.dart';
import 'package:parkingnow_owner/features/home/presentation/views/notifications_list_view.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/dashboard_menu_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _termsAccepted = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showTermsDialogIfNeeded);
  }

  void _showTermsDialogIfNeeded() async {
    if (!_termsAccepted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Términos y Condiciones"),
          content: const Text("Para continuar usando la app, debes aceptar los términos y condiciones."),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _termsAccepted = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Aceptar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _termsAccepted = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Rechazar"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match the app theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final List<Widget> sections = [
      _dashboardMainSection(),
      _estacionamientosSection(),
      _reservasSection(),
      _notificacionesSection(),
    ];

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: const DashboardMenuDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Dashboard',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: colorScheme.onPrimary),
            onPressed: () {
              // Navigate to notifications page
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/32.jpg',
              ),
            ),
            onPressed: () {
              // Navigate to profile page
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: sections[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Estacionamientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
        ],
      ),
    );
  }

  // --- SECCIONES PARA LOS TABS ---
  Widget _dashboardMainSection() {
    return Stack(
      children: [
        // Top curved background
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        // Main content
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enhanced header card
              Card(
                elevation: 8,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A202C)
                    : Theme.of(context).colorScheme.surface,
                shadowColor: Theme.of(context).shadowColor.withOpacity(0.16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: const CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/men/32.jpg',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Bienvenido de vuelta!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'John Smith',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Lima, Perú',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildQuickStatCard(
                            context,
                            'Espacios',
                            '12',
                            Icons.local_parking,
                            Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          _buildQuickStatCard(
                            context,
                            'Reservas',
                            '8',
                            Icons.calendar_today,
                            Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          _buildQuickStatCard(
                            context,
                            'Ocupación',
                            '75%',
                            Icons.pie_chart,
                            Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enhanced income summary responsivo
              Card(
                elevation: 4,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A202C)
                    : Theme.of(context).colorScheme.surface,
                shadowColor: Theme.of(context).shadowColor.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isSmall = constraints.maxWidth < 390;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Resumen de Ingresos',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Junio 2025',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          isSmall
                              ? Column(
                            children: [
                              _buildIncomeCard(
                                context,
                                'Hoy',
                                'S/ 150.00',
                                '+12%',
                                Theme.of(context).colorScheme.tertiary,
                              ),
                              const SizedBox(height: 12),
                              _buildIncomeCard(
                                context,
                                'Esta semana',
                                'S/ 1,200.00',
                                '+8%',
                                Theme.of(context).colorScheme.tertiary,
                              ),
                            ],
                          )
                              : Row(
                            children: [
                              Expanded(
                                child: _buildIncomeCard(
                                  context,
                                  'Hoy',
                                  'S/ 150.00',
                                  '+12%',
                                  Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildIncomeCard(
                                  context,
                                  'Esta semana',
                                  'S/ 1,200.00',
                                  '+8%',
                                  Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Ver reporte completo',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enhanced reservations section
              _buildSectionHeader(
                'Reservas para hoy',
                'Ver todas',
                    () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A202C)
                    : Theme.of(context).colorScheme.surface,
                shadowColor: Theme.of(context).shadowColor.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildReservationItem(
                        'Carlos Rodríguez',
                        'Toyota Corolla - ABC123',
                        '09:00 - 11:00',
                        Theme.of(context).colorScheme.primary,
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      _buildReservationItem(
                        'María González',
                        'Honda Civic - XYZ789',
                        '10:30 - 12:30',
                        Theme.of(context).colorScheme.secondary,
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      _buildReservationItem(
                        'Luis Pérez',
                        'Nissan Sentra - DEF456',
                        '13:00 - 15:00',
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Gestionar reservas',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enhanced parking spaces section
              _buildSectionHeader(
                'Mis estacionamientos',
                'Ver todos',
                    () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildEnhancedParkingCard(
                context,
                'Parking San Isidro',
                'Av. Javier Prado 1234',
                4.5,
                12,
                8,
                    () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildEnhancedParkingCard(
                context,
                'Parking Miraflores',
                'Av. Larco 567',
                4.2,
                8,
                5,
                    () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Enhanced notifications section
              _buildSectionHeader(
                'Últimas notificaciones',
                'Ver todas',
                    () {
                  // Navigate to all notifications
                },
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A202C)
                    : Theme.of(context).colorScheme.surface,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildNotificationItem(
                        'Nueva reserva',
                        'Carlos Rodríguez ha reservado un espacio',
                        '10 min',
                        Icons.calendar_today,
                        Colors.blue,
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        'Pago recibido',
                        'Has recibido un pago de S/ 25.00',
                        '1 hora',
                        Icons.payment,
                        Colors.green,
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        'Alerta de ocupación',
                        'Tu estacionamiento está al 90% de capacidad',
                        '3 horas',
                        Icons.warning_amber,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Add parking button
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to add parking page
                },
                icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                label: Text(
                  'Agregar nuevo estacionamiento',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 4,
                  shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _estacionamientosSection() {
    // Solo el bloque "Mis estacionamientos"
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            'Mis estacionamientos',
            'Ver todos',
                () {},
          ),
          const SizedBox(height: 12),
          _buildEnhancedParkingCard(
            context,
            'Parking San Isidro',
            'Av. Javier Prado 1234',
            4.5,
            12,
            8,
                () {},
          ),
          const SizedBox(height: 16),
          _buildEnhancedParkingCard(
            context,
            'Parking Miraflores',
            'Av. Larco 567',
            4.2,
            8,
            5,
                () {},
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add parking page
            },
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
            label: Text(
              'Agregar nuevo estacionamiento',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reservasSection() {
    // Solo el bloque "Reservas para hoy"
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            'Reservas para hoy',
            'Ver todas',
                () {},
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A202C)
                : Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildReservationItem(
                    'Carlos Rodríguez',
                    'Toyota Corolla - ABC123',
                    '09:00 - 11:00',
                    Theme.of(context).colorScheme.primary,
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildReservationItem(
                    'María González',
                    'Honda Civic - XYZ789',
                    '10:30 - 12:30',
                    Theme.of(context).colorScheme.secondary,
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildReservationItem(
                    'Luis Pérez',
                    'Nissan Sentra - DEF456',
                    '13:00 - 15:00',
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Gestionar reservas',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificacionesSection() {
    // Solo el bloque "Últimas notificaciones"
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            'Últimas notificaciones',
            'Ver todas',
                () {},
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A202C)
                : Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNotificationItem(
                    'Nueva reserva',
                    'Carlos Rodríguez ha reservado un espacio',
                    '10 min',
                    Icons.calendar_today,
                    Theme.of(context).colorScheme.primary,
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildNotificationItem(
                    'Pago recibido',
                    'Has recibido un pago de S/ 25.00',
                    '1 hora',
                    Icons.payment,
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildNotificationItem(
                    'Alerta de ocupación',
                    'Tu estacionamiento está al 90% de capacidad',
                    '3 horas',
                    Icons.warning_amber,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCard(
      BuildContext context,
      String title,
      String amount,
      String percentage,
      Color percentageColor,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: percentageColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  percentage,
                  style: textTheme.labelLarge?.copyWith(
                    color: percentageColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'vs semana pasada',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title,
      String actionText,
      VoidCallback onAction,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationItem(
      String name,
      String vehicle,
      String time,
      Color color,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  vehicle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedParkingCard(
      BuildContext context,
      String title,
      String address,
      double rating,
      int totalSpaces,
      int occupiedSpaces,
      VoidCallback onTap,
      ) {
    final occupancyPercentage = (occupiedSpaces / totalSpaces) * 100;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      color: colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_parking,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ocupación',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: occupiedSpaces / totalSpaces,
                            backgroundColor: colorScheme.outline.withOpacity(0.08),
                            color: _getOccupancyColor(context, occupancyPercentage),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$occupiedSpaces/$totalSpaces espacios ocupados',
                          style: textTheme.labelLarge?.copyWith(
                            color: _getOccupancyColor(context, occupancyPercentage),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Detalles',
                      style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
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

  Color _getOccupancyColor(BuildContext context, double percentage) {
    final colorScheme = Theme.of(context).colorScheme;
    if (percentage < 50) {
      return colorScheme.tertiary;
    } else if (percentage < 80) {
      return colorScheme.secondary;
    } else {
      return Colors.red;
    }
  }

  Widget _buildNotificationItem(
      String title,
      String message,
      String time,
      IconData icon,
      Color color,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
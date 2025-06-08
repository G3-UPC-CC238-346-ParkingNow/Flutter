import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  bool _isLoading = false;

  // Colores elegantes y profesionales
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color accentBlue = Color(0xFF60A5FA);
  static const Color darkBlue = Color(0xFF1E40AF);

  // Datos de ejemplo mejorados
  final List<Map<String, dynamic>> _reservations = [
    {
      'id': 'RES001',
      'customerName': 'Carlos Rodríguez',
      'customerImage': 'https://randomuser.me/api/portraits/men/1.jpg',
      'vehiclePlate': 'ABC-123',
      'vehicleModel': 'Toyota Corolla',
      'vehicleType': 'Sedán',
      'parkingSpot': 'A-15',
      'date': '2025-01-07',
      'startTime': '09:00',
      'endTime': '11:00',
      'duration': '2 horas',
      'amount': 10.00,
      'status': 'confirmed',
      'paymentMethod': 'Tarjeta',
      'isNew': true,
      'priority': 'high',
    },
    {
      'id': 'RES002',
      'customerName': 'María González',
      'customerImage': 'https://randomuser.me/api/portraits/women/2.jpg',
      'vehiclePlate': 'XYZ-789',
      'vehicleModel': 'Honda Civic',
      'vehicleType': 'Hatchback',
      'parkingSpot': 'B-08',
      'date': '2025-01-07',
      'startTime': '10:30',
      'endTime': '12:30',
      'duration': '2 horas',
      'amount': 10.00,
      'status': 'pending',
      'paymentMethod': 'Yape',
      'isNew': false,
      'priority': 'medium',
    },
    {
      'id': 'RES003',
      'customerName': 'Luis Pérez',
      'customerImage': 'https://randomuser.me/api/portraits/men/3.jpg',
      'vehiclePlate': 'DEF-456',
      'vehicleModel': 'Nissan Sentra',
      'vehicleType': 'Sedán',
      'parkingSpot': 'C-22',
      'date': '2025-01-07',
      'startTime': '13:00',
      'endTime': '15:00',
      'duration': '2 horas',
      'amount': 10.00,
      'status': 'completed',
      'paymentMethod': 'Efectivo',
      'isNew': false,
      'priority': 'low',
    },
    {
      'id': 'RES004',
      'customerName': 'Ana Torres',
      'customerImage': 'https://randomuser.me/api/portraits/women/4.jpg',
      'vehiclePlate': 'GHI-321',
      'vehicleModel': 'Hyundai Accent',
      'vehicleType': 'Hatchback',
      'parkingSpot': 'A-03',
      'date': '2025-01-06',
      'startTime': '08:00',
      'endTime': '17:00',
      'duration': '9 horas',
      'amount': 45.00,
      'status': 'cancelled',
      'paymentMethod': 'Plin',
      'isNew': false,
      'priority': 'low',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
      ),
    );
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? primaryBlue : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reservas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCompactStatsRow(isDark),
          Expanded(
            child: _buildReservationsList(_reservations, isDark),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCompactStatsRow(bool isDark) {
    // Compute stats
    int total = _reservations.length;
    int confirmadas = _reservations.where((r) => r['status'] == 'confirmed').length;
    int pendientes = _reservations.where((r) => r['status'] == 'pending').length;
    int canceladas = _reservations.where((r) => r['status'] == 'cancelled').length;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _miniStatCard('Total', total.toString(), Icons.calendar_today_rounded, primaryBlue, isDark),
            const SizedBox(width: 8),
            _miniStatCard('Confirmadas', confirmadas.toString(), Icons.check_circle_rounded, Colors.green, isDark),
            const SizedBox(width: 8),
            _miniStatCard('Pendientes', pendientes.toString(), Icons.pending_rounded, Colors.orange, isDark),
            const SizedBox(width: 8),
            _miniStatCard('Canceladas', canceladas.toString(), Icons.cancel_rounded, Colors.red, isDark),
          ],
        ),
      ),
    );
  }

  Widget _miniStatCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget _buildReservationsList(List<Map<String, dynamic>> reservations, bool isDark) {
    if (reservations.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return RefreshIndicator(
      onRefresh: _refreshReservations,
      color: primaryBlue,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return _buildReservationCard(reservations[index], isDark);
        },
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation, bool isDark) {
    final statusColor = _getStatusColor(reservation['status']);
    final statusText = _getStatusText(reservation['status']);
    final priorityColor = _getPriorityColor(reservation['priority']);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showReservationDetails(reservation),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: priorityColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          reservation['customerImage'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: primaryBlue.withOpacity(0.1),
                              child: Icon(
                                Icons.person_rounded,
                                color: primaryBlue,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  reservation['customerName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (reservation['isNew'])
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'NUEVO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${reservation['id']}',
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.grey[600],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: statusColor.withOpacity(0.18)),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.directions_car_rounded, color: primaryBlue, size: 17),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        reservation['vehicleModel'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.credit_card_rounded, size: 12, color: Colors.blue),
                          const SizedBox(width: 3),
                          Text(
                            reservation['vehiclePlate'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_parking_rounded, color: Colors.indigo, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            reservation['parkingSpot'],
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${reservation['startTime']} - ${reservation['endTime']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.payments_rounded, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'S/ ${reservation['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _contactCustomer(reservation),
                        icon: const Icon(Icons.phone_rounded, size: 16),
                        label: const Text(
                          'Contactar',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryBlue,
                          side: BorderSide(color: primaryBlue, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _manageReservation(reservation),
                        icon: const Icon(Icons.settings_rounded, size: 16),
                        label: const Text(
                          'Gestionar',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 80,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No hay reservas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Las reservas aparecerán aquí cuando los clientes las realicen',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddReservationDialog(),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Crear Reserva Manual',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 6,
                shadowColor: primaryBlue.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0, right: 10.0),
      child: FloatingActionButton(
        onPressed: () => _showAddReservationDialog(),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 10,
        child: const Icon(Icons.add_rounded, size: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Métodos auxiliares
  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmada';
      case 'pending':
        return 'Pendiente';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }


  Future<void> _refreshReservations() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Reservas actualizadas',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }


  void _showReservationDetails(Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.info_rounded,
                color: primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Reserva ${reservation['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Cliente', reservation['customerName']),
              _buildDetailRow('Vehículo', reservation['vehicleModel']),
              _buildDetailRow('Placa', reservation['vehiclePlate']),
              _buildDetailRow('Espacio', reservation['parkingSpot']),
              _buildDetailRow('Fecha', reservation['date']),
              _buildDetailRow('Horario', '${reservation['startTime']} - ${reservation['endTime']}'),
              _buildDetailRow('Duración', reservation['duration']),
              _buildDetailRow('Monto', 'S/ ${reservation['amount'].toStringAsFixed(2)}'),
              _buildDetailRow('Pago', reservation['paymentMethod']),
              _buildDetailRow('Estado', _getStatusText(reservation['status'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReservationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon in a circular background
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: primaryBlue,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              // Title centered, big and bold
              Text(
                'Nueva Reserva\nManual',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              // Description
              const Text(
                'Aquí puedes crear una reserva manual para un cliente que llegue sin reserva previa.',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              // Buttons aligned horizontally with equal size and space
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        side: BorderSide(color: primaryBlue.withOpacity(0.25)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      child: const Text('Crear'),
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

  void _contactCustomer(Map<String, dynamic> reservation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Contactando a ${reservation['customerName']}...',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _manageReservation(Map<String, dynamic> reservation) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings_rounded,
                    color: primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Gestionar Reserva ${reservation['id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildManagementOption(
              icon: Icons.check_circle_rounded,
              title: 'Confirmar Reserva',
              color: Colors.green,
              onTap: () => Navigator.pop(context),
            ),
            _buildManagementOption(
              icon: Icons.edit_rounded,
              title: 'Modificar Reserva',
              color: Colors.blue,
              onTap: () => Navigator.pop(context),
            ),
            _buildManagementOption(
              icon: Icons.cancel_rounded,
              title: 'Cancelar Reserva',
              color: Colors.red,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: color.withOpacity(0.05),
      ),
    );
  }
}

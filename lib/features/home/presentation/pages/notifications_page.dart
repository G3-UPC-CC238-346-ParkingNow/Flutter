import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/section_title.dart';

// Modelo para notificaciones
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.isRead = false,
    this.imageUrl,
    this.data,
  });
}

enum NotificationType { reservation, payment, alert, system, promotion, review }
enum NotificationPriority { low, normal, high, urgent }

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Todas';
  bool _isLoading = false;
  bool _isSelectionMode = false;
  Set<String> _selectedNotifications = {};

  final List<String> _filters = ['Todas', 'Reservas', 'Pagos', 'Alertas', 'Sistema', 'Promociones'];

  // Datos de ejemplo
  late List<NotificationModel> _notifications;
  late List<NotificationModel> _filteredNotifications;
  late List<NotificationModel> _historyNotifications;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    initializeDateFormatting('es').then((_) {
      _initializeNotifications();
    });
  }

  void _initializeNotifications() {
    // Notificaciones recientes
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Nueva reserva confirmada',
        message: 'Carlos Rodríguez ha confirmado su reserva para mañana a las 09:00 AM en tu estacionamiento principal. Espacio asignado: A-12.',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.reservation,
        priority: NotificationPriority.high,
        data: {
          'reservationId': '12345',
          'userId': 'user123',
          'parkingSpot': 'A-12',
          'amount': 25.00,
        },
      ),
      NotificationModel(
        id: '2',
        title: 'Pago recibido',
        message: 'Has recibido un pago de S/ 25.00 por la reserva #12345. El pago ha sido procesado correctamente y se ha enviado un recibo al cliente.',
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        type: NotificationType.payment,
        priority: NotificationPriority.normal,
        data: {
          'paymentId': 'pay_789',
          'amount': 25.00,
          'reservationId': '12345',
        },
      ),
      NotificationModel(
        id: '3',
        title: 'Alerta de ocupación',
        message: 'Tu estacionamiento San Isidro está al 90% de capacidad. Considera enviar notificaciones a tus clientes sobre la disponibilidad limitada.',
        time: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.alert,
        priority: NotificationPriority.urgent,
        data: {
          'parkingId': 'park_456',
          'occupancyRate': 0.9,
          'availableSpots': 5,
        },
      ),
      NotificationModel(
        id: '4',
        title: 'Cancelación de reserva',
        message: 'María González ha cancelado su reserva para hoy. El espacio B-07 está ahora disponible para otras reservas.',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.reservation,
        priority: NotificationPriority.normal,
        isRead: true,
        data: {
          'reservationId': '67890',
          'userId': 'user456',
          'parkingSpot': 'B-07',
          'refundAmount': 18.50,
        },
      ),
      NotificationModel(
        id: '5',
        title: 'Nueva reseña: ⭐⭐⭐⭐⭐',
        message: 'Luis Pérez ha dejado una reseña de 5 estrellas: "Excelente servicio, muy seguro y fácil de usar. Definitivamente volveré a usar este estacionamiento."',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotificationType.review,
        priority: NotificationPriority.normal,
        isRead: true,
        imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        data: {
          'reviewId': 'rev_123',
          'userId': 'user789',
          'rating': 5,
        },
      ),
      NotificationModel(
        id: '6',
        title: 'Mantenimiento programado',
        message: 'Recordatorio: Mantenimiento del sistema mañana a las 02:00 AM. El servicio podría experimentar interrupciones breves durante este período.',
        time: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.system,
        priority: NotificationPriority.low,
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        title: 'Promoción activada',
        message: 'Tu promoción "Descuento de fin de semana" ha sido activada y estará vigente hasta el domingo. Los clientes ya pueden ver esta oferta en la app.',
        time: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.promotion,
        priority: NotificationPriority.normal,
        isRead: true,
        data: {
          'promoId': 'promo_123',
          'discount': 0.15,
          'endDate': DateTime.now().add(const Duration(days: 2)).toString(),
        },
      ),
    ];

    // Notificaciones históricas
    _historyNotifications = [
      NotificationModel(
        id: '8',
        title: 'Recibo generado',
        message: 'Se ha generado el recibo #REC-2025-001 por S/ 150.00 correspondiente a las reservas del mes anterior.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.payment,
        isRead: true,
      ),
      NotificationModel(
        id: '9',
        title: 'Actualización de perfil',
        message: 'Tu información de perfil ha sido actualizada exitosamente. Recuerda mantener tus datos de contacto siempre actualizados.',
        time: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        type: NotificationType.system,
        isRead: true,
      ),
      NotificationModel(
        id: '10',
        title: 'Nuevo usuario registrado',
        message: 'Ana Torres se ha registrado y está buscando estacionamiento en tu zona. Asegúrate de que tu disponibilidad esté actualizada.',
        time: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.system,
        isRead: true,
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
      NotificationModel(
        id: '11',
        title: 'Promoción activada',
        message: 'Tu promoción de descuento del 20% está ahora activa y visible para todos los usuarios. Vigencia: 7 días.',
        time: DateTime.now().subtract(const Duration(days: 5)),
        type: NotificationType.promotion,
        isRead: true,
      ),
      NotificationModel(
        id: '12',
        title: 'Reporte mensual disponible',
        message: 'Tu reporte de ingresos del mes anterior ya está disponible. Ingresos totales: S/ 3,450.00',
        time: DateTime.now().subtract(const Duration(days: 7)),
        type: NotificationType.system,
        isRead: true,
      ),
      NotificationModel(
        id: '13',
        title: 'Actualización de la aplicación',
        message: 'Hemos lanzado una nueva versión de la aplicación con mejoras en la seguridad y rendimiento.',
        time: DateTime.now().subtract(const Duration(days: 10)),
        type: NotificationType.system,
        isRead: true,
      ),
      NotificationModel(
        id: '14',
        title: 'Reserva recurrente creada',
        message: 'Juan Méndez ha creado una reserva recurrente para todos los lunes de 8:00 AM a 6:00 PM.',
        time: DateTime.now().subtract(const Duration(days: 14)),
        type: NotificationType.reservation,
        isRead: true,
      ),
    ];

    _applyFilter(_selectedFilter);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      if (filter == 'Todas') {
        _filteredNotifications = List.from(_notifications);
      } else {
        NotificationType type;
        switch (filter) {
          case 'Reservas':
            type = NotificationType.reservation;
            break;
          case 'Pagos':
            type = NotificationType.payment;
            break;
          case 'Alertas':
            type = NotificationType.alert;
            break;
          case 'Sistema':
            type = NotificationType.system;
            break;
          case 'Promociones':
            type = NotificationType.promotion;
            break;
          default:
            _filteredNotifications = List.from(_notifications);
            return;
        }

        _filteredNotifications = _notifications.where((n) => n.type == type).toList();
      }
    });
  }

  void _handleTabChange() {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedNotifications.clear();
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Contar notificaciones no leídas
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final urgentCount = _notifications.where((n) =>
    n.priority == NotificationPriority.urgent ||
        n.priority == NotificationPriority.high).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSelectionMode
            ? Text(
          '${_selectedNotifications.length} seleccionadas',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1E293B),
          ),
        )
            : const Text(
          'Notificaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isSelectionMode
            ? IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E293B)),
          onPressed: () {
            setState(() {
              _isSelectionMode = false;
              _selectedNotifications.clear();
            });
          },
        )
            : IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF334155),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: _isSelectionMode
            ? [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _deleteSelectedNotifications(),
          ),
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            onPressed: () => _markSelectedAsRead(),
          ),
        ]
            : [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () => _showSearchDialog(context),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.filter_list,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.more_vert,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onSelected: (value) {
              if (value == 'select') {
                setState(() {
                  _isSelectionMode = true;
                });
              } else if (value == 'markAllRead') {
                _markAllAsRead();
              } else if (value == 'settings') {
                _showNotificationSettings(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'select',
                child: Row(
                  children: [
                    Icon(Icons.select_all, size: 20),
                    SizedBox(width: 8),
                    Text('Seleccionar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'markAllRead',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20),
                    SizedBox(width: 8),
                    Text('Marcar todas como leídas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        color: AppColors.primary,
        child: Column(
          children: [
            // Header with stats
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    Color.lerp(AppColors.primary, Colors.indigo, 0.3)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Hola, John!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          unreadCount > 0
                              ? 'Tienes $unreadCount notificaciones sin leer'
                              : 'No tienes notificaciones sin leer',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatItem('$unreadCount', 'Nuevas', Icons.notifications),
                            const SizedBox(width: 20),
                            _buildStatItem('$urgentCount', 'Urgentes', Icons.priority_high),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 40,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        _applyFilter(filter);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      elevation: isSelected ? 4 : 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Recientes'),
                  Tab(text: 'Historial'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecentNotifications(),
                  _buildNotificationHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isSelectionMode
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton.icon(
                onPressed: _markAllAsRead,
                icon: const Icon(Icons.done_all),
                label: const Text('Marcar como leídas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentNotifications() {
    if (_filteredNotifications.isEmpty) {
      return _buildEmptyState(
        'No hay notificaciones',
        'No tienes notificaciones recientes en esta categoría',
        Icons.notifications_off_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationHistory() {
    if (_historyNotifications.isEmpty) {
      return _buildEmptyState(
        'No hay historial',
        'Tu historial de notificaciones está vacío',
        Icons.history,
      );
    }

    // Agrupar por fecha
    final groupedNotifications = <String, List<NotificationModel>>{};

    for (var notification in _historyNotifications) {
      final date = _formatDateForGrouping(notification.time);
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final date = groupedNotifications.keys.elementAt(index);
        final notifications = groupedNotifications[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            ...notifications.map((notification) => _buildNotificationItem(notification, isHistory: true)),
          ],
        );
      },
    );
  }

  String _formatDateForGrouping(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hoy';
    } else if (dateToCheck == yesterday) {
      return 'Ayer';
    } else if (now.difference(dateToCheck).inDays < 7) {
      return 'Esta semana';
    } else if (now.difference(dateToCheck).inDays < 30) {
      return 'Este mes';
    } else {
      return DateFormat('MMMM yyyy', 'es').format(date);
    }
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _refreshNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      NotificationModel notification, {
        bool isHistory = false,
      }) {
    final isSelected = _selectedNotifications.contains(notification.id);
    final isNew = !notification.isRead && !isHistory;

    Color getNotificationColor() {
      switch (notification.type) {
        case NotificationType.reservation:
          return Colors.blue;
        case NotificationType.payment:
          return Colors.green;
        case NotificationType.alert:
          return Colors.orange;
        case NotificationType.system:
          return Colors.purple;
        case NotificationType.promotion:
          return Colors.pink;
        case NotificationType.review:
          return Colors.amber;
      }
    }

    IconData getNotificationIcon() {
      switch (notification.type) {
        case NotificationType.reservation:
          return Icons.calendar_today;
        case NotificationType.payment:
          return Icons.payment;
        case NotificationType.alert:
          return Icons.warning_amber;
        case NotificationType.system:
          return Icons.settings;
        case NotificationType.promotion:
          return Icons.local_offer;
        case NotificationType.review:
          return Icons.star;
      }
    }

    String formatTimeAgo(DateTime dateTime) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Ahora';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d';
      } else {
        return DateFormat('dd/MM/yy', 'es').format(dateTime);
      }
    }

    return GestureDetector(
      onLongPress: () {
        if (!_isSelectionMode) {
          setState(() {
            _isSelectionMode = true;
            _selectedNotifications.add(notification.id);
          });
        }
      },
      onTap: () {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedNotifications.remove(notification.id);
              if (_selectedNotifications.isEmpty) {
                _isSelectionMode = false;
              }
            } else {
              _selectedNotifications.add(notification.id);
            }
          });
        } else {
          _showNotificationDetails(context, notification);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            Card(
              elevation: isNew ? 6 : 2,
              shadowColor: isNew ? getNotificationColor().withOpacity(0.3) : Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isNew
                    ? BorderSide(color: getNotificationColor().withOpacity(0.3), width: 1)
                    : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_isSelectionMode)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                              : null,
                        ),
                      ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: getNotificationColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: notification.imageUrl != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          notification.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              getNotificationIcon(),
                              color: getNotificationColor(),
                              size: 24,
                            );
                          },
                        ),
                      )
                          : Icon(
                        getNotificationIcon(),
                        color: getNotificationColor(),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 16,
                                    color: isNew ? Colors.black : Colors.grey[800],
                                  ),
                                ),
                              ),
                              if (isNew && !_isSelectionMode)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: getNotificationColor(),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatTimeAgo(notification.time),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (!_isSelectionMode)
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.grey[400],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (notification.priority == NotificationPriority.urgent && !isHistory)
              Positioned(
                top: 0,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'URGENTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Buscar notificaciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe para buscar...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sugerencias de búsqueda:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildSearchChip('Reservas'),
                  _buildSearchChip('Pagos'),
                  _buildSearchChip('Hoy'),
                  _buildSearchChip('Urgente'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement search functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return InkWell(
      onTap: () {
        // Implement search with this term
        Navigator.pop(context);
      },
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[200],
        labelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Filtrar notificaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una categoría para filtrar tus notificaciones',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categorías',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    _applyFilter(filter);
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Período',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFilterChip('Hoy', false),
                _buildFilterChip('Esta semana', false),
                _buildFilterChip('Este mes', false),
                _buildFilterChip('Personalizado', false),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Aplicar filtros',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _applyFilter('Todas');
                  Navigator.pop(context);
                },
                child: const Text('Limpiar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Implement period filtering
      },
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Configuración de notificaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsSwitchItem(
                    'Notificaciones push',
                    'Recibe alertas en tu dispositivo',
                    true,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Notificaciones por correo',
                    'Recibe un resumen diario por email',
                    false,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Sonidos',
                    'Reproduce sonidos para notificaciones',
                    true,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Vibración',
                    'Vibra al recibir notificaciones',
                    true,
                        (value) {},
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Tipos de notificaciones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildSettingsSwitchItem(
                    'Reservas',
                    'Nuevas reservas y cancelaciones',
                    true,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Pagos',
                    'Confirmaciones y recibos',
                    true,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Alertas',
                    'Notificaciones urgentes',
                    true,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Sistema',
                    'Actualizaciones y mantenimiento',
                    false,
                        (value) {},
                  ),
                  _buildSettingsSwitchItem(
                    'Promociones',
                    'Ofertas y descuentos',
                    true,
                        (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Configuración guardada'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Guardar configuración',
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
    );
  }

  Widget _buildSettingsSwitchItem(
      String title,
      String subtitle,
      bool initialValue,
      Function(bool) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationModel notification) {
    // Marcar como leída
    if (!notification.isRead) {
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = NotificationModel(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            time: notification.time,
            type: notification.type,
            priority: notification.priority,
            isRead: true,
            imageUrl: notification.imageUrl,
            data: notification.data,
          );
          _applyFilter(_selectedFilter);
        }
      });
    }

    Color getNotificationColor() {
      switch (notification.type) {
        case NotificationType.reservation:
          return Colors.blue;
        case NotificationType.payment:
          return Colors.green;
        case NotificationType.alert:
          return Colors.orange;
        case NotificationType.system:
          return Colors.purple;
        case NotificationType.promotion:
          return Colors.pink;
        case NotificationType.review:
          return Colors.amber;
      }
    }

    IconData getNotificationIcon() {
      switch (notification.type) {
        case NotificationType.reservation:
          return Icons.calendar_today;
        case NotificationType.payment:
          return Icons.payment;
        case NotificationType.alert:
          return Icons.warning_amber;
        case NotificationType.system:
          return Icons.settings;
        case NotificationType.promotion:
          return Icons.local_offer;
        case NotificationType.review:
          return Icons.star;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getNotificationColor(),
                    getNotificationColor().withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          getNotificationIcon(),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd MMMM yyyy, HH:mm', 'es').format(notification.time),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (notification.data != null && notification.data!.isNotEmpty) ...[
                      const Text(
                        'Detalles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...notification.data!.entries.map((entry) => _buildDetailItem(entry.key, entry.value)),
                    ],
                    const SizedBox(height: 24),
                    const Text(
                      'Acciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButtons(notification),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String key, dynamic value) {
    String formattedKey = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
    );
    formattedKey = formattedKey[0].toUpperCase() + formattedKey.substring(1);

    String formattedValue = value.toString();
    if (value is double) {
      formattedValue = 'S/ ${value.toStringAsFixed(2)}';
    } else if (value is DateTime) {
      formattedValue = DateFormat('dd/MM/yyyy HH:mm', 'es').format(value);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$formattedKey:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              formattedValue,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(NotificationModel notification) {
    List<Widget> buttons = [];

    switch (notification.type) {
      case NotificationType.reservation:
        buttons = [
          _buildActionButton('Ver reserva', Icons.visibility, AppColors.primary),
          _buildActionButton('Contactar', Icons.message, Colors.blue),
        ];
        break;
      case NotificationType.payment:
        buttons = [
          _buildActionButton('Ver pago', Icons.receipt, AppColors.primary),
          _buildActionButton('Descargar recibo', Icons.download, Colors.green),
        ];
        break;
      case NotificationType.alert:
        buttons = [
          _buildActionButton('Ver detalles', Icons.warning, Colors.orange),
          _buildActionButton('Resolver', Icons.check_circle, AppColors.primary),
        ];
        break;
      case NotificationType.system:
        buttons = [
          _buildActionButton('Configuración', Icons.settings, Colors.purple),
        ];
        break;
      case NotificationType.promotion:
        buttons = [
          _buildActionButton('Ver promoción', Icons.visibility, Colors.pink),
          _buildActionButton('Editar', Icons.edit, AppColors.primary),
        ];
        break;
      case NotificationType.review:
        buttons = [
          _buildActionButton('Ver reseña', Icons.star, Colors.amber),
          _buildActionButton('Responder', Icons.reply, AppColors.primary),
        ];
        break;
    }

    return Column(
      children: [
        ...buttons,
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _deleteNotification(notification.id);
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: const Text(
            'Eliminar notificación',
            style: TextStyle(color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          // Implement action
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 0),
        ),
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _initializeNotifications();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificaciones actualizadas'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = NotificationModel(
            id: _notifications[i].id,
            title: _notifications[i].title,
            message: _notifications[i].message,
            time: _notifications[i].time,
            type: _notifications[i].type,
            priority: _notifications[i].priority,
            isRead: true,
            imageUrl: _notifications[i].imageUrl,
            data: _notifications[i].data,
          );
        }
      }
      _applyFilter(_selectedFilter);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todas las notificaciones marcadas como leídas'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _markSelectedAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        if (_selectedNotifications.contains(_notifications[i].id)) {
          _notifications[i] = NotificationModel(
            id: _notifications[i].id,
            title: _notifications[i].title,
            message: _notifications[i].message,
            time: _notifications[i].time,
            type: _notifications[i].type,
            priority: _notifications[i].priority,
            isRead: true,
            imageUrl: _notifications[i].imageUrl,
            data: _notifications[i].data,
          );
        }
      }
      _isSelectionMode = false;
      _selectedNotifications.clear();
      _applyFilter(_selectedFilter);
    });
  }

  void _deleteSelectedNotifications() {
    setState(() {
      _notifications.removeWhere((n) => _selectedNotifications.contains(n.id));
      _selectedNotifications.clear();
      _isSelectionMode = false;
      _applyFilter(_selectedFilter);
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notificationId);
      _applyFilter(_selectedFilter);
    });
  }
}
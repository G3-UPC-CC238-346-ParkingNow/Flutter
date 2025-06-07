import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/core/ui/custom_button.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/section_title.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/parking_card.dart';
import 'package:parkingnow_owner/features/home/presentation/views/dashboard_header_view.dart';
import 'package:parkingnow_owner/features/home/presentation/views/income_summary_view.dart';
import 'package:parkingnow_owner/features/home/presentation/views/notifications_list_view.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';
import 'package:parkingnow_owner/features/home/presentation/widgets/dashboard_menu_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardMenuDrawer(),
      appBar: AppBar(
        title: const Text(
          'Dashboard Dueño de estacionamiento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const DashboardHeaderView(
              name: 'John Smith',
              location: 'Lima, Perú',
            ),
            const SizedBox(height: 32),
            const SectionTitle(text: 'Reservas para hoy'),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Reservas programadas',
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            const SectionTitle(text: 'Espacios'),
            const SizedBox(height: 12),
            ParkingCard(
              title: 'Parking San Isidro',
              address: 'Av. Javier Prado 1234',
              rating: 4.5,
              onTap: () {
                // Acción futura (navegar o mostrar detalles)
              },
            ),
            const SizedBox(height: 24),
            IncomeSummaryView(
              todayIncome: 150.00,
              weeklyIncome: 1200.00,
            ),
            const SizedBox(height: 32),
            const SectionTitle(text: 'Últimas notificaciones'),
            const SizedBox(height: 12),
            const NotificationsListView(),
          ],
        ),
      ),
    );
  }
}
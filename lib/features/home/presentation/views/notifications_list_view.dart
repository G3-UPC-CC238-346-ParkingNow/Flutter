import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      'Nueva reserva confirmada para hoy',
      'Un cliente calificó tu local',
      'Espacio desocupado en local A',
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Text(
            notifications[index],
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textTitle,
            ),
          ),
        );
      },
    );
  }
}
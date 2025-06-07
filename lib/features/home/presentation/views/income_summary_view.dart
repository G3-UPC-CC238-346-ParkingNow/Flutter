import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';

class IncomeSummaryView extends StatelessWidget {
  final double todayIncome;
  final double weeklyIncome;

  const IncomeSummaryView({
    super.key,
    required this.todayIncome,
    required this.weeklyIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen de ingresos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textTitle,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIncomeTile('Hoy', todayIncome),
                _buildIncomeTile('Esta semana', weeklyIncome),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeTile(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 8),
        Text(
          'S/ ${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
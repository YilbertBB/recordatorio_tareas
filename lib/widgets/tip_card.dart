import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.55),
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consejo de cocina',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Usa temporizadores con 2 minutos de antelación para que el calor residual no sobrecueza salsas ni huevos.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onPrimaryFixed.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

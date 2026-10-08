import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CompletedTaskCard extends StatelessWidget {
  const CompletedTaskCard({
    super.key,
    required this.title,
    required this.completedAt,
  });

  final String title;
  final String completedAt;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: AppRadius.brLg,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: AppRadius.brMd,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.onSecondaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completado a las $completedAt',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.secondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.lock, size: 20, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

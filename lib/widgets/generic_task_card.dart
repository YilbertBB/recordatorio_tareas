import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class GenericTaskCard extends StatelessWidget {
  const GenericTaskCard({
    super.key,
    required this.icon,
    required this.title,
    required this.metaLabel,
    required this.categoryLabel,
    this.trailingTimer,
    this.progress,
    this.footerLabel,
    this.onComplete,
    this.onAddMinutes,
    this.onTap,
    this.iconBg = AppColors.surfaceContainerHighest,
    this.iconColor = AppColors.textSecondary,
  });

  final IconData icon;
  final String title;
  final String metaLabel;
  final String categoryLabel;
  final String? trailingTimer;
  final double? progress;
  final String? footerLabel;
  final VoidCallback? onComplete;
  final VoidCallback? onAddMinutes;
  final VoidCallback? onTap;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: AppRadius.brLg,
          border: AppShadows.cardBorder,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: AppRadius.brMd,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: AppRadius.brFull,
                            ),
                            child: Text(
                              metaLabel,
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            categoryLabel,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailingTimer != null) ...[
                  Text(
                    trailingTimer!,
                    style: AppTypography.timerDisplayMobile.copyWith(
                      fontSize: 24,
                      height: 1.0,
                      color: AppColors.tertiary,
                    ),
                  ),
                ] else if (onComplete != null)
                  Material(
                    color: AppColors.surfaceContainerLowest,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onComplete,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.check,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: AppRadius.brFull,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation(AppColors.tertiary),
                ),
              ),
            ],
            if (footerLabel != null || onAddMinutes != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (footerLabel != null)
                    Text(
                      footerLabel!,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const Spacer(),
                  if (onAddMinutes != null)
                    Material(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: AppRadius.brMd,
                      child: InkWell(
                        onTap: onAddMinutes,
                        borderRadius: AppRadius.brMd,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.more_time,
                                size: 14,
                                color: AppColors.textPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+5m',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (onComplete != null) ...[
                    const SizedBox(width: 8),
                    Material(
                      color: AppColors.secondaryContainer,
                      borderRadius: AppRadius.brMd,
                      child: InkWell(
                        onTap: onComplete,
                        borderRadius: AppRadius.brMd,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.done,
                            size: 18,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

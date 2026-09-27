import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class HeroTimerCard extends StatelessWidget {
  const HeroTimerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeRemaining,
    required this.progress,
    required this.isRunning,
    required this.onToggle,
    required this.onComplete,
    required this.onAddMinutes,
    required this.onOpenDetail,
  });

  final String title;
  final String subtitle;
  final String timeRemaining;
  final double progress; // 0..1
  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback onComplete;
  final void Function(int minutes) onAddMinutes;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenDetail,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.surfaceCard, Color(0xFFFFF9F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: AppRadius.brLg,
          border: AppShadows.heroBorder,
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: AppRadius.brMd,
                  ),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.onPrimaryFixed,
                    size: 26,
                  ),
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
                              color: AppColors.errorContainer,
                              borderRadius: AppRadius.brFull,
                            ),
                            child: Text(
                              'URGENTE',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onErrorContainer,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.06,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Fuego alto',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: AppTypography.headlineSm,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onOpenDetail,
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Timer readout + circular gauge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerSubtle,
                borderRadius: AppRadius.brMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIEMPO RESTANTE',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.08,
                        ),
                      ),
                      Text(
                        timeRemaining,
                        style: AppTypography.timerDisplayMobile.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 4,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTypography.labelMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Quick actions
           Row(
  children: [
    Expanded(
      child: _pillAction(
        icon: Icons.add,
        label: '+5 min',
        onTap: () => onAddMinutes(5),
      ),
    ),
    const SizedBox(width: 6),
    Expanded(
      child: _pillAction(
        icon: Icons.snooze,
        label: '+2m',
        onTap: () => onAddMinutes(2),
      ),
    ),
    const SizedBox(width: 6),
    Expanded(
      child: _pillAction(
        icon: isRunning ? Icons.pause : Icons.play_arrow,
        label: isRunning ? 'Pausar' : 'Reanudar',
        onTap: onToggle,
      ),
    ),
    const SizedBox(width: 6),
    // El botón "Listo" NO se expande: mantiene su ancho natural
    Material(
      color: AppColors.secondary,
      borderRadius: AppRadius.brMd,
      child: InkWell(
        onTap: onComplete,
        borderRadius: AppRadius.brMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.check, size: 18, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                'Listo',
                style: AppTypography.labelMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }

  Widget _pillAction({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Material(
    color: AppColors.surfaceContainerSubtle,
    borderRadius: AppRadius.brMd,
    child: InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // ← 10 → 8
        child: Row(
          mainAxisSize: MainAxisSize.min,           // ← importante
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 4),
            Flexible(                                 // ← evita overflow de texto
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMd
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

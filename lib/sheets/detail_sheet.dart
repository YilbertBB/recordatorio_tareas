import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class DetailSheet extends StatelessWidget {
  const DetailSheet({
    super.key,
    required this.title,
    required this.note,
    required this.timeRemaining,
    required this.progress,
    required this.flameLabel,
  });

  final String title;
  final String note;
  final String timeRemaining;
  final double progress;
  final String flameLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.brSheetTop,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD6CEBE),
                borderRadius: AppRadius.brFull,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
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
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  flameLabel,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Material(
                  color: AppColors.surfaceContainerSubtle,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLg,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 210,
                          height: 210,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'RESTANTE',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.textTertiary,
                                letterSpacing: 0.08,
                              ),
                            ),
                            Text(
                              timeRemaining,
                              style: AppTypography.timerDisplayMobile,
                            ),
                            Text(
                              'En progreso',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerSubtle,
                      borderRadius: AppRadius.brLg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _meta(
                            'Hora de inicio',
                            '12:58 PM',
                            AppColors.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: _meta(
                            'Alarma estimada',
                            '01:01 PM',
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.5),
                      borderRadius: AppRadius.brLg,
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.snooze,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'POSPONER AVISO',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.06,
                                ),
                              ),
                              Text(
                                'Recordarme en 2 minutos',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.onPrimaryFixed.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.brBase,
                            ),
                          ),
                          icon: const Icon(Icons.alarm_on, size: 16),
                          label: Text(
                            '+2 min',
                            style: AppTypography.labelMd.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ghost('+5m', Icons.more_time),
                      const SizedBox(width: 8),
                      _ghost('Pausar', Icons.pause),
                      const SizedBox(width: 8),
                      _ghost('Reiniciar', Icons.restart_alt),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brLg,
                        ),
                      ),
                      icon: const Icon(Icons.task_alt, size: 22),
                      label: Text(
                        'Marcar como Completada',
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.error,
                    ),
                    label: Text(
                      'Eliminar este recordatorio',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.error,
                      ),
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

  Widget _meta(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMd.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _ghost(String label, IconData icon) {
    return Expanded(
      child: Material(
        color: AppColors.surfaceContainerSubtle,
        borderRadius: AppRadius.brMd,
        child: InkWell(
          onTap: () {},
          borderRadius: AppRadius.brMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

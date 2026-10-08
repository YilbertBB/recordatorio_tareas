import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum ChipVariant { urgent, category, categoryActive, neutral }

class StatusChip extends StatefulWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.variant = ChipVariant.neutral,
    this.pulse = false,
    this.icon,
  });

  final String label;
  final ChipVariant variant;
  final bool pulse;
  final IconData? icon;

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color border;
    late Color text;
    switch (widget.variant) {
      case ChipVariant.urgent:
        bg = AppColors.primaryFixed;
        border = const Color(0x4DE85D04);
        text = AppColors.primary;
        break;
      case ChipVariant.category:
        bg = AppColors.surfaceCard;
        border = AppColors.surfaceBorder;
        text = AppColors.textSecondary;
        break;
      case ChipVariant.categoryActive:
        bg = AppColors.textPrimary;
        border = AppColors.textPrimary;
        text = Colors.white;
        break;
      case ChipVariant.neutral:
        bg = AppColors.surfaceContainerLowest;
        border = Colors.transparent;
        text = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.brFull,
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.pulse) ...[
            FadeTransition(
              opacity: Tween<double>(begin: 0.4, end: 1).animate(_pulseCtrl),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: text, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ] else if (widget.icon != null) ...[
            Icon(widget.icon, size: 14, color: text),
            const SizedBox(width: 4),
          ],
          Text(
            widget.label,
            style: AppTypography.labelMd.copyWith(
              color: text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

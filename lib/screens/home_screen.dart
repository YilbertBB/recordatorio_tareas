import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../services/reminder_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import '../widgets/completed_task_card.dart';
import '../widgets/generic_task_card.dart';
import '../widgets/hero_timer_card.dart';
import '../widgets/quick_preset_button.dart';
import '../widgets/status_chip.dart';
import '../widgets/tip_card.dart';
import '../sheets/new_reminder_sheet.dart';
import '../sheets/detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      context.read<ReminderController>().markExpiredRemindersCompleted();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // ─── Helpers de formato ────────────────────────────────────
  String _formatRemaining(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return '00:00';
    final m = diff.inMinutes.toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double _progress(Reminder r) {
    final total = r.scheduledTime.difference(DateTime.now()).inSeconds;
    if (total <= 0) return 0.0;
    return (total / 3600).clamp(0.0, 1.0);
  }

  String _formatTimeOfDay(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  // ─── Abrir sheets ──────────────────────────────────────────
  void _openNewSheet({
    String? presetTitle,
    int? presetMinutes,
    Reminder? reminderToEdit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (_) => NewReminderSheet(
        reminderToEdit: reminderToEdit,
        initialTitle: presetTitle,
        initialMinutes: presetMinutes,
      ),
    );
  }

  void _openDetailSheet(Reminder reminder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (_) => DetailSheet(reminder: reminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReminderController>();
    final reminders = controller.reminders;
    final activeCount = reminders.where((reminder) => !reminder.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.surfaceCanvas,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hola 👋', style: AppTypography.headlineMd),
            const SizedBox(width: 8),
            StatusChip(
              label: '$activeCount pendientes',
              variant: activeCount == 0
                  ? ChipVariant.neutral
                  : ChipVariant.urgent,
              pulse: activeCount > 0,
            ),
          ],
        ),
      ),
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.primaryHalo,
          ),
          child: FloatingActionButton(
            onPressed: () => _openNewSheet(),
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _presetsSection(),
                  const SizedBox(height: 24),
                  _tasksSection(controller, reminders),
                  const SizedBox(height: 24),
                  const TipCard(),
                  const SizedBox(height: 16),
                  _actionStrip(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Presets ───────────────────────────────────────────────
  Widget _presetsSection() {
    final presets = [
      ('☕', 'Agua café', 3),
      ('🍚', 'Arroz blanco', 15),
      ('🍲', 'Potaje', 35),
      ('🥚', 'Huevos mollet', 6),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Atajos de cocción', style: AppTypography.headlineSm),
            const Spacer(),
            Text(
              'Un toque',
              style: AppTypography.labelMd.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: presets
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: QuickPresetButton(
                      emoji: p.$1,
                      title: p.$2,
                      minutes: p.$3,
                      onTap: () => _openNewSheet(
                        presetTitle: p.$2,
                        presetMinutes: p.$3,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // ─── Tasks ─────────────────────────────────────────────────
  Widget _tasksSection(
    ReminderController controller,
    List<Reminder> reminders,
  ) {
    final activeReminders = reminders.where((r) => !r.isCompleted).toList();
    final completedReminders = reminders.where((r) => r.isCompleted).toList();

    if (activeReminders.isEmpty && completedReminders.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('En marcha', style: AppTypography.headlineMd),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerSubtle,
              borderRadius: AppRadius.brLg,
            ),
            child: Column(
              children: [
                const Icon(Icons.notifications_none, size: 40),
                const SizedBox(height: 8),
                Text(
                  'No hay recordatorios activos',
                  style: AppTypography.bodyMd,
                ),
                const SizedBox(height: 4),
                Text(
                  'Crea uno con el botón +',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final first = activeReminders.isEmpty ? null : activeReminders.first;
    final rest = activeReminders.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (first != null) ...[
          Row(
            children: [
              Text('En marcha', style: AppTypography.headlineMd),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: AppRadius.brFull,
                ),
                child: Text(
                  '${activeReminders.length} activos',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _openNewSheet(),
                icon: const Icon(
                  Icons.add_circle,
                  size: 18,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Nuevo',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _swipeable(
            first,
            HeroTimerCard(
              title: first.title,
              subtitle: 'Suena a las ${_formatTimeOfDay(first.scheduledTime)}',
              timeRemaining: _formatRemaining(first.scheduledTime),
              progress: _progress(first),
              isRunning: first.isActive,
              onToggle: () => controller.toggleReminder(first),
              onComplete: () => controller.completeReminder(first),
              onAddMinutes: (m) => controller.snoozeReminder(
                first,
                Duration(minutes: m),
              ),
              onOpenDetail: () => _openDetailSheet(first),
            ),
          ),
          const SizedBox(height: 12),
          ...rest.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _swipeable(
                r,
                GenericTaskCard(
                  icon: Icons.notifications_active,
                  title: r.title,
                  metaLabel: _formatTimeOfDay(r.scheduledTime),
                  categoryLabel: 'Recordatorio',
                  trailingTimer: _formatRemaining(r.scheduledTime),
                  progress: _progress(r),
                  footerLabel: 'Suena a las ${_formatTimeOfDay(r.scheduledTime)}',
                  iconBg: AppColors.tertiaryFixed,
                  iconColor: AppColors.onTertiaryFixed,
                  onAddMinutes: () => controller.snoozeReminder(r, const Duration(minutes: 5)),
                  onComplete: () => controller.completeReminder(r),
                  onTap: () => _openDetailSheet(r),
                ),
              ),
            ),
          ),
        ],
        if (completedReminders.isNotEmpty) ...[
          if (first != null) const SizedBox(height: 12),
          Text('Completadas', style: AppTypography.headlineMd),
          const SizedBox(height: 12),
          ...completedReminders.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _swipeable(
                r,
                CompletedTaskCard(
                  title: r.title,
                  completedAt: _formatTimeOfDay(
                    r.completedAt ?? r.scheduledTime,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _swipeable(Reminder reminder, Widget child) {
    return Dismissible(
      key: ValueKey('reminder-${reminder.id}'),
      direction: DismissDirection.horizontal,
      background: _swipeAction(
        color: AppColors.primary,
        icon: Icons.edit_outlined,
        label: 'Editar',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _swipeAction(
        color: AppColors.error,
        icon: Icons.delete_outline,
        label: 'Eliminar',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _openNewSheet(reminderToEdit: reminder);
          return false;
        }
        await context.read<ReminderController>().deleteReminder(reminder);
        return true;
      },
      child: child,
    );
  }

  Widget _swipeAction({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action strip ──────────────────────────────────────────
  Widget _actionStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => _openNewSheet(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.brFull),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.add_alarm, size: 18),
          label: Text(
            'Crear Recordatorio',
            style: AppTypography.bodySm.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: () {
            final reminders = context.read<ReminderController>().reminders;
            if (reminders.isNotEmpty) _openDetailSheet(reminders.first);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.surfaceContainerSubtle,
            foregroundColor: AppColors.textPrimary,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.brFull),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.visibility, size: 18),
          label: Text(
            'Ver Detalle',
            style: AppTypography.bodySm.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
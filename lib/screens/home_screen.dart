import 'dart:async';
import 'package:flutter/material.dart';
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
  int heroSeconds = 165; // 02:45
  bool heroRunning = true;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!heroRunning) return;
      if (heroSeconds > 0) setState(() => heroSeconds--);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _heroFormatted {
    final m = (heroSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (heroSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _heroProgress => (heroSeconds / 165).clamp(0.0, 1.0);

  void _openNewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (_) => const NewReminderSheet(),
    );
  }

  void _openDetailSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (_) => DetailSheet(
        title: 'Vigilar agua hirviendo para el café',
        note: 'Para colar la cafetera italiana moka.',
        timeRemaining: _heroFormatted,
        progress: _heroProgress,
        flameLabel: 'Fuego alto 🔥',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCanvas,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hola 👋', style: AppTypography.headlineMd),
            const SizedBox(width: 8),
            const StatusChip(
              label: '2 pendientes',
              variant: ChipVariant.urgent,
              pulse: true,
            ),
          ],
        ),
      ),
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16), // ← sube 16px
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.primaryHalo,
          ),
          child: FloatingActionButton(
            onPressed: _openNewSheet,
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
                  _tasksSection(),
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
                      onTap: _openNewSheet,
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
  Widget _tasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                '3 activos',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onPrimaryFixed,
                ),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _openNewSheet,
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
        HeroTimerCard(
          title: 'Agua hirviendo para el café',
          subtitle: 'Para colar la cafetera italiana moka',
          timeRemaining: _heroFormatted,
          progress: _heroProgress,
          isRunning: heroRunning,
          onToggle: () => setState(() => heroRunning = !heroRunning),
          onComplete: () {},
          onAddMinutes: (m) => setState(() => heroSeconds += m * 60),
          onOpenDetail: _openDetailSheet,
        ),
        const SizedBox(height: 12),
        GenericTaskCard(
          icon: Icons.soup_kitchen,
          title: 'Apagar olla del potaje',
          metaLabel: 'Fuego lento',
          categoryLabel: 'Cocina',
          trailingTimer: '18:10',
          progress: 0.45,
          footerLabel: 'Suena a las 1:18 PM',
          iconBg: AppColors.tertiaryFixed,
          iconColor: AppColors.onTertiaryFixed,
          onAddMinutes: () {},
          onComplete: () {},
          onTap: _openDetailSheet,
        ),
        const SizedBox(height: 12),
        GenericTaskCard(
          icon: Icons.six_k_plus_outlined,
          title: 'Bajar el fuego al arroz',
          metaLabel: '1:30 PM',
          categoryLabel: 'Cocina',
          iconBg: AppColors.surfaceContainerHighest,
          iconColor: AppColors.textSecondary,
          onComplete: () {},
          onTap: _openDetailSheet,
        ),
        const SizedBox(height: 12),
        GenericTaskCard(
          icon: Icons.ac_unit,
          title: 'Sacar el pollo de descongelar',
          metaLabel: 'Faltan 45m',
          categoryLabel: 'Hogar',
          iconBg: AppColors.surfaceContainerHighest,
          iconColor: AppColors.textSecondary,
          onComplete: () {},
          onTap: _openDetailSheet,
        ),
        const SizedBox(height: 12),
        const CompletedTaskCard(
          title: 'Cerrar la llave del gas',
          completedAt: '12:40 PM',
        ),
      ],
    );
  }

  // ─── Action strip ──────────────────────────────────────────
  Widget _actionStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _openNewSheet,
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
          onPressed: _openDetailSheet,
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

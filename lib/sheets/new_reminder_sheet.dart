import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../services/reminder_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class NewReminderSheet extends StatefulWidget {
  /// Si se pasa, el sheet entra en modo edición
  final Reminder? reminderToEdit;

  /// Valores iniciales opcionales (para presets desde HomeScreen)
  final String? initialTitle;
  final int? initialMinutes;

  const NewReminderSheet({
    super.key,
    this.reminderToEdit,
    this.initialTitle,
    this.initialMinutes,
  });

  @override
  State<NewReminderSheet> createState() => _NewReminderSheetState();
}

class _NewReminderSheetState extends State<NewReminderSheet> {
  late int duration;
  late int flameIndex;
  late final TextEditingController _titleCtrl;

  bool get _isEditing => widget.reminderToEdit != null;

  static const _flames = [('🔥', 'Alto'), ('🍳', 'Medio'), ('🍲', 'Lento')];

  static const _presets = [
    ('☕', 'Agua', 3, 'Fuego alto'),
    ('🍚', 'Arroz', 15, 'Fuego medio'),
    ('🍲', 'Potaje', 30, 'Fuego lento'),
  ];

  @override
  void initState() {
    super.initState();
    final edit = widget.reminderToEdit;

    if (edit != null) {
      // Modo edición: precargar todo desde el recordatorio existente
      _titleCtrl = TextEditingController(text: edit.title);
      final remaining = edit.scheduledTime.difference(DateTime.now()).inMinutes;
      duration = remaining > 0 ? remaining : 1;
      flameIndex = 0;
    } else {
      // Modo creación
      _titleCtrl = TextEditingController(
        text: widget.initialTitle ?? 'Vigilar punto de sal',
      );
      duration = widget.initialMinutes ?? 10;
      flameIndex = 0;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _applyPreset((String, String, int, String) p) {
    setState(() {
      _titleCtrl.text = p.$2;
      duration = p.$3;
      flameIndex = p.$4.contains('alto')
          ? 0
          : p.$4.contains('medio')
          ? 1
          : 2;
    });
  }

  String get _formattedDuration {
    if (duration < 60) return '$duration';
    final hours = duration ~/ 60;
    final mins = duration % 60;
    return mins == 0 ? '${hours}h' : '${hours}h ${mins}m';
  }

  // ─── Guardar / actualizar ──────────────────────────────────
  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ponle un nombre al recordatorio')),
      );
      return;
    }

    final controller = context.read<ReminderController>();
    final navigator = Navigator.of(context);

    if (_isEditing) {
      await controller.updateReminder(
        widget.reminderToEdit!,
        title: title,
        duration: Duration(minutes: duration),
      );
    } else {
      await controller.addReminder(
        title: title,
        duration: Duration(minutes: duration),
      );
    }

    if (mounted) navigator.pop();
  }

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
          // Grab handle
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Editar Recordatorio' : 'Nuevo Recordatorio',
                        style: AppTypography.headlineMd,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEditing
                            ? 'Ajusta los detalles'
                            : 'Cocina y labores del hogar',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _closeBtn(),
              ],
            ),
          ),
          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('ATAJOS RÁPIDOS'),
                  const SizedBox(height: 8),
                  Row(
                    children: _presets.map((p) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: p == _presets.last ? 0 : 8,
                          ),
                          child: _presetTile(p),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('NOMBRE DE LA TAREA'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleCtrl,
                    style: AppTypography.bodyMd,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.edit_note,
                        color: AppColors.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceContainerSubtle,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.brLg,
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.brLg,
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('DURACIÓN DEL TEMPORIZADOR'),
                  const SizedBox(height: 8),
                  _durationPanel(),
                  const SizedBox(height: 16),
                  _sectionLabel('NIVEL DE FUEGO / CATEGORÍA'),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(_flames.length, (i) {
                      final active = i == flameIndex;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == _flames.length - 1 ? 0 : 8,
                          ),
                          child: GestureDetector(
                            onTap: () => setState(() => flameIndex = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primaryFixed
                                    : AppColors.surfaceContainerSubtle,
                                borderRadius: AppRadius.brLg,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_flames[i].$1),
                                  const SizedBox(width: 6),
                                  Text(
                                    _flames[i].$2,
                                    style: AppTypography.bodySm.copyWith(
                                      fontWeight: active
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: active
                                          ? AppColors.onPrimaryFixed
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brLg,
                        ),
                      ),
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.timer,
                        size: 22,
                      ),
                      label: Text(
                        _isEditing ? 'Guardar Cambios' : 'Iniciar Recordatorio',
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                        ),
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

  Widget _closeBtn() => Material(
    color: AppColors.surfaceContainerSubtle,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: () => Navigator.pop(context),
      customBorder: const CircleBorder(),
      child: const SizedBox(
        width: 36,
        height: 36,
        child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
      ),
    ),
  );

  Widget _sectionLabel(String t) => Text(
    t,
    style: AppTypography.labelMd.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.08,
      color: AppColors.textSecondary,
    ),
  );

  Widget _presetTile((String, String, int, String) p) {
    return GestureDetector(
      onTap: () => _applyPreset(p),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerSubtle,
          borderRadius: AppRadius.brLg,
        ),
        child: Column(
          children: [
            Text(p.$1, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              p.$2,
              style: AppTypography.bodySm.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${p.$3} min',
              style: AppTypography.labelMd.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerSubtle,
        borderRadius: AppRadius.brLg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formattedDuration,
                style: AppTypography.timerDisplayMobile.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text('minutos', style: AppTypography.headlineSm),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepBtn(
                '−10m',
                () => setState(() => duration = (duration - 10).clamp(1, 999)),
              ),
              const SizedBox(width: 4),
              _stepBtn(
                '−5m',
                () => setState(() => duration = (duration - 5).clamp(1, 999)),
              ),
              const SizedBox(width: 4),
              _roundStep(
                '−',
                () => setState(() => duration = (duration - 1).clamp(1, 999)),
              ),
              const SizedBox(width: 4),
              _roundStep('+', () => setState(() => duration++)),
              const SizedBox(width: 4),
              _stepBtn('+5m', () => setState(() => duration += 5)),
              const SizedBox(width: 4),
              _stepBtn('+10m', () => setState(() => duration += 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(String label, VoidCallback onTap) {
    return Material(
      color: AppColors.surfaceContainerHighest,
      borderRadius: AppRadius.brBase,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.brBase,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            label,
            style: AppTypography.labelMd.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _roundStep(String label, VoidCallback onTap) {
    return Material(
      color: AppColors.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
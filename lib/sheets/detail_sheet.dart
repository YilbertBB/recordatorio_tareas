// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';
// import '../models/reminder.dart';
// import '../services/reminder_controller.dart';
// import '../theme/app_colors.dart';
// import '../theme/app_radius.dart';
// import '../theme/app_typography.dart';
// import 'new_reminder_sheet.dart';

// class DetailSheet extends StatefulWidget {
//   final Reminder reminder;

//   const DetailSheet({super.key, required this.reminder});

//   @override
//   State<DetailSheet> createState() => _DetailSheetState();
// }

// class _DetailSheetState extends State<DetailSheet> {
//   Timer? _ticker;

//   Reminder get reminder => widget.reminder;

//   @override
//   void initState() {
//     super.initState();
//     _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _ticker?.cancel();
//     super.dispose();
//   }

//   // ─── Helpers ───────────────────────────────────────────────
//   String get _timeRemaining {
//     final diff = reminder.scheduledTime.difference(DateTime.now());
//     if (diff.isNegative) return '00:00';
//     final m = diff.inMinutes.toString().padLeft(2, '0');
//     final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   double get _progress {
//     final total = reminder.scheduledTime.difference(DateTime.now()).inSeconds;
//     if (total <= 0) return 0.0;
//     return (total / 3600).clamp(0.0, 1.0);
//   }

//   String _formatTime(DateTime dt) {
//     final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
//     final m = dt.minute.toString().padLeft(2, '0');
//     final ampm = dt.hour >= 12 ? 'PM' : 'AM';
//     return '$h:$m $ampm';
//   }

//   String get _startTimeLabel {
//     // Estimamos la hora de inicio como (alarma - duración original).
//     // Como no guardamos la duración original, usamos la hora actual como referencia.
//     return _formatTime(DateTime.now());
//   }

//   // ─── Acciones ──────────────────────────────────────────────
//   void _postpone(BuildContext context, int minutes) {
//     final controller = context.read<ReminderController>();
//     controller.snoozeReminder(reminder, Duration(minutes: minutes));
//     Navigator.pop(context);
//   }

//   void _complete(BuildContext context) {
//     final controller = context.read<ReminderController>();
//     controller.completeReminder(reminder);
//     Navigator.pop(context);
//   }

//   void _delete(BuildContext context) {
//     final controller = context.read<ReminderController>();
//     controller.deleteReminder(reminder);
//     Navigator.pop(context);
//   }

//   void _edit(BuildContext context) {
//     Navigator.pop(context);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: AppColors.scrim,
//       builder: (_) => NewReminderSheet(reminderToEdit: reminder),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: AppRadius.brSheetTop,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Grab handle
//           Padding(
//             padding: const EdgeInsets.only(top: 10, bottom: 6),
//             child: Container(
//               width: 36,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD6CEBE),
//                 borderRadius: AppRadius.brFull,
//               ),
//             ),
//           ),
//           // Header con chip y botón de editar
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.errorContainer,
//                     borderRadius: AppRadius.brFull,
//                   ),
//                   child: Text(
//                     'URGENTE',
//                     style: AppTypography.labelMd.copyWith(
//                       color: AppColors.onErrorContainer,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '🔥 Fuego alto',
//                   style: AppTypography.bodySm.copyWith(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Spacer(),
//                 // Botón editar (nuevo)
//                 Material(
//                   color: AppColors.surfaceContainerLowest,
//                   shape: const CircleBorder(),
//                   child: InkWell(
//                     onTap: () => _edit(context),
//                     customBorder: const CircleBorder(),
//                     child: const SizedBox(
//                       width: 36,
//                       height: 36,
//                       child: Icon(
//                         Icons.edit_outlined,
//                         size: 18,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Material(
//                   color: AppColors.surfaceContainerLowest,
//                   shape: const CircleBorder(),
//                   child: InkWell(
//                     onTap: () => Navigator.pop(context),
//                     customBorder: const CircleBorder(),
//                     child: const SizedBox(
//                       width: 36,
//                       height: 36,
//                       child: Icon(
//                         Icons.close,
//                         size: 20,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Body
//           Flexible(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
//               child: Column(
//                 children: [
//                   Text(
//                     reminder.title,
//                     textAlign: TextAlign.center,
//                     style: AppTypography.headlineLg,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Programado para ${_formatTime(reminder.scheduledTime)}',
//                     textAlign: TextAlign.center,
//                     style: AppTypography.bodyMd.copyWith(
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Anillo de progreso
//                   SizedBox(
//                     width: 210,
//                     height: 210,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(
//                           width: 210,
//                           height: 210,
//                           child: CircularProgressIndicator(
//                             value: _progress,
//                             strokeWidth: 8,
//                             backgroundColor: AppColors.surfaceContainerHighest,
//                             valueColor: const AlwaysStoppedAnimation(
//                               AppColors.primary,
//                             ),
//                             strokeCap: StrokeCap.round,
//                           ),
//                         ),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'RESTANTE',
//                               style: AppTypography.labelMd.copyWith(
//                                 color: AppColors.textTertiary,
//                                 letterSpacing: 0.08,
//                               ),
//                             ),
//                             Text(
//                               _timeRemaining,
//                               style: AppTypography.timerDisplayMobile,
//                             ),
//                             Text(
//                               'En progreso',
//                               style: AppTypography.bodySm.copyWith(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Meta info
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: AppColors.surfaceContainerLowest,
//                       borderRadius: AppRadius.brLg,
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _meta(
//                             'Creado',
//                             _startTimeLabel,
//                             AppColors.textPrimary,
//                           ),
//                         ),
//                         Expanded(
//                           child: _meta(
//                             'Alarma',
//                             _formatTime(reminder.scheduledTime),
//                             AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Snooze
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryFixed.withValues(alpha: 0.5),
//                       borderRadius: AppRadius.brLg,
//                       border: Border.all(
//                         color: AppColors.outlineVariant.withValues(alpha: 0.5),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 36,
//                           height: 36,
//                           decoration: const BoxDecoration(
//                             color: AppColors.primary,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.snooze,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'POSPONER AVISO',
//                                 style: AppTypography.labelMd.copyWith(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 0.06,
//                                 ),
//                               ),
//                               Text(
//                                 'Recordarme más tarde',
//                                 style: AppTypography.bodySm.copyWith(
//                                   color: AppColors.onPrimaryFixed.withValues(
//                                     alpha: 0.8,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: () => _postpone(context, 2),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             foregroundColor: Colors.white,
//                             elevation: 0,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 10,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: AppRadius.brBase,
//                             ),
//                           ),
//                           icon: const Icon(Icons.alarm_on, size: 16),
//                           label: Text(
//                             '+2 min',
//                             style: AppTypography.labelMd.copyWith(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Acciones rápidas
//                   Row(
//                     children: [
//                       _ghost(
//                         '+5m',
//                         Icons.more_time,
//                         () => _postpone(context, 5),
//                       ),
//                       const SizedBox(width: 8),
//                       _ghost(
//                         '+10m',
//                         Icons.timer,
//                         () => _postpone(context, 10),
//                       ),
//                       const SizedBox(width: 8),
//                       _ghost(
//                         '+10m',
//                         Icons.restart_alt,
//                         () => _postpone(context, 10),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Botón completar
//                   SizedBox(
//                     width: double.infinity,
//                     height: 54,
//                     child: ElevatedButton.icon(
//                       onPressed: () => _complete(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.secondary,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: AppRadius.brLg,
//                         ),
//                       ),
//                       icon: const Icon(Icons.task_alt, size: 22),
//                       label: Text(
//                         'Marcar como Completada',
//                         style: AppTypography.headlineSm.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Eliminar
//                   TextButton.icon(
//                     onPressed: () => _delete(context),
//                     icon: const Icon(
//                       Icons.delete_outline,
//                       size: 18,
//                       color: AppColors.error,
//                     ),
//                     label: Text(
//                       'Eliminar este recordatorio',
//                       style: AppTypography.bodySm.copyWith(
//                         color: AppColors.error,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _meta(String label, String value, Color valueColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: AppTypography.labelMd.copyWith(color: AppColors.textTertiary),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: AppTypography.bodyMd.copyWith(
//             color: valueColor,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _ghost(String label, IconData icon, VoidCallback onTap) {
//     return Expanded(
//       child: Material(
//         color: AppColors.surfaceContainerLowest,
//         borderRadius: AppRadius.brMd,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: AppRadius.brMd,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 16, color: AppColors.primary),
//                 const SizedBox(width: 4),
//                 Text(
//                   label,
//                   style: AppTypography.labelMd.copyWith(
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/reminder.dart';
import '../services/reminder_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'new_reminder_sheet.dart';

class DetailSheet extends StatefulWidget {
  final Reminder reminder;

  const DetailSheet({super.key, required this.reminder});

  @override
  State<DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<DetailSheet> {
  Timer? _ticker;

  Reminder get reminder => widget.reminder;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────
  String get _timeRemaining {
    final diff = reminder.scheduledTime.difference(DateTime.now());
    if (diff.isNegative) return '00:00';
    final m = diff.inMinutes.toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress {
    final total = reminder.scheduledTime.difference(DateTime.now()).inSeconds;
    if (total <= 0) return 0.0;
    return (total / 3600).clamp(0.0, 1.0);
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String get _startTimeLabel {
    return _formatTime(DateTime.now());
  }

  // ─── Acciones ──────────────────────────────────────────────
  void _postpone(BuildContext context, int minutes) {
    final controller = context.read<ReminderController>();
    controller.snoozeReminder(reminder, Duration(minutes: minutes));
    Navigator.pop(context);
  }

  void _complete(BuildContext context) {
    final controller = context.read<ReminderController>();
    controller.completeReminder(reminder);
    Navigator.pop(context);
  }

  void _delete(BuildContext context) {
    final controller = context.read<ReminderController>();
    controller.deleteReminder(reminder);
    Navigator.pop(context);
  }

  void _edit(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      builder: (_) => NewReminderSheet(reminderToEdit: reminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Surface 2 elevado — slate-2 en vez de blanco
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.brSheetTop,
        // Hairline superior translúcido
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
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
                color: AppColors.surfaceContainerHighest,
                borderRadius: AppRadius.brFull,
              ),
            ),
          ),
          // Header con chip y botón de editar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                // Chip "URGENTE" con translucent amber (DESIGN.md)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x26F97316), // rgba(249,115,22,0.15)
                    borderRadius: AppRadius.brFull,
                    border: Border.all(
                      color: const Color(0x4DFB923C),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'URGENTE',
                    style: AppTypography.labelMd.copyWith(
                      color: const Color(0xFFFB923C),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.06,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '🔥 Fuego alto',
                  style: AppTypography.bodySm.copyWith(
                    color: const Color(0xFFFB923C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Botón editar
                Material(
                  color: AppColors.surfaceContainerHigh,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _edit(context),
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xFFFB923C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Material(
                  color: AppColors.surfaceContainerHigh,
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
          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Text(
                    reminder.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLg,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Programado para ${_formatTime(reminder.scheduledTime)}',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Anillo de progreso
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
                            value: _progress,
                            strokeWidth: 8,
                            // Fondo del anillo en slate elevado
                            backgroundColor: AppColors.surfaceContainerHighest,
                            // Amber glow en el progreso
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFF97316),
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
                              _timeRemaining,
                              style: AppTypography.timerDisplayMobile.copyWith(
                                color: const Color(0xFFFB923C),
                              ),
                            ),
                            Text(
                              'En progreso',
                              style: AppTypography.bodySm.copyWith(
                                color: const Color(0xFFFB923C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Meta info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: AppRadius.brLg,
                      border: Border.all(
                        color: const Color(0xFF334155),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _meta(
                            'Creado',
                            _startTimeLabel,
                            AppColors.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: _meta(
                            'Alarma',
                            _formatTime(reminder.scheduledTime),
                            const Color(0xFFFB923C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Snooze — Translucent amber del DESIGN.md
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0x1AF97316), // rgba(249,115,22,0.1)
                      borderRadius: AppRadius.brLg,
                      border: Border.all(
                        color: const Color(0x66F97316),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF97316),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.snooze,
                            // Icono oscuro sobre amber para contraste
                            color: Color(0xFF020617),
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
                                  color: const Color(0xFFFB923C),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.06,
                                ),
                              ),
                              Text(
                                'Recordarme más tarde',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _postpone(context, 2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            // Texto slate-950 oscuro sobre amber
                            foregroundColor: const Color(0xFF020617),
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
                              color: const Color(0xFF020617),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Acciones rápidas
                  Row(
                    children: [
                      _ghost(
                        '+5m',
                        Icons.more_time,
                        () => _postpone(context, 5),
                      ),
                      const SizedBox(width: 8),
                      _ghost(
                        '+10m',
                        Icons.timer,
                        () => _postpone(context, 10),
                      ),
                      const SizedBox(width: 8),
                      _ghost(
                        '+10m',
                        Icons.restart_alt,
                        () => _postpone(context, 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Botón completar — Emerald (tertiary)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _complete(context),
                      style: ElevatedButton.styleFrom(
                        // Emerald del DESIGN.md
                        backgroundColor: AppColors.tertiaryContainer,
                        // Texto oscuro sobre emerald para contraste
                        foregroundColor: AppColors.onTertiary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brLg,
                        ),
                      ),
                      icon: const Icon(Icons.task_alt, size: 22),
                      label: Text(
                        'Marcar como Completada',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Eliminar
                  TextButton.icon(
                    onPressed: () => _delete(context),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Color(0xFFFFB4AB),
                    ),
                    label: Text(
                      'Eliminar este recordatorio',
                      style: AppTypography.bodySm.copyWith(
                        color: const Color(0xFFFFB4AB),
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

  Widget _ghost(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.brMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.brMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: const Color(0xFFFB923C)),
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
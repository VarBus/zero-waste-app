import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int mode = 0; 
  @override
  Widget build(BuildContext context) {
    final repo = context.read<ZeroWasteRepository>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text('Progress', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 6),
        Text(
          'Understand your habits and reduce waste.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        _Segment(
          value: mode,
          onChanged: (v) => setState(() => mode = v),
          left: 'Actions',
          right: 'Score',
        ),

        const SizedBox(height: 12),

        StreamBuilder(
          stream: repo.watchWasteSummary(),
          builder: (context, snap) {
            final s = snap.data;
            final consumed = s?.consumed ?? 0;
            final disposed = s?.disposed ?? 0;
            final total = consumed + disposed;
            final wasteRate = total == 0 ? 0 : ((disposed / total) * 100).round();

            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('This period', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _Kpi(title: 'Waste rate', value: '$wasteRate%')),
                            const SizedBox(width: 10),
                            Expanded(child: _Kpi(title: 'Saved', value: consumed.toString())),
                            const SizedBox(width: 10),
                            Expanded(child: _Kpi(title: 'Wasted', value: disposed.toString())),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _SplitBar(consumed: consumed, disposed: disposed),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (mode == 1)
                  FoodImpactRing(
                    consumed: consumed,
                    disposed: disposed,
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        if (mode == 0) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weekly actions', style: TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(
                    'Consumed vs disposed each day (based on when you marked it).',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder(
                    stream: repo.watchWeeklyTrend(days: 7),
                    builder: (context, snap) {
                      final points = snap.data ?? const <DailyWastePoint>[];
                      if (points.isEmpty) return const Text('No activity yet.');

                      final df = DateFormat.E();
                      return Column(
                        children: points.map((p) {
                          final day = df.format(p.day);
                          final total = p.consumed + p.disposed;
                          final wasteRatio = total == 0 ? 0.0 : p.disposed / total;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 34,
                                  child: Text(day, style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: total == 0 ? 0 : (1 - wasteRatio),
                                      minHeight: 10,
                                      backgroundColor: Colors.red.withOpacity(0.12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('${p.consumed}/${p.disposed}', style: const TextStyle(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Score shows how efficiently you consume items. Higher is better.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top waste reasons', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                  'Where waste comes from.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder(
                  stream: repo.watchTopDisposedReasons(limit: 6),
                  builder: (context, snap) {
                    final reasons = snap.data ?? const <DisposedReasonCount>[];
                    if (reasons.isEmpty) return const Text('No disposed items logged yet.');

                    return Column(
                      children: reasons.map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text(r.reason, style: const TextStyle(fontWeight: FontWeight.w800))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('${r.count}', style: const TextStyle(fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FoodImpactRing extends StatelessWidget {
  final int consumed;
  final int disposed;

  const FoodImpactRing({
    super.key,
    required this.consumed,
    required this.disposed,
  });

  @override
  Widget build(BuildContext context) {
    final total = consumed + disposed;
    final ratio = total == 0 ? 0.0 : consumed / total;
    final percent = (ratio * 100).round();

    final cs = Theme.of(context).colorScheme;

    final ringColor = percent >= 70
        ? Colors.green
        : percent >= 40
            ? Colors.orange
            : Colors.red;

    final label = percent >= 70
        ? 'Great'
        : percent >= 40
            ? 'Keep improving'
            : 'High waste';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Food efficiency', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(
              'Consumed / (Consumed + Wasted)',
              style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: ratio),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) {
                  return SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: v,
                          strokeWidth: 12,
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation(ringColor),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percent%',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                            ),
                            Text(label, style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(label: 'Consumed', value: consumed, color: Colors.green),
                _MiniStat(label: 'Wasted', value: disposed, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final String left;
  final String right;

  const _Segment({
    required this.value,
    required this.onChanged,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(child: _seg(cs, left, value == 0, () => onChanged(0))),
          const SizedBox(width: 6),
          Expanded(child: _seg(cs, right, value == 1, () => onChanged(1))),
        ],
      ),
    );
  }

  Widget _seg(ColorScheme cs, String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: selected ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title;
  final String value;

  const _Kpi({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}

class _SplitBar extends StatelessWidget {
  final int consumed;
  final int disposed;

  const _SplitBar({required this.consumed, required this.disposed});

  @override
  Widget build(BuildContext context) {
    final total = consumed + disposed;
    final consumedRatio = total == 0 ? 0.0 : consumed / total;
    final disposedRatio = total == 0 ? 0.0 : disposed / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            Expanded(
              flex: (consumedRatio * 1000).round().clamp(0, 1000),
              child: Container(color: Colors.green.withOpacity(0.85)),
            ),
            Expanded(
              flex: (disposedRatio * 1000).round().clamp(0, 1000),
              child: Container(color: Colors.red.withOpacity(0.85)),
            ),
            if (total == 0) Expanded(flex: 1000, child: Container(color: Colors.black12)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';

enum PlanMode { healthy, balanced, useUp }

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  int windowDays = 7;
  PlanMode mode = PlanMode.balanced;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ZeroWasteRepository>();
    final cs = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadline = today.add(Duration(days: windowDays == 0 ? 0 : windowDays));

    return StreamBuilder<List<WasteItem>>(
      stream: repo.watchItems(),
      builder: (context, snap) {
        final items = snap.data ?? const <WasteItem>[];

        final inWindow = items
            .where((i) => !i.expiresAt.isBefore(today) && !i.expiresAt.isAfter(deadline))
            .toList();

        final expired = items.where((i) => i.expiresAt.isBefore(today)).toList();

        final focusSections = _buildSections(inWindow, mode, today);
        final daily = _dailyFocus(inWindow, mode);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Best consumption plan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            Text(
              'Prioritized by expiry + your goal.',
              style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _PlanModeChips(
              value: mode,
              onChanged: (v) => setState(() => mode = v),
            ),

            const SizedBox(height: 10),

            _WindowChips(
              value: windowDays,
              onChanged: (v) => setState(() => windowDays = v),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily focus', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(
                      daily.subtitle,
                      style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: daily.pills.map((p) => _Pill(label: p)).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Focus list', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(
                      windowDays == 0 ? 'Consume today first.' : 'Consume within the next $windowDays days.',
                      style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    if (inWindow.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('No items in this window. Good job!', style: TextStyle(fontWeight: FontWeight.w800)),
                      )
                    else
                      ...focusSections.map((section) {
                        if (section.items.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _SectionBlock(
                            title: section.title,
                            subtitle: section.subtitle,
                            items: section.items,
                            today: today,
                            mode: mode,
                            onConsume: (it) => _consumeOne(context, repo, it),
                            onDispose: (it) => _disposeOne(context, repo, it),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (expired.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expired', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(
                        'Resolve these to keep your inventory accurate.',
                        style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ...expired
                          .map((i) => _PlanRow(
                                item: i,
                                label: 'Expired',
                                badgeTone: _BadgeTone.danger,
                                hint: 'Log it to learn and improve.',
                                onConsume: () => _consumeOne(context, repo, i),
                                onDispose: () => _disposeOne(context, repo, i),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: _MiniKpi(
                        title: 'Items in window',
                        value: inWindow.length.toString(),
                        icon: Icons.auto_awesome_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniKpi(
                        title: 'Expired',
                        value: expired.length.toString(),
                        icon: Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _consumeOne(BuildContext context, ZeroWasteRepository repo, WasteItem item) async {
    await repo.consumeOneUnit(item.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Consumed: ${item.name}')));
    }
  }

  Future<void> _disposeOne(BuildContext context, ZeroWasteRepository repo, WasteItem item) async {
    final reason = await _pickDisposeReason(context);
    if (reason == null) return;
    await repo.disposeOneUnit(item.id, reason: reason);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Disposed: ${item.name}')));
    }
  }

  Future<String?> _pickDisposeReason(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final reasons = <String>['Expired', 'Spoiled', 'Overbought', 'Forgotten', 'Cooking mistake'];
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reasons.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final r = reasons[i];
            return Card(
              child: ListTile(
                title: Text(r, style: const TextStyle(fontWeight: FontWeight.w800)),
                onTap: () => Navigator.of(ctx).pop(r),
              ),
            );
          },
        );
      },
    );
  }

  List<_SectionModel> _buildSections(List<WasteItem> items, PlanMode mode, DateTime today) {
    int urgency(DateTime d) {
      final dd = DateTime(d.year, d.month, d.day);
      final diff = dd.difference(today).inDays;
      if (diff < 0) return 1000;
      if (diff == 0) return 700;
      if (diff == 1) return 500;
      if (diff <= 3) return 250;
      if (diff <= 7) return 120;
      return 40;
    }

    int health(FoodGroup g) {
      switch (g) {
        case FoodGroup.vegetables:
          return 5;
        case FoodGroup.fruit:
          return 4;
        case FoodGroup.protein:
          return 4;
        case FoodGroup.grains:
          return 3;
        case FoodGroup.dairy:
          return 2;
        case FoodGroup.snack:
          return 0;
        case FoodGroup.other:
          return 1;
      }
    }

    int score(WasteItem i) {
      final base = urgency(i.expiresAt) + (10 + (i.quantity.clamp(1, 20) * 2));
      if (mode == PlanMode.useUp) return base;
      if (mode == PlanMode.balanced) return base + health(i.foodGroup) * 18;
      return base + health(i.foodGroup) * 32;
    }

    final sorted = [...items]..sort((a, b) => score(b).compareTo(score(a)));

    bool isHealthyGroup(FoodGroup g) =>
        g == FoodGroup.vegetables || g == FoodGroup.fruit || g == FoodGroup.protein;

    if (mode == PlanMode.healthy) {
      final healthy = sorted.where((i) => isHealthyGroup(i.foodGroup)).toList();
      final limit = sorted.where((i) => !isHealthyGroup(i.foodGroup)).toList();

      return [
        _SectionModel(
          title: 'Healthy first',
          subtitle: 'Prioritize these for better nutrition and less waste.',
          items: healthy,
        ),
        _SectionModel(
          title: 'Limit / occasional',
          subtitle: 'Consume only if needed (small portions).',
          items: limit,
        ),
      ];
    }

    if (mode == PlanMode.useUp) {
      return [
        _SectionModel(
          title: 'Use-up by expiry',
          subtitle: 'Everything sorted by urgency to avoid waste.',
          items: sorted,
        ),
      ];
    }

    final proteins = sorted.where((i) => i.foodGroup == FoodGroup.protein).toList();
    final vegetables = sorted.where((i) => i.foodGroup == FoodGroup.vegetables).toList();
    final fruits = sorted.where((i) => i.foodGroup == FoodGroup.fruit).toList();
    final grains = sorted.where((i) => i.foodGroup == FoodGroup.grains).toList();
    final dairy = sorted.where((i) => i.foodGroup == FoodGroup.dairy).toList();
    final snacks = sorted.where((i) => i.foodGroup == FoodGroup.snack).toList();
    final other = sorted.where((i) => i.foodGroup == FoodGroup.other).toList();

    return [
      _SectionModel(title: 'Proteins', subtitle: 'Build your meals around them.', items: proteins),
      _SectionModel(title: 'Vegetables', subtitle: 'Add volume and micronutrients.', items: vegetables),
      _SectionModel(title: 'Fruits', subtitle: 'Fiber + sweetness without junk.', items: fruits),
      _SectionModel(title: 'Grains', subtitle: 'Prefer whole grains when possible.', items: grains),
      _SectionModel(title: 'Dairy', subtitle: 'Good in moderation.', items: dairy),
      _SectionModel(title: 'Snacks', subtitle: 'Keep them controlled.', items: snacks),
      _SectionModel(title: 'Other', subtitle: 'Balance these with whole foods.', items: other),
    ];
  }

  _DailyFocus _dailyFocus(List<WasteItem> inWindow, PlanMode mode) {
    final byGroup = <FoodGroup, int>{};
    for (final it in inWindow) {
      byGroup[it.foodGroup] = (byGroup[it.foodGroup] ?? 0) + it.quantity;
    }
    final entries = byGroup.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return const _DailyFocus(
        subtitle: 'Nothing urgent today. Keep consistent with healthy choices.',
        pills: ['Hydrate', 'Protein', 'Vegetables'],
      );
    }

    final top = entries.take(3).map((e) => '${e.key.label} • ${e.value}').toList();

    final subtitle = mode == PlanMode.healthy
        ? 'Healthy mode: prioritize whole foods first.'
        : mode == PlanMode.balanced
            ? 'Balanced mode: mix your plate while using what you have.'
            : 'Use-up mode: eat by expiry to avoid waste.';

    return _DailyFocus(subtitle: subtitle, pills: top);
  }
}

class _SectionModel {
  final String title;
  final String subtitle;
  final List<WasteItem> items;
  const _SectionModel({required this.title, required this.subtitle, required this.items});
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<WasteItem> items;
  final DateTime today;
  final PlanMode mode;
  final void Function(WasteItem) onConsume;
  final void Function(WasteItem) onDispose;

  const _SectionBlock({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.today,
    required this.mode,
    required this.onConsume,
    required this.onDispose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(height: 10),
        ...items.take(8).map((i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PlanRow(
              item: i,
              label: _dueLabel(i.expiresAt, today),
              badgeTone: _badgeToneFor(i.expiresAt, today),
              hint: _hintFor(i.foodGroup, mode),
              onConsume: () => onConsume(i),
              onDispose: () => onDispose(i),
            ),
          );
        }).toList(),
      ],
    );
  }

  static String _dueLabel(DateTime expiresAt, DateTime today) {
    final d = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);
    final diff = d.difference(today).inDays;
    if (diff < 0) return 'Expired';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return 'In $diff days';
  }

  static _BadgeTone _badgeToneFor(DateTime expiresAt, DateTime today) {
    final d = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);
    final diff = d.difference(today).inDays;
    if (diff <= 0) return _BadgeTone.danger;
    if (diff <= 2) return _BadgeTone.warn;
    return _BadgeTone.ok;
  }

  static String _hintFor(FoodGroup g, PlanMode mode) {
    if (mode == PlanMode.useUp) return 'Use it before it expires.';
    if (mode == PlanMode.healthy) {
      switch (g) {
        case FoodGroup.vegetables:
          return 'Best daily base for meals.';
        case FoodGroup.fruit:
          return 'Great for fiber + vitamins.';
        case FoodGroup.protein:
          return 'Good for satiety and strength.';
        case FoodGroup.snack:
          return 'Limit and keep portions small.';
        case FoodGroup.grains:
          return 'Prefer whole grains if possible.';
        case FoodGroup.dairy:
          return 'Good in moderation.';
        case FoodGroup.other:
          return 'Balance with whole foods.';
      }
    }
    switch (g) {
      case FoodGroup.snack:
        return 'Keep it controlled.';
      default:
        return 'Balanced option for the week.';
    }
  }
}

class _DailyFocus {
  final String subtitle;
  final List<String> pills;
  const _DailyFocus({required this.subtitle, required this.pills});
}

class _PlanModeChips extends StatelessWidget {
  final PlanMode value;
  final ValueChanged<PlanMode> onChanged;

  const _PlanModeChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(context, 'Healthy', value == PlanMode.healthy, () => onChanged(PlanMode.healthy)),
        const SizedBox(width: 8),
        _chip(context, 'Balanced', value == PlanMode.balanced, () => onChanged(PlanMode.balanced)),
        const SizedBox(width: 8),
        _chip(context, 'Use-up', value == PlanMode.useUp, () => onChanged(PlanMode.useUp)),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected ? cs.primary : cs.surfaceContainerHighest.withOpacity(0.55),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: selected ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _WindowChips extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _WindowChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(context, 'Today', value == 0, () => onChanged(0)),
        const SizedBox(width: 8),
        _chip(context, '3 days', value == 3, () => onChanged(3)),
        const SizedBox(width: 8),
        _chip(context, '7 days', value == 7, () => onChanged(7)),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected ? cs.onSurface : cs.surfaceContainerHighest.withOpacity(0.55),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: selected ? cs.surface : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

enum _BadgeTone { ok, warn, danger }

class _PlanRow extends StatelessWidget {
  final WasteItem item;
  final String label;
  final _BadgeTone badgeTone;
  final String hint;
  final VoidCallback onConsume;
  final VoidCallback onDispose;

  const _PlanRow({
    required this.item,
    required this.label,
    required this.badgeTone,
    required this.hint,
    required this.onConsume,
    required this.onDispose,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d');
    final cs = Theme.of(context).colorScheme;

    final badgeBg = switch (badgeTone) {
      _BadgeTone.ok => Colors.green.withOpacity(0.14),
      _BadgeTone.warn => Colors.orange.withOpacity(0.16),
      _BadgeTone.danger => Colors.red.withOpacity(0.16),
    };

    final badgeFg = switch (badgeTone) {
      _BadgeTone.ok => Colors.green.shade800,
      _BadgeTone.warn => Colors.orange.shade800,
      _BadgeTone.danger => Colors.red.shade800,
    };

    return Card(
      child: ListTile(
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(
          '${item.foodGroup.label} • ${item.category} • qty ${item.quantity} • ${df.format(item.expiresAt)}\n$hint',
          style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
        ),
        trailing: Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: badgeBg,
              ),
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w900, color: badgeFg, fontSize: 12),
              ),
            ),
            IconButton(onPressed: onConsume, icon: const Icon(Icons.check_circle_outline)),
            IconButton(onPressed: onDispose, icon: const Icon(Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MiniKpi({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

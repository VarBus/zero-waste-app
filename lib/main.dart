import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/ui/theme.dart';

import 'features/items/data/local/app_database.dart';
import 'features/items/data/repositories/zero_waste_repository_impl.dart';
import 'features/items/domain/entities/food_group.dart';
import 'features/items/domain/repositories/zero_waste_repository.dart';

import 'features/items/presentation/bloc/items_bloc.dart';
import 'features/items/presentation/bloc/items_event.dart';

void main() {
  final db = AppDatabase();
  final repo = ZeroWasteRepositoryImpl(db);
  runApp(ZeroWasteApp(db: db, repo: repo));
}

class ZeroWasteApp extends StatefulWidget {
  final AppDatabase db;
  final ZeroWasteRepository repo;

  const ZeroWasteApp({super.key, required this.db, required this.repo});

  @override
  State<ZeroWasteApp> createState() => _ZeroWasteAppState();
}

class _ZeroWasteAppState extends State<ZeroWasteApp> {
  late final ItemsBloc itemsBloc;
  late final GoRouter router;

  @override
  void initState() {
    super.initState();

    itemsBloc = ItemsBloc(widget.repo);
    itemsBloc.add(const ItemsStarted());

    router = buildRouter(
      itemsBloc: itemsBloc,
      onFabCreate: () => _openCreateSheet(globalContext),
    );
  }

  BuildContext get globalContext => router.routerDelegate.navigatorKey.currentContext ?? context;

  @override
  void dispose() {
    itemsBloc.close();
    widget.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = MaterialTheme(ThemeData().textTheme);

    return RepositoryProvider<ZeroWasteRepository>.value(
      value: widget.repo,
      child: BlocProvider<ItemsBloc>.value(
        value: itemsBloc,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: appTheme.light(),
          darkTheme: appTheme.dark(),
          themeMode: ThemeMode.system,
          routerConfig: router,
        ),
      ),
    );
  }

  void _openCreateSheet(BuildContext context) {
    final name = TextEditingController();
    final category = TextEditingController(text: 'General');
    final qty = TextEditingController(text: '1');
    DateTime expiresAt = DateTime.now().add(const Duration(days: 7));
    FoodGroup group = FoodGroup.other;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Create item', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 10),
                  TextField(controller: category, decoration: const InputDecoration(labelText: 'Category')),
                  const SizedBox(height: 10),
                  TextField(
                    controller: qty,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Food group',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _FoodGroupChips(
                    value: group,
                    onChanged: (g) => setLocal(() => group = g),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.tonal(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: expiresAt,
                        );
                        if (picked != null) {
                          expiresAt = DateTime(picked.year, picked.month, picked.day);
                          setLocal(() {});
                        }
                      },
                      child: Text('Pick expiration date (${expiresAt.year}-${expiresAt.month}-${expiresAt.day})'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        final n = name.text.trim();
                        if (n.isEmpty) return;

                        final q = int.tryParse(qty.text.trim()) ?? 1;

                        context.read<ItemsBloc>().add(
                              ItemCreateRequested(
                                name: n,
                                category: category.text.trim().isEmpty ? 'General' : category.text.trim(),
                                quantity: q.clamp(1, 999999),
                                expiresAt: expiresAt,
                                foodGroup: group,
                              ),
                            );

                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Create'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FoodGroupChips extends StatelessWidget {
  final FoodGroup value;
  final ValueChanged<FoodGroup> onChanged;

  const _FoodGroupChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final entries = <FoodGroup>[
      FoodGroup.protein,
      FoodGroup.vegetables,
      FoodGroup.fruit,
      FoodGroup.dairy,
      FoodGroup.grains,
      FoodGroup.snack,
      FoodGroup.other,
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: entries.map((g) {
        final selected = g == value;
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onChanged(g),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: selected ? cs.primary.withOpacity(0.14) : cs.surfaceContainerHighest.withOpacity(0.55),
              border: Border.all(
                color: selected ? cs.primary.withOpacity(0.35) : Colors.transparent,
              ),
            ),
            child: Text(
              g.label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: selected ? cs.primary : cs.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

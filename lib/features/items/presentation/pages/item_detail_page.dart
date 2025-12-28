import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';
import 'package:zero_waste_app/features/items/presentation/detail_bloc/detail_bloc.dart';
import 'package:zero_waste_app/features/items/presentation/detail_bloc/detail_event.dart';
import 'package:zero_waste_app/features/items/presentation/detail_bloc/detail_state.dart';

class ItemDetailPage extends StatelessWidget {
  final int itemId;
  final bool showBack;

  const ItemDetailPage({super.key, required this.itemId, required this.showBack});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ZeroWasteRepository>();

    return BlocProvider(
      create: (_) => DetailBloc(repo)..add(DetailOpened(itemId)),
      child: BlocConsumer<DetailBloc, DetailState>(
        listenWhen: (p, c) => p.message != c.message && c.message != null,
        listener: (context, state) {
          final msg = state.message;
          if (msg != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        },
        builder: (context, state) {
          if (state.status == Status.loading && state.item == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = state.item;
          if (item == null) return const Center(child: Text('Item not found'));

          final content = _DetailForm(item: item);

          if (!showBack) return content;

          return Scaffold(
            appBar: AppBar(title: const Text('Item details')),
            body: SafeArea(child: content),
          );
        },
      ),
    );
  }
}

class _DetailForm extends StatefulWidget {
  final WasteItem item;
  const _DetailForm({required this.item});

  @override
  State<_DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<_DetailForm> {
  late final TextEditingController name;
  late final TextEditingController category;
  late final TextEditingController qty;
  DateTime? expiresAt;
  int? hydratedId;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    category = TextEditingController();
    qty = TextEditingController();
  }

  @override
  void dispose() {
    name.dispose();
    category.dispose();
    qty.dispose();
    super.dispose();
  }

  void hydrate(WasteItem item) {
    if (hydratedId == item.id) return;
    hydratedId = item.id;
    name.text = item.name;
    category.text = item.category;
    qty.text = item.quantity.toString();
    expiresAt = item.expiresAt;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    hydrate(item);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 10),
                TextField(controller: category, decoration: const InputDecoration(labelText: 'Category')),
                const SizedBox(height: 10),
                TextField(
                  controller: qty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.tonal(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        initialDate: expiresAt ?? item.expiresAt,
                      );
                      if (picked != null) {
                        setState(() => expiresAt = DateTime(picked.year, picked.month, picked.day));
                      }
                    },
                    child: const Text('Change expiration date'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      final updated = item.copyWith(
                        name: name.text.trim().isEmpty ? item.name : name.text.trim(),
                        category: category.text.trim().isEmpty ? 'General' : category.text.trim(),
                        quantity: (int.tryParse(qty.text.trim()) ?? item.quantity).clamp(1, 999999),
                        expiresAt: expiresAt ?? item.expiresAt,
                      );
                      context.read<DetailBloc>().add(DetailSaveRequested(updated));
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: FilledButton.tonalIcon(
            onPressed: () => context.read<DetailBloc>().add(const DetailConsumedRequested()),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Consumed (qty - 1)'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: FilledButton.tonalIcon(
            onPressed: () async {
              final reason = await _pickDisposeReason(context);
              if (!context.mounted) return;
              context.read<DetailBloc>().add(DetailDisposedRequested(reason));
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Disposed (qty - 1)'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: FilledButton.tonalIcon(
            onPressed: () => context.read<DetailBloc>().add(const DetailDeleteRequested()),
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('Delete item'),
          ),
        ),
      ],
    );
  }

  Future<String?> _pickDisposeReason(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final reasons = <String>[
          'Expired',
          'Spoiled',
          'Overbought',
          'Forgotten',
          'Cooking mistake',
        ];
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reasons.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            if (i == 0) return const Text('Why disposed?', style: TextStyle(fontWeight: FontWeight.w900));
            final r = reasons[i - 1];
            return Card(
              child: ListTile(
                title: Text(r),
                onTap: () => Navigator.of(ctx).pop(r),
              ),
            );
          },
        );
      },
    );
  }
}
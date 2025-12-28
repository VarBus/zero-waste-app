import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/core/utils/responsive.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_bloc.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_event.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_state.dart';
import 'package:zero_waste_app/features/items/presentation/pages/item_detail_page.dart';
import 'package:zero_waste_app/features/items/presentation/widgets/hero_header.dart';
import 'package:zero_waste_app/features/items/presentation/widgets/waste_bar.dart';

class ItemsPage extends StatelessWidget {
  final int? selectedId;
  const ItemsPage({super.key, required this.selectedId});

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(MediaQuery.of(context).size.width);

    return BlocConsumer<ItemsBloc, ItemsState>(
      listenWhen: (p, c) => p.message != c.message && c.message != null,
      listener: (context, state) {
        final msg = state.message;
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        if (state.status == Status.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: HeroHeader(
                expiringSoon: state.summary.expiringSoon,
                expired: state.summary.expired,
                consumed: state.summary.consumed,
                disposed: state.summary.disposed,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                onChanged: (v) => context.read<ItemsBloc>().add(ItemsQueryChanged(v)),
                decoration: const InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WasteBar(consumed: state.summary.consumed, disposed: state.summary.disposed),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: state.items.isEmpty
                  ? const Center(child: Text('No items yet. Tap + to add one.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final item = state.items[i];

                        final now = DateTime.now();
                        final expired = item.expiresAt.isBefore(now);
                        final soon = !expired && item.expiresAt.isBefore(now.add(const Duration(days: 7)));

                        final badgeText = expired ? 'Expired' : (soon ? 'Soon' : 'Ok');
                        final badgeColor = expired ? Colors.red : (soon ? Colors.orange : Colors.green);

                        return Card(
                          child: ListTile(
                            onTap: () => context.go('/items/${item.id}'),
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                            subtitle: Text('${item.category} • qty ${item.quantity}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                badgeText,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );

        if (!isWide) {
          if (selectedId != null) return ItemDetailPage(itemId: selectedId!, showBack: true);
          return list;
        }

        return Row(
          children: [
            Expanded(flex: 5, child: list),
            const SizedBox(width: 12),
            Expanded(
              flex: 6,
              child: Card(
                child: selectedId == null
                    ? const Center(child: Text('Select an item to see details'))
                    : ItemDetailPage(itemId: selectedId!, showBack: false),
              ),
            ),
          ],
        );
      },
    );
  }
}

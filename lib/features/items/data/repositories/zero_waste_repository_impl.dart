import 'package:drift/drift.dart';
import 'package:zero_waste_app/features/items/data/local/app_database.dart';
import 'package:zero_waste_app/features/items/data/mappers/zero_waste_mapper.dart';
import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_event.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';

class ZeroWasteRepositoryImpl implements ZeroWasteRepository {
  final AppDatabase db;

  ZeroWasteRepositoryImpl(this.db);

  @override
  Stream<List<WasteItem>> watchItems({String query = ''}) {
    return db.watchItemsRows(query: query).map((rows) => rows.map(ZeroWasteMapper.toItemEntity).toList());
  }

  @override
  Stream<WasteItem?> watchItemById(int id) {
    return db.watchItemRow(id).map((row) => row == null ? null : ZeroWasteMapper.toItemEntity(row));
  }

  @override
  Future<void> createItem({
    required String name,
    required String category,
    required int quantity,
    required DateTime expiresAt,
    required FoodGroup foodGroup,
  }) async {
    await db.insertItem(
      ZeroWasteMapper.toItemInsert(
        name: name,
        category: category,
        quantity: quantity,
        expiresAt: DateTime(expiresAt.year, expiresAt.month, expiresAt.day),
        foodGroup: foodGroup,
      ),
    );
  }

  @override
  Future<void> updateItem(WasteItem item) async {
    await db.updateItemRow(ZeroWasteMapper.toItemRowForUpdate(item));
  }

  @override
  Future<void> deleteItem(int id) async {
    await db.deleteItemById(id);
  }

  @override
  Future<void> consumeOneUnit(int itemId) async {
    await db.transaction(() async {
      final row = await db.getItemRow(itemId);
      if (row == null) return;

      final next = row.quantity - 1;

      if (next <= 0) {
        await db.deleteItemById(itemId);
      } else {
        await db.setItemQuantity(itemId, next);
      }

      await db.insertEvent(
        ZeroWasteMapper.toEventInsert(
          itemId: itemId,
          action: WasteAction.consumed,
          happenedAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> disposeOneUnit(int itemId, {required String reason}) async {
    await db.transaction(() async {
      final row = await db.getItemRow(itemId);
      if (row == null) return;

      final next = row.quantity - 1;

      if (next <= 0) {
        await db.deleteItemById(itemId);
      } else {
        await db.setItemQuantity(itemId, next);
      }

      await db.insertEvent(
        ZeroWasteMapper.toEventInsert(
          itemId: itemId,
          action: WasteAction.disposed,
          happenedAt: DateTime.now(),
          disposedReason: reason,
        ),
      );
    });
  }

  @override
  Stream<WasteSummary> watchWasteSummary() {
    return db.watchItemsRows().asyncMap((rows) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final expired = rows.where((r) => r.expiresAt.isBefore(today)).length;
      final expiringSoon = rows.where((r) {
        final d = r.expiresAt;
        return !d.isBefore(today) && d.isBefore(today.add(const Duration(days: 7)));
      }).length;

      final consumedExp = db.customSelect(
        'SELECT COUNT(*) AS c FROM waste_events WHERE action = ?',
        variables: [Variable.withInt(WasteAction.consumed.index)],
        readsFrom: {db.wasteEvents},
      );

      final disposedExp = db.customSelect(
        'SELECT COUNT(*) AS c FROM waste_events WHERE action = ?',
        variables: [Variable.withInt(WasteAction.disposed.index)],
        readsFrom: {db.wasteEvents},
      );

      final consumedRow = await consumedExp.getSingle();
      final disposedRow = await disposedExp.getSingle();

      return WasteSummary(
        expiringSoon: expiringSoon,
        expired: expired,
        consumed: consumedRow.read<int>('c'),
        disposed: disposedRow.read<int>('c'),
      );
    });
  }

  @override
  Stream<List<DailyWastePoint>> watchWeeklyTrend({int days = 7}) async* {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(Duration(days: days - 1));

    final q = db.select(db.wasteEvents)
      ..where((t) => t.happenedAt.isBetweenValues(start, today.add(const Duration(days: 1))));

    final rows = await q.get();

    final map = <DateTime, DailyWastePoint>{};
    for (int i = 0; i < days; i++) {
      final d = DateTime(start.year, start.month, start.day).add(Duration(days: i));
      map[d] = DailyWastePoint(day: d, consumed: 0, disposed: 0);
    }

    for (final r in rows) {
      final dt = r.happenedAt;
      final d = DateTime(dt.year, dt.month, dt.day);
      final p = map[d];
      if (p == null) continue;

      if (r.action == WasteAction.consumed.index) {
        map[d] = p.copyWith(consumed: p.consumed + 1);
      } else if (r.action == WasteAction.disposed.index) {
        map[d] = p.copyWith(disposed: p.disposed + 1);
      }
    }

    yield map.values.toList();
  }

  @override
  Stream<List<DisposedReasonCount>> watchTopDisposedReasons({int limit = 6}) async* {
    final exp = db.customSelect(
      '''
      SELECT COALESCE(disposed_reason, 'Unspecified') AS reason, COUNT(*) AS c
      FROM waste_events
      WHERE action = ?
      GROUP BY reason
      ORDER BY c DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withInt(WasteAction.disposed.index),
        Variable.withInt(limit),
      ],
      readsFrom: {db.wasteEvents},
    );

    final rows = await exp.get();
    yield rows
        .map((r) => DisposedReasonCount(reason: r.read<String>('reason'), count: r.read<int>('c')))
        .toList();
  }
}

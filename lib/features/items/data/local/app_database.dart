import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ItemRow')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant('General'))();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  DateTimeColumn get expiresAt => dateTime()();

  TextColumn get foodGroup => text().withDefault(const Constant('other'))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('WasteEventRow')
class WasteEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get action => integer()();
  DateTimeColumn get happenedAt => dateTime()();
  TextColumn get disposedReason => text().nullable()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'zerowaste.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Items, WasteEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(wasteEvents, wasteEvents.disposedReason);
          }
          if (from < 3) {
            await customStatement(
              "ALTER TABLE items ADD COLUMN food_group TEXT NOT NULL DEFAULT 'other'",
            );
          }
        },
      );

  Stream<List<ItemRow>> watchItemsRows({String query = ''}) {
    final q = select(items)..where((t) => t.quantity.isBiggerThanValue(0));

    if (query.trim().isNotEmpty) {
      final needle = '%${query.trim()}%';
      q.where((t) => t.name.like(needle) | t.category.like(needle) | t.foodGroup.like(needle));
    }

    q.orderBy([(t) => OrderingTerm(expression: t.expiresAt)]);
    return q.watch();
  }

  Stream<ItemRow?> watchItemRow(int id) {
    return (select(items)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<ItemRow?> getItemRow(int id) {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertItem(ItemsCompanion c) => into(items).insert(c);

  Future<void> updateItemRow(ItemRow row) => update(items).replace(row);

  Future<void> deleteItemById(int id) async {
    await (delete(wasteEvents)..where((e) => e.itemId.equals(id))).go();
    await (delete(items)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setItemQuantity(int id, int qty) async {
    final now = DateTime.now();
    await (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        quantity: Value(qty),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> insertEvent(WasteEventsCompanion c) => into(wasteEvents).insert(c);

  Stream<List<WasteEventRow>> watchEventsRows() {
    final q = select(wasteEvents);
    q.orderBy([(t) => OrderingTerm(expression: t.happenedAt, mode: OrderingMode.desc)]);
    return q.watch();
  }
}

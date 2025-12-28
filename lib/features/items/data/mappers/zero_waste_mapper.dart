import 'package:drift/drift.dart';
import 'package:zero_waste_app/features/items/data/local/app_database.dart';
import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_event.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';

class ZeroWasteMapper {
  static WasteItem toItemEntity(ItemRow row) {
    return WasteItem(
      id: row.id,
      name: row.name,
      category: row.category,
      quantity: row.quantity,
      expiresAt: row.expiresAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      foodGroup: FoodGroup.fromKey(row.foodGroup),
    );
  }

  static ItemsCompanion toItemInsert({
    required String name,
    required String category,
    required int quantity,
    required DateTime expiresAt,
    required FoodGroup foodGroup,
  }) {
    final now = DateTime.now();
    return ItemsCompanion.insert(
      name: name,
      category: Value(category),
      quantity: Value(quantity),
      expiresAt: expiresAt,
      foodGroup: Value(foodGroup.key),
      createdAt: now,
      updatedAt: now,
    );
  }

  static ItemRow toItemRowForUpdate(WasteItem item) {
    return ItemRow(
      id: item.id,
      name: item.name,
      category: item.category,
      quantity: item.quantity,
      expiresAt: item.expiresAt,
      foodGroup: item.foodGroup.key,
      createdAt: item.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  static WasteEventsCompanion toEventInsert({
    required int itemId,
    required WasteAction action,
    required DateTime happenedAt,
    String? disposedReason,
  }) {
    return WasteEventsCompanion.insert(
      itemId: itemId,
      action: action.index,
      happenedAt: happenedAt,
      disposedReason: Value(disposedReason),
    );
  }
}

import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';

class WasteSummary {
  final int expiringSoon;
  final int expired;
  final int consumed;
  final int disposed;

  const WasteSummary({
    required this.expiringSoon,
    required this.expired,
    required this.consumed,
    required this.disposed,
  });
}

class DailyWastePoint {
  final DateTime day;
  final int consumed;
  final int disposed;

  const DailyWastePoint({
    required this.day,
    required this.consumed,
    required this.disposed,
  });

  DailyWastePoint copyWith({int? consumed, int? disposed}) {
    return DailyWastePoint(
      day: day,
      consumed: consumed ?? this.consumed,
      disposed: disposed ?? this.disposed,
    );
  }
}

class DisposedReasonCount {
  final String reason;
  final int count;

  const DisposedReasonCount({required this.reason, required this.count});
}

abstract class ZeroWasteRepository {
  Stream<List<WasteItem>> watchItems({String query});

  Stream<WasteItem?> watchItemById(int id);

  Future<void> createItem({
    required String name,
    required String category,
    required int quantity,
    required DateTime expiresAt,
    required FoodGroup foodGroup,
  });

  Future<void> updateItem(WasteItem item);
  Future<void> deleteItem(int id);

  Future<void> consumeOneUnit(int itemId);
  Future<void> disposeOneUnit(int itemId, {required String reason});

  Stream<WasteSummary> watchWasteSummary();
  Stream<List<DailyWastePoint>> watchWeeklyTrend({int days});
  Stream<List<DisposedReasonCount>> watchTopDisposedReasons({int limit});
}

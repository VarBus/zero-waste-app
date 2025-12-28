import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';

sealed class ItemsEvent {
  const ItemsEvent();
}

class ItemsStarted extends ItemsEvent {
  const ItemsStarted();
}

class ItemsQueryChanged extends ItemsEvent {
  final String query;
  const ItemsQueryChanged(this.query);
}

class ItemsArrived extends ItemsEvent {
  final List items;
  const ItemsArrived(this.items);
}

class SummaryArrived extends ItemsEvent {
  final dynamic summary;
  const SummaryArrived(this.summary);
}

class ItemCreateRequested extends ItemsEvent {
  final String name;
  final String category;
  final int quantity;
  final DateTime expiresAt;
  final FoodGroup foodGroup;

  const ItemCreateRequested({
    required this.name,
    required this.category,
    required this.quantity,
    required this.expiresAt,
    required this.foodGroup,
  });
}

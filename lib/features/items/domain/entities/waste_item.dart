import 'package:zero_waste_app/features/items/domain/entities/food_group.dart';

class WasteItem {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FoodGroup foodGroup;

  const WasteItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    required this.foodGroup,
  });

  WasteItem copyWith({
    String? name,
    String? category,
    int? quantity,
    DateTime? expiresAt,
    DateTime? updatedAt,
    FoodGroup? foodGroup,
  }) {
    return WasteItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      foodGroup: foodGroup ?? this.foodGroup,
    );
  }
}

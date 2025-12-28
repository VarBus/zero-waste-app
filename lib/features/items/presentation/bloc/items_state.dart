import 'package:equatable/equatable.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';

class ItemsState extends Equatable {
  final Status status;
  final String query;
  final List<WasteItem> items;
  final WasteSummary summary;
  final String? message;

  const ItemsState({
    required this.status,
    required this.query,
    required this.items,
    required this.summary,
    required this.message,
  });

  factory ItemsState.initial() => ItemsState(
        status: Status.initial,
        query: '',
        items: const [],
        summary: const WasteSummary(expiringSoon: 0, expired: 0, consumed: 0, disposed: 0),
        message: null,
      );

  ItemsState copyWith({
    Status? status,
    String? query,
    List<WasteItem>? items,
    WasteSummary? summary,
    String? message,
  }) {
    return ItemsState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, query, items, summary, message];
}
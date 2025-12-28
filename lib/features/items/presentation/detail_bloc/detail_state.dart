import 'package:equatable/equatable.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';

class DetailState extends Equatable {
  final Status status;
  final WasteItem? item;
  final String? message;

  const DetailState({
    required this.status,
    required this.item,
    required this.message,
  });
  factory DetailState.initial() => DetailState(
        status: Status.initial,
        item: null,
        message: null,
      );
  DetailState copyWith({
    Status? status,
    WasteItem? item,
    String? message,
  }) {
    return DetailState(
      status: status ?? this.status,
      item: item ?? this.item,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, item, message];
}
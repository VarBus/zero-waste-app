import 'package:zero_waste_app/features/items/domain/entities/waste_event.dart';

class WasteActivity {
  final WasteEvent event;
  final String itemName;

  const WasteActivity({
    required this.event,
    required this.itemName,
  });
}
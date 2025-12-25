enum ItemType { hat, outfit, accessory }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final ItemType type;
  final int requiredLevel;
  bool owned;
  bool equipped;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    this.requiredLevel = 0,
    this.owned = false,
    this.equipped = false,
  });
}

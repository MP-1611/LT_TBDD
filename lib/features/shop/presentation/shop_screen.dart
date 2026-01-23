import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/firebase_user_repository.dart';
import '../../profile/data/player_progress_service.dart';
import '../models/shop_item.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int userDrops = 1250;
  int userLevel = 12;
  final _userRepo = FirebaseUserRepository();
  final _progressService = PlayerProgressService();

  String name = "";
  int weight = 0;
  String wakeUp = "";
  int dailyGoal = 0;
  String? avatarUrl;

  int streak = 0;
  int totalIntake = 0;

  int level = 1;
  int xp = 0;
  int xpToNext = 100;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadshop();
  }
  Future<void> _loadshop() async {
    final data = await _userRepo.fetchUserData();

    if (data == null) {
      setState(() => loading = false);
      return;
    }

    final profile = data['profile'] ?? {};
    final water = data['water'] ?? {};
    final stats = data['stats'] ?? {};
    final progress = await _progressService.getProgress();

    setState(() {
      name = profile['name'] ?? "User";
      weight = profile['weight'] ?? 0;
      wakeUp = profile['wakeUp'] ?? "--:--";
      dailyGoal = water['dailyGoal'] ?? 0;
      avatarUrl = profile['avatar'];


      streak = stats['streak'] ?? 0;
      totalIntake = stats['totalIntake'] ?? 0;

      // 🔥 QUAN TRỌNG: level là INT, KHÔNG phải map
      level = progress['level']!;
      xp = progress['xp']!;
      xpToNext = progress['xpToNext']!;
      loading = false;
    });
  }

  ItemType selectedFilter = ItemType.hat;

  final List<ShopItem> items = [
    ShopItem(
      id: "hat_blue",
      name: "Mũ Xô Xanh",
      description: "Sành điệu & Mát mẻ",
      price: 0,
      type: ItemType.hat,
      owned: true,
      equipped: true,
    ),
    ShopItem(
      id: "glasses",
      name: "Kính Mát",
      description: "Tăng độ ngầu +10",
      price: 200,
      type: ItemType.accessory,
    ),
    ShopItem(
      id: "scarf",
      name: "Khăn Len Đỏ",
      description: "Ấm áp mùa đông",
      price: 150,
      type: ItemType.outfit,
    ),
    ShopItem(
      id: "crown",
      name: "Vương Miện",
      description: "Cần Level 20",
      price: 0,
      type: ItemType.accessory,
      requiredLevel: 20,
    ),
    ShopItem(
      id: "headphone",
      name: "Tai Nghe",
      description: "Âm nhạc là đời",
      price: 300,
      type: ItemType.accessory,
    ),
    ShopItem(
      id: "bowtie",
      name: "Nơ Cổ",
      description: "Lịch lãm",
      price: 0,
      type: ItemType.accessory,
      owned: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = items
        .where((e) => selectedFilter == e.type)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _characterStage(),
            _filterTabs(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (_, i) => _itemCard(filteredItems[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home), // ⬅️ BACK HOME
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Cửa hàng phần thưởng",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF36E27B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  userDrops.toString(),
                  style: const TextStyle(
                      color: Color(0xFF36E27B),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.water_drop,
                    size: 16, color: Color(0xFF36E27B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterStage() {
    return Column(
      children: [
        Container(
          height: 180,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF36E27B).withOpacity(0.2),
                ),
              ),
              Image.asset(
                "assets/images/mascot.png",
                width: 120,
              ),
            ],
          ),
        ),
        Text(
          "$level • Hydration Hero",
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  Widget _filterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filter(ItemType.hat, "Mũ nón"),
          _filter(ItemType.outfit, "Trang phục"),
          _filter(ItemType.accessory, "Phụ kiện"),
        ],
      ),
    );
  }

  Widget _filter(ItemType type, String text) {
    final active = selectedFilter == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = type),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 40,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF36E27B) : Colors.white10,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemCard(ShopItem item) {
    final locked = userLevel < item.requiredLevel;
    final canBuy = userDrops >= item.price;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(20),
        border: item.equipped
            ? Border.all(color: const Color(0xFF36E27B), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Icon(Icons.shopping_bag,
                  size: 48, color: Colors.white24),
            ),
          ),
          Text(
            item.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            item.description,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 8),
          if (locked)
            _lockedButton(item)
          else if (item.owned)
            _equipButton(item)
          else
            _buyButton(item, canBuy),
        ],
      ),
    );
  }

  Widget _buyButton(ShopItem item, bool canBuy) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        canBuy ? const Color(0xFF36E27B) : Colors.white24,
        minimumSize: const Size.fromHeight(36),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: canBuy
          ? () {
        setState(() {
          userDrops -= item.price;
          item.owned = true;
        });
      }
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.price.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.water_drop, size: 16, color: Colors.black),
        ],
      ),
    );
  }

  Widget _equipButton(ShopItem item) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: item.equipped
            ? Colors.white10
            : const Color(0xFF36E27B),
        minimumSize: const Size.fromHeight(36),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() {
          for (final i in items) {
            if (i.type == item.type) i.equipped = false;
          }
          item.equipped = true;
        });
      },
      child: Text(
        item.equipped ? "Đang dùng" : "Trang bị",
        style: TextStyle(
          color: item.equipped ? Colors.white54 : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _lockedButton(ShopItem item) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Cần Level ${item.requiredLevel}",
        style: const TextStyle(color: Colors.white38),
      ),
    );
  }
}

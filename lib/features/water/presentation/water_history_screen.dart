import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/water_log_model.dart';
import '../data/water_log_repository.dart';

enum HistoryTab { day, week, month }
int totalAmount(List<WaterLog> logs) =>
    logs.fold(0, (sum, e) => sum + e.amount);
class WaterHistoryScreen extends StatefulWidget {
  const WaterHistoryScreen({super.key});

  @override
  State<WaterHistoryScreen> createState() => _WaterHistoryScreenState();
}

class _WaterHistoryScreenState extends State<WaterHistoryScreen> {
  final _repo = WaterLogRepository();
  HistoryTab _tab = HistoryTab.day;
  DateTime _selectedDate = DateTime.now();

  // -------- STREAM THEO TAB --------
  Stream<List<WaterLog>> get _logsStream {
    switch (_tab) {
      case HistoryTab.week:
        return _repo.getByWeek(_selectedDate);
      case HistoryTab.month:
        return _repo.getByMonth(_selectedDate);
      default:
        return _repo.getByDay(_selectedDate);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF36E27B),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // TODO: thêm log thủ công
        },
      ),

      body: SafeArea(
        child: StreamBuilder<List<WaterLog>>(
          stream: _logsStream,
          builder: (context, snapshot) {

            // ⏳ LOADING
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF36E27B)),
              );
            }

            // ❌ ERROR
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(), // 👈 xem lỗi thật
                  style: TextStyle(color: Colors.red.shade300),
                  textAlign: TextAlign.center,
                ),
              );
            }


            final logs = snapshot.data ?? [];
            final total = totalAmount(logs);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// APP BAR
                  _appBar(context),
                  const SizedBox(height: 16),

                  /// TABS
                  _tabs(),
                  const SizedBox(height: 16),

                  /// DATE SELECTOR
                  _dateSelector(),
                  const SizedBox(height: 20),

                  /// SUMMARY
                  _summaryCard(total),
                  const SizedBox(height: 20),

                  /// STATS
                  _statsRow(total),
                  const SizedBox(height: 24),

                  /// DETAILS TITLE
                  _todayTitle(),
                  const SizedBox(height: 12),

                  /// DETAILS LIST
                  if (logs.isEmpty)
                    const Center(
                      child: Text(
                        "Chưa có dữ liệu",
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  else
                    ...logs.map(_historyItemFromLog),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  // ================= UI =================

  Widget _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "Lịch sử uống nước",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Icon(Icons.more_vert, color: Colors.white),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          _tabItem("Ngày", HistoryTab.day),
          _tabItem("Tuần", HistoryTab.week),
          _tabItem("Tháng", HistoryTab.month),
        ],
      ),
    );
  }

  Widget _tabItem(String text, HistoryTab tab) {
    final active = _tab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = tab),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF36E27B) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.black : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateSelector() {
    final text = DateFormat('MMMM yyyy', 'vi').format(_selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white54),
          onPressed: () {
            setState(() {
              _selectedDate = _tab == HistoryTab.day
                  ? _selectedDate.subtract(const Duration(days: 1))
                  : DateTime(_selectedDate.year, _selectedDate.month - 1);
            });
          },
        ),
        Column(
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            if (_tab == HistoryTab.week)
              Text(
                "Tuần ${(_selectedDate.day / 7).ceil()}",
                style:
                const TextStyle(color: Colors.white38, fontSize: 12),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white54),
          onPressed: () {
            setState(() {
              _selectedDate = _tab == HistoryTab.day
                  ? _selectedDate.add(const Duration(days: 1))
                  : DateTime(_selectedDate.year, _selectedDate.month + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _summaryCard(int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tổng lượng nước",
              style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 6),
          Text(
            "${NumberFormat('#,###').format(total)} ml",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(int total) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.water_drop,
            title: "Trung bình",
            value: "${(total / 1).round()} ml",
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.emoji_events,
            title: "Hoàn thành",
            value: total >= 2000 ? "100%" : "${(total / 2000 * 100).round()}%",
            color: const Color(0xFF36E27B),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white38)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ],
      ),
    );
  }

  Widget _todayTitle() {
    return const Text(
      "Chi tiết",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _historyItemFromLog(WaterLog log) {
    return _historyItem(
      icon: Icons.water_drop,
      title: log.type,
      time: DateFormat('hh:mm a').format(log.time),
      amount: "${log.amount} ml",
      color: Colors.blue,
    );
  }

  Widget _historyItem({
    required IconData icon,
    required String title,
    required String time,
    required String amount,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text(time,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF36E27B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

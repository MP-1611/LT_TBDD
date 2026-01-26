import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _service = ProfileService();

  final _nameCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  File? _avatarFile;
  String? _avatarUrl;
  final _picker = ImagePicker();


  TimeOfDay _wakeUp = const TimeOfDay(hour: 7, minute: 0);
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // =====================
  // LOAD PROFILE
  // =====================
  Future<void> _load() async {
    final data = await _service.loadProfile();

    _nameCtrl.text = data['name'] ?? '';
    _weightCtrl.text = (data['weight'] ?? 60).toString();
    _goalCtrl.text = (data['dailyGoal'] ?? 2000).toString();
    _avatarUrl = data['avatar'];

    final wakeUpStr = data['wakeUp'] ?? '07:00';
    final parts = wakeUpStr.split(':');

    _wakeUp = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 7,
      minute: int.tryParse(parts[1]) ?? 0,
    );

    setState(() => loading = false);
  }

  // =====================
  // SAVE PROFILE
  // =====================
  Future<void> _save() async {
    if (saving) return; // ✅ chặn ngay từ đầu
    setState(() => saving = true);

    try {
      String? avatarUrl = _avatarUrl;

      if (_avatarFile != null) {
        avatarUrl = await _service.uploadAvatar(_avatarFile!);
      }

      await _service.saveProfile(
        name: _nameCtrl.text.trim(),
        weight: double.tryParse(_weightCtrl.text) ?? 60,
        wakeUp:
        '${_wakeUp.hour.toString().padLeft(2, '0')}:${_wakeUp.minute.toString().padLeft(2, '0')}',
        dailyGoal: int.tryParse(_goalCtrl.text) ?? 2000,
        avatarUrl: avatarUrl,
      );

      if (!mounted) return;
      Navigator.pop(context, true); // ✅ QUAY VỀ + RELOAD PROFILE
    } catch (e) {
      debugPrint('Save profile error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      _avatarFile = File(picked.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Edit Profile"),
        leading: const BackButton(),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF36E27B),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _avatar(),
            const SizedBox(height: 24),
            _input(
              label: "FULL NAME",
              icon: Icons.person,
              controller: _nameCtrl,
            ),
            _input(
              label: "WEIGHT (KG)",
              icon: Icons.monitor_weight,
              controller: _weightCtrl,
              number: true,
            ),
            _wakeUpPicker(),
            _input(
              label: "DAILY GOAL (ML)",
              icon: Icons.local_drink,
              controller: _goalCtrl,
              number: true,
            ),
            const SizedBox(height: 32),
            _saveButton(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Discard Changes",
                style: TextStyle(color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _avatar() {
    ImageProvider image;

    if (_avatarFile != null) {
      image = FileImage(_avatarFile!);
    } else if (_avatarUrl != null) {
      image = NetworkImage(_avatarUrl!);
    } else {
      image = const AssetImage("assets/images/avatar.png");
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF36E27B).withOpacity(0.3),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: image,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF36E27B),
                  child: const Icon(Icons.edit, color: Colors.black),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "Change Profile Photo",
          style: TextStyle(color: Color(0xFF9EB7A8)),
        )
      ],
    );
  }

  Widget _input({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool number = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF9EB7A8),
                fontWeight: FontWeight.bold,
                fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141D19),
            prefixIcon: Icon(icon, color: const Color(0xFF36E27B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _wakeUpPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "WAKE-UP TIME",
          style: TextStyle(
              color: Color(0xFF9EB7A8),
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: _wakeUp,
            );
            if (t != null) setState(() => _wakeUp = t);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141D19),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny,
                    color: Color(0xFF36E27B)),
                const SizedBox(width: 12),
                Text(
                  _wakeUp.format(context),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: saving
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : const Icon(Icons.check_circle, color: Colors.black),
        label: Text(
          saving ? "Saving..." : "Save Changes",
          style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF36E27B),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: saving ? null : _save, // 🔥
      ),
    );
  }

}
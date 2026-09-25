import 'package:flutter/material.dart';
import '../models/birthday_item.dart';
import '../theme/glass_theme.dart';
import 'glass_widgets.dart';

class AddBirthdayDialog extends StatefulWidget {
  final GlassTheme theme;
  final BirthdayItem? initialItem;
  final Function(BirthdayItem) onSave;

  const AddBirthdayDialog({
    super.key,
    required this.theme,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<AddBirthdayDialog> createState() => _AddBirthdayDialogState();
}

class _AddBirthdayDialogState extends State<AddBirthdayDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late DateTime _selectedDate;
  late String _selectedRelationship;
  late IconData _selectedIcon;

  final List<String> _relationships = [
    'Saya',
    'Keluarga',
    'Sahabat',
    'Teman',
    'Pasangan',
  ];

  final List<IconData> _icons = [
    Icons.cake_rounded,
    Icons.celebration_rounded,
    Icons.favorite_rounded,
    Icons.star_rounded,
    Icons.person_rounded,
    Icons.card_giftcard_rounded,
    Icons.music_note_rounded,
    Icons.flight_rounded,
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _selectedDate = item?.birthDate ?? DateTime(2007, 8, 15);
    _selectedRelationship = item?.relationship ?? 'Teman';
    _selectedIcon = item?.icon ?? Icons.cake_rounded;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: widget.theme.primaryAccent,
              surface: const Color(0xFF1E1435),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final newItem = BirthdayItem(
        id: widget.initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        relationship: _selectedRelationship,
        icon: _selectedIcon,
        notes: '',
      );
      widget.onSave(newItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final formattedDate = '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GlassContainer(
        theme: theme,
        blur: 24,
        padding: const EdgeInsets.all(24),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.3,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialItem != null ? 'Edit Pengingat' : 'Tambah Ulang Tahun',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    GlassIconButton(
                      icon: Icons.close_rounded,
                      size: 38,
                      iconSize: 18,
                      theme: theme,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Nama
                Text(
                  'Nama Lengkap',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GlassTextField(
                  controller: _nameController,
                  hintText: 'Contoh: Rias Pajar Prakoso',
                  prefixIcon: Icons.person_outline_rounded,
                  theme: theme,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Tanggal Lahir
                Text(
                  'Tanggal Lahir',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GlassButton(
                  theme: theme,
                  onPressed: _pickDate,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 18, color: theme.primaryAccent),
                          const SizedBox(width: 12),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: theme.textSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Hubungan / Kategori
                Text(
                  'Hubungan',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _relationships.map((rel) {
                    final isSelected = _selectedRelationship == rel;
                    return GlassButton(
                      theme: theme,
                      isSelected: isSelected,
                      borderRadius: BorderRadius.circular(14),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      onPressed: () => setState(() => _selectedRelationship = rel),
                      child: Text(
                        rel,
                        style: TextStyle(
                          color: isSelected ? theme.primaryAccent : theme.textPrimary,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Pilihan Icon Avatar
                Text(
                  'Pilih Ikon Avatar',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _icons.map((iconData) {
                    final isSelected = _selectedIcon == iconData;
                    return GlassIconButton(
                      icon: iconData,
                      size: 42,
                      iconSize: 20,
                      theme: theme,
                      isSelected: isSelected,
                      onPressed: () => setState(() => _selectedIcon = iconData),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan & Batal
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        theme: theme,
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GlassButton(
                        theme: theme,
                        isSelected: true,
                        activeColor: theme.primaryAccent,
                        onPressed: _save,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: theme.primaryAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

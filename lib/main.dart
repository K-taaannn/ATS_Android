import 'dart:async';
import 'package:flutter/material.dart';
import 'models/birthday_item.dart';
import 'theme/neumorphic_theme.dart';
import 'widgets/neu_widgets.dart';
import 'widgets/confetti_celebration.dart';
import 'widgets/add_birthday_dialog.dart';

void main() {
  runApp(const BirthdayCountdownApp());
}

class BirthdayCountdownApp extends StatelessWidget {
  const BirthdayCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Countdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE8EEF5),
      ),
      home: const BirthdayCountdownHomePage(),
    );
  }
}

class BirthdayCountdownHomePage extends StatefulWidget {
  const BirthdayCountdownHomePage({super.key});

  @override
  State<BirthdayCountdownHomePage> createState() => _BirthdayCountdownHomePageState();
}

class _BirthdayCountdownHomePageState extends State<BirthdayCountdownHomePage> {
  bool _isDark = false;
  late NeuTheme _neuTheme;
  Timer? _timer;
  bool _isCelebrating = false;
  String _selectedFilter = 'Semua';

  // Daftar data ulang tahun awal
  final List<BirthdayItem> _birthdays = [
    BirthdayItem(
      id: '1',
      name: 'Rias Pajar Prakoso',
      birthDate: DateTime(2007, 10, 28), // Siswa Kelas XII
      relationship: 'Saya',
      icon: Icons.person_rounded,
      notes: '',
    ),
    BirthdayItem(
      id: '2',
      name: 'Mas Iqbal',
      birthDate: DateTime(2007, 4, 12),
      relationship: 'Sahabat',
      icon: Icons.sports_esports_rounded,
      notes: '',
    ),
    BirthdayItem(
      id: '3',
      name: 'Ibu Tercinta',
      birthDate: DateTime(1982, 11, 15),
      relationship: 'Keluarga',
      icon: Icons.favorite_rounded,
      notes: '',
    ),
  ];

  late String _activeBirthdayId;

  @override
  void initState() {
    super.initState();
    _neuTheme = NeuTheme(isDark: _isDark);
    _activeBirthdayId = _birthdays.first.id;

    // Timer realtime untuk memperbarui countdown setiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      _neuTheme = NeuTheme(isDark: _isDark);
    });
  }

  void _triggerCelebration() {
    setState(() {
      _isCelebrating = true;
    });
  }

  BirthdayItem get _activeItem {
    return _birthdays.firstWhere(
      (b) => b.id == _activeBirthdayId,
      orElse: () => _birthdays.isNotEmpty
          ? _birthdays.first
          : BirthdayItem(
              id: '0',
              name: 'Belum Ada Data',
              birthDate: DateTime.now(),
            ),
    );
  }

  void _openAddDialog([BirthdayItem? itemToEdit]) {
    showDialog(
      context: context,
      builder: (ctx) => AddBirthdayDialog(
        theme: _neuTheme,
        initialItem: itemToEdit,
        onSave: (savedItem) {
          setState(() {
            if (itemToEdit != null) {
              final index = _birthdays.indexWhere((b) => b.id == itemToEdit.id);
              if (index != -1) {
                _birthdays[index] = savedItem;
              }
            } else {
              _birthdays.add(savedItem);
              _activeBirthdayId = savedItem.id;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                itemToEdit != null ? 'Data berhasil diperbarui!' : 'Pengingat ulang tahun ditambahkan!',
              ),
              backgroundColor: _neuTheme.primaryAccent,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _deleteBirthday(BirthdayItem item) {
    if (_birthdays.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal harus ada satu data ulang tahun!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: NeuContainer(
          theme: _neuTheme,
          padding: const EdgeInsets.all(22),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, size: 44, color: _neuTheme.secondaryAccent),
              const SizedBox(height: 12),
              Text(
                'Hapus Pengingat?',
                style: TextStyle(
                  color: _neuTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin menghapus data ulang tahun "${item.name}"?',
                textAlign: TextAlign.center,
                style: TextStyle(color: _neuTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: NeuButton(
                      theme: _neuTheme,
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Batal', style: TextStyle(color: _neuTheme.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeuButton(
                      theme: _neuTheme,
                      isSelected: true,
                      activeColor: _neuTheme.secondaryAccent,
                      onPressed: () {
                        setState(() {
                          _birthdays.removeWhere((b) => b.id == item.id);
                          if (_activeBirthdayId == item.id) {
                            _activeBirthdayId = _birthdays.first.id;
                          }
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Hapus', style: TextStyle(color: _neuTheme.secondaryAccent, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = _neuTheme;
    final now = DateTime.now();
    final active = _activeItem;
    final remainingDays = active.getRemainingDays(now);
    final remainingDuration = active.getRemainingDuration(now);
    final isToday = active.isToday(now);
    final turningAge = active.getTurningAge(now);
    final zodiac = active.getZodiac();
    final progress = active.getYearlyProgress(now);

    // List terfilter
    final filteredBirthdays = _selectedFilter == 'Semua'
        ? _birthdays
        : _birthdays.where((b) => b.relationship == _selectedFilter).toList();

    return ConfettiCelebration(
      isPlaying: _isCelebrating,
      onFinished: () => setState(() => _isCelebrating = false),
      child: Scaffold(
        backgroundColor: theme.baseColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Neumorphic App Bar
                _buildTopAppBar(theme),
                const SizedBox(height: 24),

                // Hero Neumorphic Countdown Card
                _buildHeroCountdownCard(
                  theme: theme,
                  active: active,
                  remainingDays: remainingDays,
                  duration: remainingDuration,
                  isToday: isToday,
                  turningAge: turningAge,
                  zodiac: zodiac,
                  progress: progress,
                ),
                const SizedBox(height: 28),

                // Section Daftar Pengingat & Filter
                _buildListHeader(theme),
                const SizedBox(height: 14),

                // Filter Buttons
                _buildFilterChips(theme),
                const SizedBox(height: 18),

                // List Card Ulang Tahun
                _buildBirthdayCardsList(theme, filteredBirthdays, active.id),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar(NeuTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            NeuContainer(
              theme: theme,
              shape: BoxShape.circle,
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.cake_rounded,
                color: theme.primaryAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Birthday Countdown',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        NeuIconButton(
          icon: _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 42,
          iconSize: 20,
          iconColor: _isDark ? Colors.amber : theme.textPrimary,
          tooltip: _isDark ? 'Mode Terang' : 'Mode Gelap',
          theme: theme,
          onPressed: _toggleTheme,
        ),
      ],
    );
  }

  Widget _buildHeroCountdownCard({
    required NeuTheme theme,
    required BirthdayItem active,
    required int remainingDays,
    required Duration duration,
    required bool isToday,
    required int turningAge,
    required Map<String, String> zodiac,
    required double progress,
  }) {
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return NeuContainer(
      theme: theme,
      padding: const EdgeInsets.all(22),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas Hero: Avatar, Nama, Relasi & Edit
          Row(
            children: [
              NeuContainer(
                theme: theme,
                shape: BoxShape.circle,
                padding: const EdgeInsets.all(12),
                child: Icon(
                  active.icon,
                  size: 26,
                  color: isToday ? theme.secondaryAccent : theme.primaryAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            active.name,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        NeuBadge(
                          text: active.relationship,
                          theme: theme,
                          color: active.relationship == 'Saya' ? theme.secondaryAccent : theme.primaryAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Menuju Ulang Tahun ke-$turningAge • ${active.getFormattedBirthDate()}',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              NeuIconButton(
                icon: Icons.edit_outlined,
                size: 38,
                iconSize: 18,
                theme: theme,
                onPressed: () => _openAddDialog(active),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Banner Ucapan jika hari ini ulang tahun
          if (isToday)
            NeuContainer(
              theme: theme,
              isPressed: true,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARI INI ULANG TAHUN! 🎂',
                          style: TextStyle(
                            color: theme.secondaryAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Selamat bertambah usia yang ke-$turningAge tahun!',
                          style: TextStyle(color: theme.textPrimary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Display Utama: Sisa Hari
          Center(
            child: Column(
              children: [
                Text(
                  isToday ? '0' : '$remainingDays',
                  style: TextStyle(
                    color: isToday ? theme.secondaryAccent : theme.primaryAccent,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isToday ? 'HARI INI BERULANG TAHUN!' : 'HARI TERSISA MENUJU HARI-H',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Countdown Grid (Hari, Jam, Menit, Detik)
          Row(
            children: [
              Expanded(child: _buildTimeBox(theme, remainingDays.toString(), 'HARI')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeBox(theme, hours.toString().padLeft(2, '0'), 'JAM')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeBox(theme, minutes.toString().padLeft(2, '0'), 'MENIT')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeBox(theme, seconds.toString().padLeft(2, '0'), 'DETIK', isAccent: true)),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Tahunan Menuju Ulang Tahun
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perjalanan Tahun Ini',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NeuProgressBar(
            progress: progress,
            theme: theme,
            height: 10,
            activeColor: isToday ? theme.secondaryAccent : theme.primaryAccent,
          ),
          const SizedBox(height: 18),

          // Trivia Zodiak & Hari Lahir
          NeuContainer(
            theme: theme,
            isPressed: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTriviaItem(
                  theme,
                  'Zodiak',
                  '${zodiac['symbol']} ${zodiac['name']}',
                  'Elemen ${zodiac['element']}',
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: theme.textSecondary.withValues(alpha: 0.2),
                ),
                _buildTriviaItem(
                  theme,
                  'Hari Kelahiran',
                  active.getBirthDayName(),
                  'Usia saat ini: ${active.getCurrentAge()} thn',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Tombol Selebrasi Interaktif
          NeuButton(
            theme: theme,
            isSelected: true,
            activeColor: theme.secondaryAccent,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            onPressed: _triggerCelebration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  isToday ? 'Rayakan Sekarang! 🎉' : 'Uji Selebrasi Ulang Tahun 🎈',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(NeuTheme theme, String value, String unit, {bool isAccent = false}) {
    return NeuContainer(
      theme: theme,
      isPressed: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: isAccent ? theme.secondaryAccent : theme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriviaItem(NeuTheme theme, String title, String value, String sub) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: theme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: theme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: TextStyle(color: theme.textMuted, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildListHeader(NeuTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pengingat',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Pilih untuk menampilkan countdown di atas',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        NeuButton(
          theme: theme,
          isSelected: true,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          borderRadius: BorderRadius.circular(14),
          onPressed: () => _openAddDialog(),
          child: Row(
            children: [
              Icon(Icons.add_rounded, size: 18, color: theme.primaryAccent),
              const SizedBox(width: 4),
              Text(
                'Tambah',
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(NeuTheme theme) {
    final filters = ['Semua', 'Saya', 'Sahabat', 'Keluarga', 'Teman'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: NeuButton(
              theme: theme,
              isSelected: isSelected,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              onPressed: () => setState(() => _selectedFilter = f),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? theme.primaryAccent : theme.textPrimary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBirthdayCardsList(
    NeuTheme theme,
    List<BirthdayItem> items,
    String activeId,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.calendar_month_outlined, size: 48, color: theme.textMuted),
              const SizedBox(height: 12),
              Text(
                'Belum ada data pada kategori ini',
                style: TextStyle(color: theme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        final isActive = item.id == activeId;
        final days = item.getRemainingDays(now);
        final isToday = item.isToday(now);
        final nextAge = item.getTurningAge(now);

        return GestureDetector(
          onTap: () {
            setState(() {
              _activeBirthdayId = item.id;
            });
          },
          child: NeuContainer(
            theme: theme,
            borderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.all(16),
            border: isActive
                ? Border.all(color: theme.primaryAccent.withValues(alpha: 0.5), width: 1.5)
                : null,
            child: Row(
              children: [
                NeuContainer(
                  theme: theme,
                  shape: BoxShape.circle,
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: isToday ? theme.secondaryAccent : theme.primaryAccent,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          NeuBadge(
                            text: item.relationship,
                            theme: theme,
                            color: item.relationship == 'Saya' ? theme.secondaryAccent : theme.primaryAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.getFormattedBirthDate()} (ke-$nextAge)',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isToday ? 'Hari Ini!' : '$days Hari',
                      style: TextStyle(
                        color: isToday ? theme.secondaryAccent : theme.primaryAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      isToday ? 'Ulang Tahun 🎂' : 'lagi',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, size: 20, color: theme.textSecondary),
                  color: theme.baseColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onSelected: (val) {
                    if (val == 'edit') {
                      _openAddDialog(item);
                    } else if (val == 'delete') {
                      _deleteBirthday(item);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: theme.textPrimary),
                          const SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: theme.textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: theme.secondaryAccent),
                          const SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: theme.secondaryAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

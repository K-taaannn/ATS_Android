import 'package:flutter/material.dart';

class BirthdayItem {
  final String id;
  final String name;
  final DateTime birthDate;
  final String relationship; // 'Saya', 'Keluarga', 'Sahabat', 'Teman', 'Lainnya'
  final IconData icon;
  final String notes;

  BirthdayItem({
    required this.id,
    required this.name,
    required this.birthDate,
    this.relationship = 'Teman',
    this.icon = Icons.cake_rounded,
    this.notes = '',
  });

  /// Menghitung tanggal ulang tahun berikutnya dari waktu [now]
  DateTime getNextBirthday([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Perlakuan khusus 29 Februari di tahun bukan kabisat
    int day = birthDate.day;
    int month = birthDate.month;
    if (month == 2 && day == 29) {
      final isLeapThisYear = (now.year % 4 == 0 && now.year % 100 != 0) || (now.year % 400 == 0);
      if (!isLeapThisYear) {
        day = 28;
      }
    }

    DateTime thisYearBirthday = DateTime(now.year, month, day);

    if (thisYearBirthday.isBefore(today)) {
      final nextYear = now.year + 1;
      int nextDay = birthDate.day;
      if (month == 2 && nextDay == 29) {
        final isLeapNextYear = (nextYear % 4 == 0 && nextYear % 100 != 0) || (nextYear % 400 == 0);
        if (!isLeapNextYear) {
          nextDay = 28;
        }
      }
      return DateTime(nextYear, month, nextDay);
    } else {
      return thisYearBirthday;
    }
  }

  /// Apakah hari ini adalah hari ulang tahunnya
  bool isToday([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    return now.month == birthDate.month && now.day == birthDate.day;
  }

  /// Sisa hari menuju ulang tahun berikutnya
  int getRemainingDays([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextBirthday = getNextBirthday(now);
    return nextBirthday.difference(today).inDays;
  }

  /// Sisa waktu detail (hari, jam, menit, detik)
  Duration getRemainingDuration([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final nextBirthday = getNextBirthday(now);
    // Asumsikan perayaan mulai jam 00:00:00 pada tanggal ulang tahun
    final target = DateTime(nextBirthday.year, nextBirthday.month, nextBirthday.day, 0, 0, 0);
    final diff = target.difference(now);
    if (diff.isNegative) {
      // Jika hari ini berulang tahun
      if (isToday(now)) {
        return Duration.zero;
      }
    }
    return diff;
  }

  /// Usia yang akan dicapai pada ulang tahun berikutnya
  int getTurningAge([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final nextBirthday = getNextBirthday(now);
    return nextBirthday.year - birthDate.year;
  }

  /// Usia saat ini (dalam tahun)
  int getCurrentAge([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  /// Persentase perjalanan tahunan (0.0 - 1.0)
  double getYearlyProgress([DateTime? fromDate]) {
    final remainingDays = getRemainingDays(fromDate);
    // 365 hari dalam setahun
    final passedDays = 365 - remainingDays;
    final progress = passedDays / 365.0;
    return progress.clamp(0.0, 1.0);
  }

  /// Menentukan Zodiak dan Simbolnya
  Map<String, String> getZodiac() {
    final m = birthDate.month;
    final d = birthDate.day;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) {
      return {'name': 'Aries', 'symbol': '♈', 'element': 'Api'};
    } else if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) {
      return {'name': 'Taurus', 'symbol': '♉', 'element': 'Tanah'};
    } else if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) {
      return {'name': 'Gemini', 'symbol': '♊', 'element': 'Udara'};
    } else if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) {
      return {'name': 'Cancer', 'symbol': '♋', 'element': 'Air'};
    } else if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) {
      return {'name': 'Leo', 'symbol': '♌', 'element': 'Api'};
    } else if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) {
      return {'name': 'Virgo', 'symbol': '♍', 'element': 'Tanah'};
    } else if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) {
      return {'name': 'Libra', 'symbol': '♎', 'element': 'Udara'};
    } else if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) {
      return {'name': 'Scorpio', 'symbol': '♏', 'element': 'Air'};
    } else if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
      return {'name': 'Sagitarius', 'symbol': '♐', 'element': 'Api'};
    } else if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
      return {'name': 'Capricorn', 'symbol': '♑', 'element': 'Tanah'};
    } else if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) {
      return {'name': 'Aquarius', 'symbol': '♒', 'element': 'Udara'};
    } else {
      return {'name': 'Pisces', 'symbol': '♓', 'element': 'Air'};
    }
  }

  /// Nama hari kelahiran dalam bahasa Indonesia
  String getBirthDayName() {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[birthDate.weekday - 1];
  }

  /// Format tanggal singkat (cth: 15 Agustus 2007)
  String getFormattedBirthDate() {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${birthDate.day} ${months[birthDate.month - 1]} ${birthDate.year}';
  }

  BirthdayItem copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? relationship,
    IconData? icon,
    String? notes,
  }) {
    return BirthdayItem(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      relationship: relationship ?? this.relationship,
      icon: icon ?? this.icon,
      notes: notes ?? this.notes,
    );
  }
}

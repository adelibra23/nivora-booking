import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/catalog.dart';

class Booking {
  final String id;
  final int stayId, guests, total;
  final DateTime start, end;
  final String payment;
  final bool cancelled;
  const Booking({required this.id, required this.stayId, required this.guests,
    required this.total, required this.start, required this.end, required this.payment,
    this.cancelled = false});
  Stay get stay => getStay(stayId);
  bool get isUpcoming => !cancelled && !end.isBefore(DateTime.now());
  int get nights => end.difference(start).inDays;
  Map<String, dynamic> toJson() => {
    'id': id, 'stayId': stayId, 'guests': guests, 'total': total,
    'start': start.toIso8601String(), 'end': end.toIso8601String(),
    'payment': payment, 'cancelled': cancelled,
  };
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    stayId: (json['stayId'] as num).toInt(),
    guests: (json['guests'] as num).toInt(),
    total: (json['total'] as num).toInt(),
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    payment: json['payment'] as String,
    cancelled: json['cancelled'] == true,
  );
  Booking cancelledCopy() => Booking(id: id, stayId: stayId, guests: guests,
    total: total, start: start, end: end, payment: payment, cancelled: true);
}

class BookingController extends ChangeNotifier {
  SharedPreferences? _prefs;
  final Set<int> favorites = {};
  final List<Booking> bookings = [];
  bool darkMode = false;
  bool notificationsEnabled = true;
  int rewardPoints = 2450;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    favorites.addAll((_prefs!.getStringList('favorites') ?? []).map(int.tryParse).whereType<int>());
    darkMode = _prefs!.getBool('darkMode') ?? false;
    notificationsEnabled = _prefs!.getBool('notifications') ?? true;
    rewardPoints = _prefs!.getInt('points') ?? 2450;
    final jsonData = _prefs!.getString('bookings');
    if (jsonData != null) {
      try {
        for (final raw in jsonDecode(jsonData) as List<dynamic>) {
          bookings.add(Booking.fromJson(Map<String, dynamic>.from(raw as Map)));
        }
      } catch (_) {
        bookings.clear();
      }
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    if (!favorites.add(id)) favorites.remove(id);
    notifyListeners();
    await _prefs?.setStringList('favorites', favorites.map((e) => '$e').toList());
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _prefs?.setBool('darkMode', value);
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    notifyListeners();
    await _prefs?.setBool('notifications', value);
  }

  Future<Booking> makeBooking({required Stay stay, required DateTime start,
    required DateTime end, required int guests, required String payment,
    required int total}) async {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final booking = Booking(id: 'NV-${timestamp.substring(timestamp.length - 9)}',
      stayId: stay.id, guests: guests, total: total, start: start, end: end,
      payment: payment);
    bookings.insert(0, booking);
    rewardPoints += total ~/ 10000;
    notifyListeners();
    await _persistBookings();
    await _prefs?.setInt('points', rewardPoints);
    return booking;
  }

  Future<void> cancelBooking(String id) async {
    final index = bookings.indexWhere((b) => b.id == id);
    if (index < 0) return;
    bookings[index] = bookings[index].cancelledCopy();
    notifyListeners();
    await _persistBookings();
  }

  Future<void> _persistBookings() async {
    await _prefs?.setString('bookings', jsonEncode(bookings.map((b) => b.toJson()).toList()));
  }
}

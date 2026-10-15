import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nivora_booking/data/catalog.dart';
import 'package:nivora_booking/state/booking_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('favorites and booking demo persist to local preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final state = BookingController();
    await state.initialize();
    await state.toggleFavorite(1);
    expect(state.favorites, contains(1));

    final begin = DateTime(2027, 2, 10);
    final booking = await state.makeBooking(
      stay: catalog[0], start: begin, end: begin.add(const Duration(days: 2)),
      guests: 2, payment: 'E-wallet (simulasi)', total: 3885000);
    expect(booking.id.startsWith('NV-'), isTrue);
    expect(state.bookings, hasLength(1));

    final reloaded = BookingController();
    await reloaded.initialize();
    expect(reloaded.favorites, contains(1));
    expect(reloaded.bookings.first.id, booking.id);
    await reloaded.cancelBooking(booking.id);
    expect(reloaded.bookings.first.cancelled, isTrue);
  });
}

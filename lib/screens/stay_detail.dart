import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../state/booking_controller.dart';
import '../widgets/components.dart';

class StayDetail extends StatelessWidget {
  final Stay stay;
  final BookingController controller;
  const StayDetail({super.key, required this.stay, required this.controller});

  void openBooking(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => BookingSheet(stay: stay, controller: controller,
        onBooked: (booking) {
          Navigator.pop(sheetContext);
          Navigator.push(context, MaterialPageRoute(builder: (_) =>
            BookingSuccess(booking: booking, controller: controller)));
        }),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true, expandedHeight: 341,
        leading: Padding(padding: const EdgeInsets.all(6), child: CircleAction(
          icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context))),
        actions: [
          AnimatedBuilder(animation: controller, builder: (context, _) =>
            CircleAction(icon: controller.favorites.contains(stay.id)
              ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              active: controller.favorites.contains(stay.id),
              onTap: () => controller.toggleFavorite(stay.id))),
          const SizedBox(width: 14),
        ],
        flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
          NetworkPhoto(stay.image),
          DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [NColors.ink.withValues(alpha: 0.10), Colors.transparent,
              NColors.ink.withValues(alpha: 0.35)]))),
          Positioned(bottom: 21, left: 23, child: Pill(stay.tag)),
          const Positioned(bottom: 24, right: 22,
            child: Pill('01 / 01', bg: NColors.ink, fg: Colors.white)),
        ])),
      ),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(23, 24, 23, 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Pill(stay.category, bg: NColors.violet.withValues(alpha: 0.12), fg: NColors.violet),
            const Spacer(),
            const Icon(Icons.star_rounded, color: Color(0xFFFFBB4D), size: 22),
            Text('${stay.rating}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            Text(' (${stay.reviews} ulasan)', style: const TextStyle(fontSize: 12, color: NColors.slate)),
          ]),
          const SizedBox(height: 12),
          Text(stay.title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 34)),
          const SizedBox(height: 11),
          Row(children: [const Icon(Icons.location_on_outlined, size: 19, color: NColors.violet),
            const SizedBox(width: 6), Text(stay.location,
              style: const TextStyle(color: NColors.slate, fontSize: 14))]),
          const SizedBox(height: 27),
          Divider(color: Theme.of(context).dividerColor),
          const SizedBox(height: 19),
          Text('Your next great story.', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 9),
          Text(stay.description, style: const TextStyle(
            color: NColors.slate, fontSize: 14.2, height: 1.7)),
          const SizedBox(height: 29),
          Text('Yang bikin spesial', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 15),
          Wrap(spacing: 8, runSpacing: 9,
            children: [for (final h in stay.highlights)
              Pill(h, bg: stay.accent.withValues(alpha: 0.40), fg: NColors.ink,
                icon: Icons.auto_awesome_rounded)]),
          const SizedBox(height: 31),
          Text('Fasilitas & layanan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 15),
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
              mainAxisExtent: 55),
            itemCount: stay.amenities.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const SizedBox(width: 12),
                Icon(_amenityIcon(stay.amenities[index]), color: NColors.violet, size: 21),
                const SizedBox(width: 9),
                Expanded(child: Text(stay.amenities[index],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis)),
              ]))),
          const SizedBox(height: 29),
          Text('Tentang lokasi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 13),
          Container(height: 150, width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFFE7F0E6),
              borderRadius: BorderRadius.circular(20)),
            child: Stack(children: [
              Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Center(child: Container(width: 48, height: 48,
                decoration: const BoxDecoration(color: NColors.ink, shape: BoxShape.circle),
                child: const Icon(Icons.location_pin, color: NColors.neon, size: 29))),
              Positioned(bottom: 0, left: 0, child: Pill(stay.location,
                bg: Colors.white, fg: NColors.ink)),
            ])),
          const SizedBox(height: 7),
          const Text('Ilustrasi peta • bukan lokasi GPS akurat',
            style: TextStyle(color: NColors.slate, fontSize: 10)),
          const SizedBox(height: 28),
          Container(padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Container(width: 51, height: 51,
                decoration: BoxDecoration(color: NColors.neon,
                  borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.workspace_premium_rounded, color: NColors.ink)),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Dikelola oleh ${stay.host}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                const SizedBox(height: 3),
                const Text('Nivora curated collection • data simulasi',
                  style: TextStyle(fontSize: 11, color: NColors.slate)),
              ])),
            ])),
          const SizedBox(height: 25),
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: NColors.violet.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline_rounded, color: NColors.violet),
              SizedBox(width: 10),
              Expanded(child: Text('Semua listing, harga, ulasan, dan ketersediaan merupakan data demo. Tidak ada reservasi atau pembayaran sungguhan.',
                style: TextStyle(fontSize: 11.5, height: 1.5))),
            ])),
        ])),
      ),
    ]),
    bottomNavigationBar: SafeArea(top: false, child: Container(
      padding: const EdgeInsets.fromLTRB(22, 13, 22, 14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Row(children: [
        Expanded(child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(rupiah(stay.price),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            Text(stay.isExperience ? 'per orang' : 'per malam',
              style: const TextStyle(color: NColors.slate, fontSize: 11.5)),
          ])),
        SizedBox(width: 174, child: NButton('Pesan sekarang',
          color: NColors.ink, icon: Icons.arrow_forward_rounded,
          onPressed: () => openBooking(context))),
      ]))),
  );
  IconData _amenityIcon(String label) {
    if (label.contains('Wi-Fi')) return Icons.wifi_rounded;
    if (label.toLowerCase().contains('pool') || label.contains('Kolam')) return Icons.pool_rounded;
    if (label.contains('Sarapan') || label.contains('Breakfast')) return Icons.coffee_rounded;
    if (label.contains('Parkir')) return Icons.local_parking_rounded;
    if (label.contains('AC')) return Icons.ac_unit_rounded;
    if (label.contains('Spa')) return Icons.spa_outlined;
    if (label.contains('Pemandu')) return Icons.tour_rounded;
    if (label.contains('Peralatan')) return Icons.scuba_diving_rounded;
    return Icons.check_circle_outline_rounded;
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 10..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final border = Paint()..color = const Color(0xFFB7D7BE)
      ..strokeWidth = 2..style = PaintingStyle.stroke;
    for (final n in [0.2, 0.55, 0.88]) {
      final y = size.height * n;
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 18), road);
    }
    final path = Path()..moveTo(size.width * .1, 0)
      ..cubicTo(size.width * .3, size.height * .3,
        size.width * .45, size.height * .7, size.width * .9, size.height);
    canvas.drawPath(path, road);
    for (final n in [0.18, .46, .75]) {
      canvas.drawCircle(Offset(size.width * n, size.height * (.2 + n * .6)), 16, border);
    }
  }
  @override
  bool shouldRepaint(covariant _MapPainter old) => false;
}

class BookingSheet extends StatefulWidget {
  final Stay stay;
  final BookingController controller;
  final ValueChanged<Booking> onBooked;
  const BookingSheet({super.key, required this.stay,
    required this.controller, required this.onBooked});
  @override
  State<BookingSheet> createState() => _BookingSheetState();
}
class _BookingSheetState extends State<BookingSheet> {
  late DateTime start, end;
  int guests = 2;
  bool promoApplied = false, loading = false;
  String payment = 'Bayar di tempat (simulasi)';
  final promoInput = TextEditingController();
  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    start = DateTime(today.year, today.month, today.day).add(const Duration(days: 3));
    end = start.add(const Duration(days: 2));
  }
  @override
  void dispose() {promoInput.dispose(); super.dispose();}
  int get nights => end.difference(start).inDays;
  int get units => widget.stay.isExperience ? guests : nights;
  int get subtotal => widget.stay.price * units;
  int get discount => promoApplied ? (subtotal * 0.1).round() : 0;
  int get fee => (subtotal * 0.05).round();
  int get total => subtotal + fee - discount;

  Future<void> pickDates() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final range = await showDateRangePicker(
      context: context, initialDateRange: DateTimeRange(start: start, end: end),
      firstDate: today, lastDate: today.add(const Duration(days: 365)),
      helpText: widget.stay.isExperience ? 'PILIH PERIODE AKTIVITAS' : 'PILIH TANGGAL MENGINAP',
      saveText: 'TERAPKAN',
    );
    if (range != null) setState(() {
      start = range.start;
      end = range.end.isAfter(range.start) ? range.end
        : range.start.add(const Duration(days: 1));
    });
  }

  Future<void> finish() async {
    if (loading) return;
    setState(() => loading = true);
    try {
      final booking = await widget.controller.makeBooking(
        stay: widget.stay, start: start, end: end,
        guests: guests, payment: payment, total: total);
      if (!mounted) return;
      widget.onBooked(booking);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking demo gagal disimpan: $error')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: FractionallySizedBox(heightFactor: 0.88, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(23, 4, 23, 17), child: Row(children: [
        Expanded(child: Text('Atur perjalananmu',
          style: Theme.of(context).textTheme.headlineMedium)),
        IconButton(onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded)),
      ])),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(23, 0, 23, 15), children: [
        Row(children: [
          NetworkPhoto(widget.stay.image, width: 81, height: 78,
            radius: BorderRadius.circular(15)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.stay.title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text(widget.stay.location,
              style: const TextStyle(color: NColors.slate, fontSize: 12)),
            const SizedBox(height: 5),
            Text('${rupiah(widget.stay.price)} / ${widget.stay.isExperience ? 'orang' : 'malam'}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          ])),
        ]),
        const SizedBox(height: 23),
        Text('Tanggal ${widget.stay.isExperience ? 'aktivitas' : 'menginap'}',
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 11),
        InkWell(onTap: pickDates, borderRadius: BorderRadius.circular(17),
          child: Container(padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(17)),
            child: Row(children: [
              const Icon(Icons.date_range_rounded, color: NColors.violet),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(prettyDate(start), style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(widget.stay.isExperience ? 'Tanggal mulai' : 'Check-in',
                  style: const TextStyle(fontSize: 11, color: NColors.slate)),
              ])),
              const Icon(Icons.arrow_forward_rounded, size: 17, color: NColors.slate),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(prettyDate(end), style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(widget.stay.isExperience ? 'Tanggal selesai' : 'Check-out',
                  style: const TextStyle(fontSize: 11, color: NColors.slate)),
              ])),
            ]))),
        const SizedBox(height: 22),
        Text(widget.stay.isExperience ? 'Jumlah peserta' : 'Jumlah tamu',
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 11),
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(17)),
          child: Row(children: [
            const Icon(Icons.people_alt_outlined, color: NColors.violet),
            const SizedBox(width: 11),
            Expanded(child: Text('$guests orang', style: const TextStyle(fontWeight: FontWeight.w800))),
            _counter(Icons.remove, () => setState(() {if (guests > 1) guests--;})),
            const SizedBox(width: 10),
            _counter(Icons.add, () => setState(() {if (guests < 8) guests++;})),
          ])),
        const SizedBox(height: 24),
        Text('Metode pembayaran demo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 7),
        for (final method in ['Bayar di tempat (simulasi)',
          'Virtual account (simulasi)', 'E-wallet (simulasi)'])
          RadioListTile<String>(dense: true,
            contentPadding: EdgeInsets.zero, value: method, groupValue: payment,
            title: Text(method, style: const TextStyle(fontSize: 12.5)),
            onChanged: (v) => setState(() => payment = v!)),
        const SizedBox(height: 10),
        Text('Kode promo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(child: TextField(controller: promoInput,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: 'Coba NIVORA10'))),
          const SizedBox(width: 9),
          SizedBox(height: 54, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: NColors.violet),
            onPressed: () {
              final valid = promoInput.text.trim().toUpperCase() == 'NIVORA10';
              setState(() => promoApplied = valid);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(valid
                ? 'Kode promo demo berhasil digunakan!' : 'Kode tidak dikenal. Coba NIVORA10.')));
            }, child: const Text('Pakai'))),
        ]),
        const SizedBox(height: 21),
        Text('Rincian biaya', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 13),
        _cost('${shortRupiah(widget.stay.price)} × $units ${widget.stay.isExperience ? 'orang' : 'malam'}', rupiah(subtotal)),
        _cost('Biaya layanan simulasi (5%)', rupiah(fee)),
        if (promoApplied) _cost('Diskon NIVORA10', '-${rupiah(discount)}', accent: true),
        const SizedBox(height: 5),
        Divider(color: Theme.of(context).dividerColor),
        _cost('Total', rupiah(total), heavy: true),
        const SizedBox(height: 16),
        const Text('Booking ini hanya simulasi. Tidak ada tagihan, ketersediaan hotel, atau pembayaran nyata.',
          style: TextStyle(fontSize: 11, color: NColors.slate, height: 1.5)),
      ])),
      Container(padding: const EdgeInsets.fromLTRB(23, 12, 23, 20),
        decoration: BoxDecoration(border: Border(top: BorderSide(
          color: Theme.of(context).dividerColor))),
        child: NButton('Konfirmasi booking demo', icon: Icons.arrow_forward_rounded,
          loading: loading, onPressed: finish)),
    ])));
  Widget _counter(IconData icon, VoidCallback tap) => InkWell(onTap: tap,
    borderRadius: BorderRadius.circular(12),
    child: Container(width: 37, height: 37,
      decoration: BoxDecoration(color: NColors.neon,
        borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: NColors.ink, size: 19)));
  Widget _cost(String label, String amount, {bool heavy = false, bool accent = false}) =>
    Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(
        fontWeight: heavy ? FontWeight.w900 : FontWeight.w500,
        fontSize: heavy ? 15 : 12.5))),
      Text(amount, style: TextStyle(fontSize: heavy ? 18 : 13,
        fontWeight: heavy ? FontWeight.w900 : FontWeight.w800,
        color: accent ? NColors.violet : null)),
    ]));
}

class BookingSuccess extends StatelessWidget {
  final Booking booking;
  final BookingController controller;
  const BookingSuccess({super.key, required this.booking, required this.controller});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Container(width: 123, height: 123,
          decoration: const BoxDecoration(color: NColors.neon, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, size: 77, color: NColors.ink)),
        const SizedBox(height: 25),
        Text('It’s a date!', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 9),
        Text('Booking demo kamu berhasil dicatat.\nSiap buat momen baru?',
          style: const TextStyle(color: NColors.slate, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center),
        const SizedBox(height: 28),
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(23)),
          child: Row(children: [
            NetworkPhoto(booking.stay.image, width: 90, height: 90,
              radius: BorderRadius.circular(16)),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(booking.stay.title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 7),
                Text('${prettyDate(booking.start)} - ${prettyDate(booking.end)}',
                  style: const TextStyle(color: NColors.slate, fontSize: 11.5)),
                const SizedBox(height: 7),
                Text(booking.id, style: const TextStyle(fontWeight: FontWeight.w800,
                  color: NColors.violet)),
              ])),
          ])),
        const Spacer(),
        NButton('Lihat e-ticket demo', icon: Icons.arrow_forward_rounded,
          onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => TicketPage(booking: booking,
              controller: controller)))),
        const SizedBox(height: 10),
        NButton('Kembali jelajah', outlined: true,
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)),
      ]))),
  );
}

class TicketPage extends StatelessWidget {
  final Booking booking;
  final BookingController controller;
  const TicketPage({super.key, required this.booking, required this.controller});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller,
    builder: (context, _) {
      final current = controller.bookings.firstWhere(
        (b) => b.id == booking.id, orElse: () => booking);
      return Scaffold(appBar: AppBar(title: const Text('E-ticket demo'), centerTitle: true),
        body: ListView(padding: const EdgeInsets.fromLTRB(22, 15, 22, 30), children: [
          Container(clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28)),
            child: Column(children: [
              SizedBox(height: 165, width: double.infinity,
                child: Stack(fit: StackFit.expand, children: [
                  NetworkPhoto(current.stay.image),
                  DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, NColors.midnight.withValues(alpha: 0.75)]))),
                  Positioned(left: 17, bottom: 17, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Pill(current.cancelled ? 'CANCELLED / DEMO' : 'CONFIRMED / DEMO'),
                      const SizedBox(height: 9),
                      Text(current.stay.title, style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w900, fontSize: 23)),
                    ])),
                ])),
              Padding(padding: const EdgeInsets.all(21), child: Column(children: [
                _row('Booking ID', current.id),
                _row('Destinasi', current.stay.location),
                _row('Mulai', prettyDate(current.start)),
                _row('Selesai', prettyDate(current.end)),
                _row('Tamu / peserta', '${current.guests} orang'),
                _row('Pembayaran', current.payment),
                _row('Total demo', rupiah(current.total)),
              ])),
              Row(children: [
                Container(width: 14, height: 28,
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)))),
                Expanded(child: LayoutBuilder(builder: (context, constraints) {
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate((constraints.maxWidth / 10).floor(),
                      (i) => Container(width: 4, height: 1, color: NColors.slate)));
                })),
                Container(width: 14, height: 28,
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)))),
              ]),
              const SizedBox(height: 13),
              QrImageView(data: 'NIVORA-DEMO:${current.id}:${current.stayId}',
                size: 175, backgroundColor: Colors.white),
              const SizedBox(height: 4),
              Text(current.id, style: const TextStyle(
                letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: 12)),
              const SizedBox(height: 11),
              const Text('QR ini hanya memuat ID booking demo,\nbukan tiket valid untuk check-in.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NColors.slate, fontSize: 11, height: 1.5)),
              const SizedBox(height: 22),
            ])),
          const SizedBox(height: 17),
          NButton('Salin kode booking', icon: Icons.copy_rounded, outlined: true,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: current.id));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Kode booking demo tersalin')));
            }),
          if (!current.cancelled && current.isUpcoming) ...[
            const SizedBox(height: 11),
            NButton('Batalkan booking demo', outlined: true,
              onPressed: () => _cancel(context, current)),
          ],
          const SizedBox(height: 18),
          const Text('Penting: tidak berlaku untuk reservasi sungguhan atau transaksi nyata.',
            textAlign: TextAlign.center,
            style: TextStyle(color: NColors.slate, fontSize: 11)),
        ]));
    });
  Widget _row(String left, String right) => Padding(
    padding: const EdgeInsets.only(bottom: 17), child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(left, style: const TextStyle(color: NColors.slate, fontSize: 12))),
        const SizedBox(width: 12),
        Flexible(flex: 2, child: Text(right, textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5))),
      ]));
  Future<void> _cancel(BuildContext context, Booking value) async {
    final yes = await showDialog<bool>(context: context,
      builder: (c) => AlertDialog(title: const Text('Batalkan booking?'),
        content: const Text('Status booking demo akan berubah menjadi dibatalkan. Data riwayat tetap disimpan.'),
        actions: [TextButton(onPressed: () => Navigator.pop(c, false),
          child: const Text('Kembali')),
          TextButton(onPressed: () => Navigator.pop(c, true),
            child: const Text('Batalkan booking'))]));
    if (yes == true) {
      await controller.cancelBooking(value.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
        Text('Booking demo berhasil dibatalkan')));
    }
  }
}

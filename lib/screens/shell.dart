import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../state/booking_controller.dart';
import '../widgets/components.dart';
import 'stay_detail.dart';

class HomeShell extends StatefulWidget {
  final BookingController controller;
  const HomeShell({super.key, required this.controller});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final searchKey = GlobalKey<_SearchPageState>();
  void switchTab(int value) => setState(() => tab = value);
  void openCategory(String category) {
    switchTab(1);
    searchKey.currentState?.selectCategory(category);
  }
  void openStay(Stay stay) => Navigator.push(context, MaterialPageRoute(
    builder: (_) => StayDetail(stay: stay, controller: widget.controller)));
  @override
  Widget build(BuildContext context) {
    final screens = [
      DiscoverPage(controller: widget.controller, onOpen: openStay,
        onSearch: () => openCategory('Semua'), onCategory: openCategory,
        onBookings: () => switchTab(3)),
      SearchPage(key: searchKey, controller: widget.controller, onOpen: openStay),
      FavoritesPage(controller: widget.controller, onOpen: openStay,
        onExplore: () => switchTab(0)),
      TripsPage(controller: widget.controller, onExplore: () => switchTab(0)),
      ProfilePage(controller: widget.controller),
    ];
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(bottom: false, child: IndexedStack(index: tab, children: screens)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.08 : 0.035),
            blurRadius: 24, offset: const Offset(0, -8))]),
        child: SafeArea(top: false, child: SizedBox(height: 72,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _tabButton(0, Icons.explore_outlined, Icons.explore_rounded, 'Jelajah'),
            _tabButton(1, Icons.search_rounded, Icons.travel_explore_rounded, 'Cari'),
            _tabButton(2, Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorit'),
            _tabButton(3, Icons.airplane_ticket_outlined, Icons.airplane_ticket_rounded, 'Pesanan'),
            _tabButton(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
          ]))),
      ),
    );
  }
  Widget _tabButton(int index, IconData icon, IconData activeIcon, String text) {
    final selected = tab == index;
    return InkWell(onTap: () => switchTab(index),
      borderRadius: BorderRadius.circular(20), child: SizedBox(width: 66,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedContainer(duration: const Duration(milliseconds: 250),
            width: selected ? 45 : 39, height: 34,
            decoration: BoxDecoration(color: selected ? NColors.neon : Colors.transparent,
              borderRadius: BorderRadius.circular(13)),
            child: Icon(selected ? activeIcon : icon, size: 22,
              color: selected ? NColors.ink : NColors.slate)),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(fontSize: 10.5,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? Theme.of(context).colorScheme.onSurface : NColors.slate)),
        ])));
  }
}

class DiscoverPage extends StatelessWidget {
  final BookingController controller;
  final ValueChanged<Stay> onOpen;
  final VoidCallback onSearch, onBookings;
  final ValueChanged<String> onCategory;
  const DiscoverPage({super.key, required this.controller, required this.onOpen,
    required this.onSearch, required this.onCategory, required this.onBookings});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 18, 22, 14), child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: NColors.ink, borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.nights_stay_rounded, color: NColors.neon, size: 26)),
        const SizedBox(width: 9),
        const Text('nivora', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
        const Spacer(),
        CircleAction(icon: Icons.notifications_none_rounded, onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => NotificationsPage(controller: controller)))),
        const SizedBox(width: 9),
        CircleAction(icon: Icons.confirmation_num_outlined, onTap: onBookings),
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(22, 9, 22, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('GOOD VIBES. GREAT PLACES.',
            style: TextStyle(color: NColors.violet, letterSpacing: 2.3,
              fontWeight: FontWeight.w900, fontSize: 10.5)),
          const SizedBox(height: 7),
          Text('Pergi lebih jauh.\nRasakan lebih.',
            style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 17),
          InkWell(onTap: onSearch, borderRadius: BorderRadius.circular(20), child: Container(
            height: 60, padding: const EdgeInsets.symmetric(horizontal: 17),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Theme.of(context).dividerColor)),
            child: Row(children: [const Icon(Icons.search_rounded, size: 24),
              const SizedBox(width: 13),
              const Expanded(child: Text('Mau pergi ke mana?',
                style: TextStyle(color: NColors.slate, fontSize: 14.5))),
              Container(width: 39, height: 39,
                decoration: BoxDecoration(color: NColors.neon, borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.tune_rounded, color: NColors.ink, size: 20)),
            ]),
          )),
        ])),
      SizedBox(height: 104, child: ListView(scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 17), children: [
          _category(context, Icons.dashboard_customize_rounded, 'Semua', () => onCategory('Semua')),
          _category(context, Icons.hotel_rounded, 'Hotel', () => onCategory('Hotel')),
          _category(context, Icons.villa_rounded, 'Villa', () => onCategory('Villa')),
          _category(context, Icons.pool_rounded, 'Resort', () => onCategory('Resort')),
          _category(context, Icons.cabin_rounded, 'Cabin', () => onCategory('Cabin')),
          _category(context, Icons.kayaking_rounded, 'Aktivitas', () => onCategory('Aktivitas')),
        ])),
      Padding(padding: const EdgeInsets.fromLTRB(22, 10, 22, 24), child: InkWell(
        borderRadius: BorderRadius.circular(27), onTap: () => onOpen(catalog[0]),
        child: Container(height: 239, clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: NColors.midnight,
            borderRadius: BorderRadius.circular(27)),
          child: Stack(fit: StackFit.expand, children: [
            NetworkPhoto(catalog[0].image),
            DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.centerRight, end: Alignment.centerLeft,
              colors: [NColors.midnight.withValues(alpha: 0.15), NColors.midnight.withValues(alpha: 0.87)]))),
            Positioned(top: 18, left: 20, child: Pill('YOUR NEXT ESCAPE',
              bg: NColors.neon, fg: NColors.ink)),
            Positioned(left: 20, bottom: 22, right: 72, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('LIVE FOR THE\nMOMENTS.', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900,
                  fontSize: 29, height: 1.03, letterSpacing: -0.8)),
                const SizedBox(height: 9),
                const Text('Temukan stay paling menakjubkan\nuntuk cerita berikutnya.',
                  style: TextStyle(color: Color(0xFFE8EAF0), fontSize: 12.5, height: 1.4)),
              ])),
            Positioned(right: 19, bottom: 20, child: Container(width: 47, height: 47,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: NColors.neon),
              child: const Icon(Icons.north_east_rounded, color: NColors.ink))),
          ]),
        ),
      )),
      Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 14), child: SectionHeader(
        'Pilihan spesial', subtitle: 'Tempat yang bikin ingin berlama-lama',
        action: 'Lihat semua', onAction: onSearch)),
      SizedBox(height: 305, child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => StayCard(
          stay: catalog[index], controller: controller, onTap: () => onOpen(catalog[index])))),
      Padding(padding: const EdgeInsets.fromLTRB(22, 20, 22, 13), child: SectionHeader(
        'Weekend, unlocked.', subtitle: 'Lebih dekat, lebih menyenangkan')),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 22), child: Column(children: [
        for (final stay in catalog.skip(5).take(4)) ...[
          StayCard(stay: stay, controller: controller, compact: true, onTap: () => onOpen(stay)),
          const SizedBox(height: 12),
        ],
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(22, 12, 22, 40), child: Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(color: NColors.neon,
          borderRadius: BorderRadius.circular(25)),
        child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('NIVORA CLUB', style: TextStyle(fontSize: 10,
              fontWeight: FontWeight.w900, letterSpacing: 2)),
              SizedBox(height: 6),
              Text('Every trip\nhas its perks.', style: TextStyle(
                fontSize: 23, height: 1.03, letterSpacing: -0.6,
                fontWeight: FontWeight.w900, color: NColors.ink)),
              SizedBox(height: 6),
              Text('Kumpulkan poin dari tiap booking demo.',
                style: TextStyle(fontSize: 11.5, color: NColors.ink))])),
          const Icon(Icons.stars_rounded, size: 73, color: NColors.ink),
        ]),
      )),
    ]);
  }
  Widget _category(BuildContext context, IconData icon, String title, VoidCallback onTap) =>
    Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(20),
      child: Column(children: [
        Container(width: 57, height: 57,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
          child: Icon(icon, size: 26, color: NColors.violet)),
        const SizedBox(height: 7),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
      ])));
}

class SearchPage extends StatefulWidget {
  final BookingController controller;
  final ValueChanged<Stay> onOpen;
  const SearchPage({super.key, required this.controller, required this.onOpen});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final input = TextEditingController();
  void selectCategory(String nextCategory) => setState(() => category = nextCategory);
  String category = 'Semua';
  String sortBy = 'Rekomendasi';
  double maxPrice = 3500000;
  double minRating = 0;
  bool filterActive = false;
  @override
  void dispose() {input.dispose(); super.dispose();}
  @override
  Widget build(BuildContext context) {
    final q = input.text.toLowerCase().trim();
    final results = catalog.where((stay) {
      return (category == 'Semua' || stay.category == category) &&
        (q.isEmpty || '${stay.title} ${stay.location} ${stay.category}'.toLowerCase().contains(q)) &&
        stay.price <= maxPrice && stay.rating >= minRating;
    }).toList();
    if (sortBy == 'Termurah') results.sort((a,b) => a.price.compareTo(b.price));
    if (sortBy == 'Termahal') results.sort((a,b) => b.price.compareTo(a.price));
    if (sortBy == 'Rating tertinggi') results.sort((a,b) => b.rating.compareTo(a.rating));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 23, 22, 16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cari & temukan', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 5),
          const Text('Petualangan terbaik dimulai dari sini.',
            style: TextStyle(color: NColors.slate)),
          const SizedBox(height: 19),
          TextField(controller: input, onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(hintText: 'Nama hotel, kota atau destinasi',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: input.text.isEmpty ? null : IconButton(
                onPressed: () => setState(input.clear),
                icon: const Icon(Icons.close_rounded))),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(children: [for (final item in categories)
              Padding(padding: const EdgeInsets.only(right: 9),
                child: ChoiceChip(label: Text(item), selected: item == category,
                  onSelected: (_) => setState(() => category = item),
                  showCheckmark: false,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700,
                    color: item == category ? NColors.ink : null),
                  selectedColor: NColors.neon,
                  side: BorderSide.none,
                  backgroundColor: Theme.of(context).colorScheme.surface)),
            ])),
          const SizedBox(height: 15),
          Row(children: [
            Expanded(child: Text('${results.length} tempat ditemukan',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
            TextButton.icon(onPressed: _openFilters,
              icon: Icon(Icons.tune_rounded, size: 18,
                color: filterActive ? NColors.violet : NColors.slate),
              label: Text('Filter', style: TextStyle(color: filterActive ? NColors.violet : NColors.slate))),
            TextButton.icon(onPressed: _openSort,
              icon: const Icon(Icons.swap_vert_rounded, size: 18),
              label: const Text('Urutkan')),
          ]),
        ])),
      Expanded(child: results.isEmpty ? emptyState(context,
        icon: Icons.search_off_rounded, title: 'Belum ada yang cocok',
        subtitle: 'Coba kata kunci atau filter yang berbeda.',
        action: 'Reset filter', onAction: () => setState(() {
          input.clear(); category = 'Semua'; maxPrice = 3500000;
          minRating = 0; filterActive = false;
        })) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 13),
          itemBuilder: (context, i) => StayCard(stay: results[i],
            controller: widget.controller, compact: true,
            onTap: () => widget.onOpen(results[i])),
        )),
    ]);
  }
  void _openSort() => showModalBottomSheet<void>(context: context,
    builder: (sheetContext) => SafeArea(child: Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
      child: Column(mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Urutkan hasil', style: Theme.of(context).textTheme.headlineMedium),
          for (final value in ['Rekomendasi', 'Termurah', 'Termahal', 'Rating tertinggi'])
            RadioListTile<String>(title: Text(value), value: value,
              groupValue: sortBy, onChanged: (v) {
                if (v == null) return;
                setState(() => sortBy = v);
                Navigator.pop(sheetContext);
              }),
        ]))));
  void _openFilters() {
    double tempPrice = maxPrice;
    double tempRating = minRating;
    showModalBottomSheet<void>(context: context, isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(builder: (context, change) =>
        SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(23, 4, 23, 25),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Filter perjalanan', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 22),
              Row(children: [const Text('Maksimal harga', style: TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(), Text(rupiah(tempPrice),
                  style: const TextStyle(fontWeight: FontWeight.w900, color: NColors.violet))]),
              Slider(min: 500000, max: 3500000, divisions: 12, value: tempPrice,
                activeColor: NColors.violet, onChanged: (v) => change(() => tempPrice = v)),
              const SizedBox(height: 14),
              Row(children: [const Text('Minimal rating', style: TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(), Text(tempRating == 0 ? 'Semua' : '$tempRating+ ⭐',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: NColors.violet))]),
              Slider(min: 0, max: 4.8, divisions: 4, value: tempRating,
                activeColor: NColors.violet, onChanged: (v) => change(() => tempRating = v)),
              const SizedBox(height: 17),
              NButton('Terapkan filter', icon: Icons.arrow_forward_rounded,
                onPressed: () {setState(() {
                  maxPrice = tempPrice; minRating = tempRating; filterActive = true;
                }); Navigator.pop(sheetContext);}),
              const SizedBox(height: 9),
              TextButton(onPressed: () {setState(() {
                maxPrice = 3500000; minRating = 0; filterActive = false;
              }); Navigator.pop(sheetContext);}, child: const Center(child: Text('Reset filter'))),
            ])))));
  }
}

class FavoritesPage extends StatelessWidget {
  final BookingController controller;
  final ValueChanged<Stay> onOpen;
  final VoidCallback onExplore;
  const FavoritesPage({super.key, required this.controller,
    required this.onOpen, required this.onExplore});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller,
    builder: (context, _) {
      final saves = catalog.where((s) => controller.favorites.contains(s.id)).toList();
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Wishlist-ku', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 6),
              const Text('Simpan inspirasi, kunjungi nanti.',
                style: TextStyle(color: NColors.slate))])),
        Expanded(child: saves.isEmpty ? emptyState(context,
          icon: Icons.favorite_border_rounded,
          title: 'Belum ada wishlist',
          subtitle: 'Ketuk ikon hati pada tempat impianmu untuk menyimpannya.',
          action: 'Jelajahi sekarang', onAction: onExplore) :
          ListView.separated(padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
            itemCount: saves.length,
            separatorBuilder: (_, __) => const SizedBox(height: 13),
            itemBuilder: (_, index) => StayCard(stay: saves[index], controller: controller,
              compact: true, onTap: () => onOpen(saves[index])))),
      ]);
    });
}

class TripsPage extends StatefulWidget {
  final BookingController controller;
  final VoidCallback onExplore;
  const TripsPage({super.key, required this.controller, required this.onExplore});
  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  bool showUpcoming = true;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.controller,
    builder: (context, _) {
      final bookings = widget.controller.bookings.where((b) => showUpcoming
        ? b.isUpcoming : !b.isUpcoming).toList();
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(22, 23, 22, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Perjalanan saya', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 6),
            const Text('Semua momen berharga, di satu tempat.',
              style: TextStyle(color: NColors.slate)),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                _seg('Akan datang', true), _seg('Riwayat', false),
              ])),
          ])),
        Expanded(child: bookings.isEmpty ? emptyState(context,
          icon: Icons.luggage_outlined,
          title: showUpcoming ? 'Belum ada perjalanan' : 'Riwayat masih kosong',
          subtitle: showUpcoming ? 'Pesan destinasi impian dan e-ticket akan muncul di sini.'
            : 'Perjalanan selesai atau dibatalkan muncul di sini.',
          action: 'Eksplor destinasi', onAction: widget.onExplore)
          : ListView.separated(padding: const EdgeInsets.fromLTRB(22, 3, 22, 30),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, index) => _ticketCard(context, bookings[index]))),
      ]);
    });
  Widget _seg(String label, bool value) => Expanded(child: InkWell(
    borderRadius: BorderRadius.circular(12), onTap: () => setState(() => showUpcoming = value),
    child: Container(alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
        color: value == showUpcoming ? NColors.ink : Colors.transparent),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w800,
        color: value == showUpcoming ? Colors.white : NColors.slate)))));
  Widget _ticketCard(BuildContext context, Booking b) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24)),
    child: Column(children: [
      Row(children: [
        NetworkPhoto(b.stay.image, width: 105, height: 115, radius: BorderRadius.circular(16)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Pill(b.cancelled ? 'DIBATALKAN' : (b.isUpcoming ? 'TERKONFIRMASI' : 'SELESAI'),
            bg: b.cancelled ? const Color(0xFFFCE3E8) : NColors.neon),
          const SizedBox(height: 8),
          Text(b.stay.title, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 4),
          Text(b.stay.location, style: const TextStyle(color: NColors.slate, fontSize: 12)),
          const SizedBox(height: 7),
          Text(b.id, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800,
            color: NColors.violet)),
        ])),
      ]),
      const SizedBox(height: 14),
      Divider(color: Theme.of(context).dividerColor),
      Row(children: [
        const Icon(Icons.calendar_month_outlined, size: 18, color: NColors.slate),
        const SizedBox(width: 7),
        Expanded(child: Text('${prettyDate(b.start)} - ${prettyDate(b.end)}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        const Icon(Icons.people_outline_rounded, size: 16, color: NColors.slate),
        Text(' ${b.guests}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
      ]),
      const SizedBox(height: 14),
      NButton('Lihat e-ticket', icon: Icons.north_east_rounded,
        outlined: true, onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => TicketPage(booking: b, controller: widget.controller)))),
    ]),
  );
}

class ProfilePage extends StatelessWidget {
  final BookingController controller;
  const ProfilePage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller,
    builder: (context, _) => ListView(padding: const EdgeInsets.fromLTRB(22, 23, 22, 35), children: [
      Text('Akun & profil', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 19),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
        color: NColors.midnight, borderRadius: BorderRadius.circular(26)),
        child: Column(children: [
          Row(children: [
            Container(width: 61, height: 61,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [NColors.violet, Color(0xFFB692FF)]),
                borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 34)),
            const SizedBox(width: 13),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Traveler Nivora', style: TextStyle(color: Colors.white,
                fontSize: 19, fontWeight: FontWeight.w900)),
              SizedBox(height: 4),
              Text('Explorer Member', style: TextStyle(color: Color(0xFFB0B9D3), fontSize: 12)),
            ])),
            const Icon(Icons.verified_rounded, color: NColors.neon),
          ]),
          const SizedBox(height: 19),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
            color: const Color(0xFF27314D), borderRadius: BorderRadius.circular(19)),
            child: Row(children: [
              const Icon(Icons.stars_rounded, color: NColors.neon, size: 37),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${controller.rewardPoints} points',
                  style: const TextStyle(color: Colors.white, fontSize: 22,
                    fontWeight: FontWeight.w900)),
                const Text('Nivora rewards • versi demo',
                  style: TextStyle(color: Color(0xFFABB4CD), fontSize: 11)),
              ])),
              const Icon(Icons.auto_awesome_rounded, color: NColors.neon),
            ])),
        ])),
      const SizedBox(height: 23),
      Row(children: [
        _metric(context, '${controller.bookings.length}', 'Total booking'),
        const SizedBox(width: 10),
        _metric(context, '${controller.favorites.length}', 'Favorit'),
        const SizedBox(width: 10),
        _metric(context, 'Silver', 'Tier kamu'),
      ]),
      const SizedBox(height: 29),
      Text('PREFERENSI', style: Theme.of(context).textTheme.labelLarge?.copyWith(
        letterSpacing: 1.6, color: NColors.slate)),
      const SizedBox(height: 11),
      _row(context, Icons.dark_mode_outlined, 'Mode gelap',
        trailing: Switch(value: controller.darkMode,
          activeThumbColor: NColors.violet, onChanged: controller.setDarkMode)),
      _row(context, Icons.notifications_outlined, 'Notifikasi',
        trailing: Switch(value: controller.notificationsEnabled,
          activeThumbColor: NColors.violet, onChanged: controller.setNotifications)),
      _row(context, Icons.language_rounded, 'Bahasa', subtitle: 'Bahasa Indonesia',
        onTap: () => _info(context, 'Bahasa', 'Versi demo saat ini tersedia dalam Bahasa Indonesia.')),
      const SizedBox(height: 22),
      Text('DUKUNGAN', style: Theme.of(context).textTheme.labelLarge?.copyWith(
        letterSpacing: 1.6, color: NColors.slate)),
      const SizedBox(height: 11),
      _row(context, Icons.help_outline_rounded, 'Pusat bantuan',
        onTap: () => _info(context, 'Bantuan', 'Butuh bantuan? Proyek ini merupakan demo lokal. Integrasi pusat bantuan dapat ditambahkan melalui backend.')),
      _row(context, Icons.privacy_tip_outlined, 'Privasi & keamanan',
        onTap: () => _info(context, 'Privasi', 'Favorit dan booking demo disimpan di penyimpanan aplikasi pada perangkat ini.')),
      _row(context, Icons.info_outline_rounded, 'Tentang Nivora',
        onTap: () => _info(context, 'Nivora Booking v1.0',
          'Prototipe booking Flutter untuk demonstrasi UI/UX. Belum terhubung dengan inventori hotel, gateway pembayaran, atau layanan booking nyata.')),
      const SizedBox(height: 25),
      const Center(child: Text('MADE FOR THE MOMENTS  ✦  NIVORA',
        style: TextStyle(fontSize: 10, color: NColors.slate, letterSpacing: 1.3,
          fontWeight: FontWeight.w800))),
    ]));
  Widget _metric(BuildContext context, String value, String label) => Expanded(
    child: Container(padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18)),
      child: Column(children: [Text(value, style: const TextStyle(
        fontWeight: FontWeight.w900, fontSize: 19)), const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: NColors.slate))])));
  Widget _row(BuildContext context, IconData icon, String title,
    {String? subtitle, VoidCallback? onTap, Widget? trailing}) =>
    Padding(padding: const EdgeInsets.only(bottom: 8), child: Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(18), child: InkWell(
        borderRadius: BorderRadius.circular(18), onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(children: [
            Container(width: 43, height: 43,
              decoration: BoxDecoration(color: NColors.violet.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: NColors.violet, size: 21)),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
              if (subtitle != null) Text(subtitle,
                style: const TextStyle(fontSize: 11, color: NColors.slate)),
            ])),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: NColors.slate),
          ])))));
  void _info(BuildContext context, String title, String message) => showDialog<void>(
    context: context, builder: (c) => AlertDialog(title: Text(title),
      content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(c),
        child: const Text('Mengerti'))]));
}

class NotificationsPage extends StatelessWidget {
  final BookingController controller;
  const NotificationsPage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notifikasi')),
    body: AnimatedBuilder(animation: controller, builder: (context, _) =>
      ListView(padding: const EdgeInsets.all(22), children: [
        _notice(context, Icons.stars_rounded, 'Selamat datang di Nivora!',
          'Mulai temukan stay dan aktivitas terbaik untuk perjalananmu.', 'Baru saja'),
        for (final b in controller.bookings.take(6)) ...[
          const SizedBox(height: 12),
          _notice(context, b.cancelled ? Icons.cancel_outlined : Icons.check_circle_outline_rounded,
            b.cancelled ? 'Pemesanan demo dibatalkan' : 'Pemesanan demo berhasil!',
            '${b.stay.title} • ${b.id}', prettyDate(b.start)),
        ],
      ])));
  Widget _notice(BuildContext context, IconData icon, String title,
    String detail, String time) => Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 45, height: 45,
          decoration: BoxDecoration(color: NColors.neon,
            borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: NColors.ink)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 6), Text(detail, style: const TextStyle(
            color: NColors.slate, fontSize: 12)),
          const SizedBox(height: 8), Text(time, style: const TextStyle(
            color: NColors.violet, fontWeight: FontWeight.w700, fontSize: 11)),
        ])),
      ]));
}

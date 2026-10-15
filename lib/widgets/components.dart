import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../state/booking_controller.dart';

class Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  final IconData? icon;
  const Pill(this.text, {super.key, this.bg = NColors.neon,
    this.fg = NColors.ink, this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, color: fg, size: 13), const SizedBox(width: 5)],
      Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w900,
        fontSize: 10, letterSpacing: 0.65)),
    ]),
  );
}

class NButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool outlined, loading;
  const NButton(this.text, {super.key, required this.onPressed,
    this.icon, this.color, this.outlined = false, this.loading = false});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56, width: double.infinity,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0, backgroundColor: outlined ? Colors.transparent : (color ?? NColors.ink),
        foregroundColor: outlined ? Theme.of(context).colorScheme.onSurface : (color == NColors.neon ? NColors.ink : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19),
          side: outlined ? BorderSide(color: Theme.of(context).dividerColor) : BorderSide.none)),
      child: loading ? const SizedBox(width: 21, height: 21,
        child: CircularProgressIndicator(strokeWidth: 2.5)) :
        Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            if (icon != null) ...[const SizedBox(width: 12), Icon(icon, size: 19)]]),
    ),
  );
}

class NetworkPhoto extends StatelessWidget {
  final String url;
  final BorderRadius? radius;
  final double? width, height;
  final BoxFit fit;
  const NetworkPhoto(this.url, {super.key, this.radius, this.width, this.height, this.fit = BoxFit.cover});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: radius ?? BorderRadius.zero,
    child: Image.network(url, width: width, height: height, fit: fit,
      loadingBuilder: (context, child, progress) => progress == null ? child :
        Container(width: width, height: height, color: NColors.midnight,
          child: const Center(child: Icon(Icons.landscape_rounded, color: NColors.neon, size: 42))),
      errorBuilder: (context, error, stack) => Container(
        width: width, height: height,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF202F54), Color(0xFF8666F7)])),
        child: const Center(child: Icon(Icons.landscape_rounded, size: 55, color: Colors.white70))),
    ),
  );
}

class CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final Color? background;
  const CircleAction({super.key, required this.icon, required this.onTap, this.active = false, this.background});
  @override
  Widget build(BuildContext context) => Material(
    color: background ?? Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(18), child: InkWell(
      borderRadius: BorderRadius.circular(18), onTap: onTap,
      child: SizedBox(width: 45, height: 45,
        child: Icon(icon, size: 21, color: active ? const Color(0xFFF05C73) : Theme.of(context).colorScheme.onSurface)),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.subtitle, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!,
        style: const TextStyle(color: NColors.slate, fontSize: 12.5))],
    ])),
    if (action != null) TextButton(onPressed: onAction, child: Text(action!,
      style: const TextStyle(fontWeight: FontWeight.w800, color: NColors.violet))),
  ]);
}

class StayCard extends StatelessWidget {
  final Stay stay;
  final BookingController controller;
  final VoidCallback onTap;
  final bool compact;
  const StayCard({super.key, required this.stay, required this.controller,
    required this.onTap, this.compact = false});
  @override
  Widget build(BuildContext context) {
    if (compact) return _wide(context);
    return GestureDetector(onTap: onTap,
      child: SizedBox(width: 266, child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            NetworkPhoto(stay.image, width: 266, height: 193,
              radius: BorderRadius.circular(22)),
            Positioned(top: 12, left: 12, child: Pill(stay.tag, bg: Colors.white, fg: NColors.ink)),
            Positioned(right: 12, top: 12, child: AnimatedBuilder(animation: controller,
              builder: (context, _) => CircleAction(icon: controller.favorites.contains(stay.id)
                ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                active: controller.favorites.contains(stay.id),
                onTap: () => controller.toggleFavorite(stay.id)))),
          ]),
          const SizedBox(height: 13),
          Row(children: [const Icon(Icons.location_on_outlined, size: 15, color: NColors.slate),
            const SizedBox(width: 3), Expanded(child: Text(stay.location, maxLines: 1,
              overflow: TextOverflow.ellipsis, style: const TextStyle(color: NColors.slate, fontSize: 12))),
            const Icon(Icons.star_rounded, size: 17, color: Color(0xFFFFB84D)),
            Text(' ${stay.rating}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))]),
          const SizedBox(height: 5),
          Text(stay.title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('${rupiah(stay.price)}  / ${stay.isExperience ? 'orang' : 'malam'}',
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
        ])));
  }
  Widget _wide(BuildContext context) => InkWell(onTap: onTap,
    borderRadius: BorderRadius.circular(22), child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24)),
      child: Row(children: [
        Stack(children: [
          NetworkPhoto(stay.image, width: 117, height: 129, radius: BorderRadius.circular(18)),
          Positioned(top: 7, left: 7, child: Pill(stay.category,
            bg: Colors.white, fg: NColors.ink)),
        ]),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(stay.location, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: NColors.slate, fontSize: 11)),
            const SizedBox(height: 6),
            Text(stay.title, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 7),
            Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFFB84D), size: 16),
              Text(' ${stay.rating}  (${stay.reviews})',
                style: const TextStyle(fontSize: 11.5, color: NColors.slate))]),
            const SizedBox(height: 7),
            Text(shortRupiah(stay.price),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ])),
        AnimatedBuilder(animation: controller,
          builder: (context, _) => IconButton(
            icon: Icon(controller.favorites.contains(stay.id)
              ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: controller.favorites.contains(stay.id) ? const Color(0xFFF05C73) : NColors.slate),
            onPressed: () => controller.toggleFavorite(stay.id))),
      ]),
    ));
}

Widget emptyState(BuildContext context, {required IconData icon,
  required String title, required String subtitle, String? action, VoidCallback? onAction}) {
  return Center(child: Padding(padding: const EdgeInsets.all(30),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 100, height: 100,
        decoration: BoxDecoration(color: NColors.violet.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(30)),
        child: Icon(icon, size: 44, color: NColors.violet)),
      const SizedBox(height: 18),
      Text(title, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 9),
      Text(subtitle, textAlign: TextAlign.center,
        style: const TextStyle(color: NColors.slate)),
      if (action != null) ...[const SizedBox(height: 24),
        SizedBox(width: 220, child: NButton(action, onPressed: onAction))],
    ])));
}

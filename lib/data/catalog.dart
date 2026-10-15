import 'package:flutter/material.dart';

class Stay {
  final int id;
  final String title, location, category, image, tag, description, host;
  final int price, reviews;
  final double rating;
  final Color accent;
  final List<String> amenities, highlights;
  const Stay({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.image,
    required this.tag,
    required this.description,
    required this.host,
    required this.price,
    required this.reviews,
    required this.rating,
    required this.accent,
    required this.amenities,
    required this.highlights,
  });
  bool get isExperience => category == 'Aktivitas';
}

const categories = ['Semua', 'Hotel', 'Villa', 'Resort', 'Cabin', 'Aktivitas'];

const catalog = <Stay>[
  Stay(id: 1, title: 'Lumière Cliff Retreat', location: 'Ubud, Bali', category: 'Villa', image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1100&q=85', tag: 'MOST LOVED', description: 'Temukan tempat pelarian impian di tengah alam tropis, dengan panorama hijau, kolam privat, dan interior yang menyatukan kemewahan dengan ketenangan.', host: 'Nivora Signature', price: 1850000, reviews: 428, rating: 4.9, accent: Color(0xFFA8D2BD), amenities: ['Wi-Fi', 'Kolam privat', 'Sarapan', 'Parkir', 'AC', 'Spa'], highlights: ['Pemandangan lembah', 'Private pool', 'Desain tropis']),
  Stay(id: 2, title: 'Azure Bay Resort', location: 'Nusa Dua, Bali', category: 'Resort', image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1100&q=85', tag: 'BEST SELLER', description: 'Resort tropis dengan pemandangan air biru dan suasana pantai yang santai. Cocok untuk menikmati liburan berdua atau bersama keluarga.', host: 'Nivora Escapes', price: 2290000, reviews: 276, rating: 4.8, accent: Color(0xFF98C7F6), amenities: ['Wi-Fi', 'Pool', 'Sarapan', 'Gym', 'Spa', 'Restoran'], highlights: ['Infinity pool', 'Akses pantai', 'Sunset spot']),
  Stay(id: 3, title: 'The Ridge Cabin', location: 'Lembang, Bandung', category: 'Cabin', image: 'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=1100&q=85', tag: 'HIDDEN GEM', description: 'Kabur dari hiruk pikuk kota dan nikmati pagi berkabut serta udara sejuk di kabin kayu modern yang hangat.', host: 'Ridge Collection', price: 990000, reviews: 191, rating: 4.8, accent: Color(0xFFCADBB7), amenities: ['Wi-Fi', 'Perapian', 'Parkir', 'Breakfast', 'BBQ'], highlights: ['Forest view', 'Api unggun', 'Udara pegunungan']),
  Stay(id: 4, title: 'Sora Urban Hotel', location: 'Jakarta Pusat', category: 'Hotel', image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1100&q=85', tag: 'CITY FAVORITE', description: 'Hotel perkotaan premium dengan akses mudah ke tempat kuliner, belanja dan pusat bisnis. Suasana modern dan layanan yang hangat.', host: 'Sora Hospitality', price: 1190000, reviews: 592, rating: 4.7, accent: Color(0xFFD9C9FA), amenities: ['Wi-Fi', 'Gym', 'Sarapan', 'AC', 'Meeting room'], highlights: ['City lights', 'Rooftop lounge', 'Lokasi strategis']),
  Stay(id: 5, title: 'Serene Ocean Villas', location: 'Kuta, Lombok', category: 'Villa', image: 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=1100&q=85', tag: 'EXCLUSIVE', description: 'Villa tepi pantai dengan desain lapang, angin laut lembut dan ruang privat untuk rehat yang benar-benar terasa istimewa.', host: 'Serene Collection', price: 2790000, reviews: 144, rating: 5.0, accent: Color(0xFFF9CF9A), amenities: ['Wi-Fi', 'Private pool', 'Sarapan', 'AC', 'Beach'], highlights: ['Oceanfront', 'Private terrace', 'Sunrise']),
  Stay(id: 6, title: 'Maya Heritage Stay', location: 'Yogyakarta', category: 'Hotel', image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=1100&q=85', tag: 'CULTURE PICK', description: 'Akomodasi dengan sentuhan warisan budaya, taman yang teduh dan jarak terjangkau menuju beragam destinasi populer.', host: 'Maya Hotels', price: 790000, reviews: 337, rating: 4.7, accent: Color(0xFFDFC9B9), amenities: ['Wi-Fi', 'Sarapan', 'Restoran', 'AC', 'Parkir'], highlights: ['Heritage interior', 'Taman tropis', 'Lokasi pusat']),
  Stay(id: 7, title: 'Coral Sands Escape', location: 'Bintan, Kepulauan Riau', category: 'Resort', image: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1100&q=85', tag: 'WEEKEND DEAL', description: 'Nikmati weekend yang tenang di resort nyaman dekat garis pantai, sempurna untuk melepas penat.', host: 'Coral Resorts', price: 1540000, reviews: 205, rating: 4.8, accent: Color(0xFFBDE5D1), amenities: ['Wi-Fi', 'Pool', 'Sarapan', 'Parkir', 'Restoran'], highlights: ['Beach stroll', 'Sunset', 'Taman alami']),
  Stay(id: 8, title: 'Pine Hill Hideaway', location: 'Bogor, Jawa Barat', category: 'Cabin', image: 'https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?w=1100&q=85', tag: 'NATURE LOVER', description: 'Kabin minimalis dengan atmosfer alam, jalur jalan santai dan pemandangan hijau untuk liburan yang lebih lambat.', host: 'Pine Hill', price: 850000, reviews: 129, rating: 4.6, accent: Color(0xFFCCD8A5), amenities: ['Wi-Fi', 'BBQ', 'Parkir', 'Sarapan', 'Teras'], highlights: ['Forest walk', 'Outdoor terrace', 'Stargazing']),
  Stay(id: 9, title: 'Komodo Sunset Cruise', location: 'Labuan Bajo, NTT', category: 'Aktivitas', image: 'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=1100&q=85', tag: 'BUCKET LIST', description: 'Pengalaman menjelajahi laut dan pulau-pulau indah dalam wisata layar bertema sunset bersama pemandu.', host: 'Nivora Adventures', price: 650000, reviews: 312, rating: 4.9, accent: Color(0xFFF9D6A5), amenities: ['Pemandu', 'Minuman', 'Life jacket', 'Dokumentasi'], highlights: ['Sunset sailing', 'Island hopping', 'Foto panorama']),
  Stay(id: 10, title: 'Emerald Dive Discovery', location: 'Raja Ampat, Papua Barat Daya', category: 'Aktivitas', image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1100&q=85', tag: 'TOP EXPERIENCE', description: 'Jelajahi keindahan bawah laut melalui tur air berpendamping yang dirancang untuk pengalaman tak terlupakan.', host: 'Emerald Discovery', price: 1250000, reviews: 179, rating: 4.9, accent: Color(0xFFB2DED9), amenities: ['Pemandu', 'Peralatan', 'Briefing', 'Asuransi demo'], highlights: ['Underwater world', 'Guide session', 'Pulau tropis']),
];

Stay getStay(int id) => catalog.firstWhere((s) => s.id == id, orElse: () => catalog.first);

String rupiah(num amount) {
  final raw = amount.round().toString();
  final out = StringBuffer();
  for (int i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) out.write('.');
    out.write(raw[i]);
  }
  return 'Rp$out';
}

String shortRupiah(num amount) => amount >= 1000000
    ? 'Rp${(amount / 1000000).toStringAsFixed(2).replaceAll('.', ',')}jt'
    : 'Rp${(amount / 1000).round()}rb';

String prettyDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

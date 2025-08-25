// lib/core/services/hotel_image_service.dart
import 'dart:math';

class HotelImageService {
  // Curated list of reliable hotel/architecture photo IDs from Picsum
  static const List<int> _hotelPhotoIds = [
    1,
    2,
    3,
    5,
    8,
    9,
    10,
    11,
    12,
    13,
    15,
    16,
    17,
    18,
    20,
    21,
    22,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    33,
    34,
    35,
    36,
    37,
    39,
    40,
    42,
    43,
    44,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    98,
    99,
    100,
    101,
    102,
    103,
    104,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    119,
    120
  ];

  // Beautiful architecture/building IDs from Picsum
  static const List<int> _architecturePhotoIds = [
    159,
    160,
    161,
    162,
    164,
    165,
    169,
    174,
    175,
    176,
    180,
    181,
    184,
    188,
    190,
    193,
    195,
    197,
    200,
    201,
    202,
    204,
    206,
    208,
    209,
    210,
    211,
    212,
    213,
    214,
    216,
    217,
    218,
    219,
    220,
    222,
    225,
    227,
    228,
    230,
    232,
    235,
    238,
    239,
    240,
    244,
    247,
    249,
    250,
    252,
    256,
    257,
    258,
    260,
    267,
    270
  ];

  // Interior/room-like photos
  static const List<int> _interiorPhotoIds = [
    271,
    274,
    275,
    276,
    279,
    280,
    282,
    284,
    285,
    286,
    287,
    288,
    291,
    292,
    294,
    295,
    298,
    300,
    302,
    306,
    310,
    312,
    313,
    314,
    317,
    318,
    319,
    323,
    324,
    326,
    327,
    329,
    330,
    331,
    334,
    335,
    336,
    338,
    342,
    349,
    350,
    351
  ];

  // 1. Reliable Picsum with curated hotel-appropriate IDs
  static String reliablePicsumImage({
    required String seed,
    int width = 1000,
    int height = 600,
    String? category,
  }) {
    final random = Random(seed.hashCode);
    List<int> photoPool = [];

    // Select photo pool based on category
    switch (category?.toLowerCase()) {
      case 'luxury':
      case 'business':
        photoPool = _architecturePhotoIds;
        break;
      case 'beach':
      case 'romantic':
        photoPool = [..._hotelPhotoIds, ..._architecturePhotoIds];
        break;
      case 'family':
      case 'budget':
        photoPool = _interiorPhotoIds;
        break;
      default:
        photoPool = [
          ..._hotelPhotoIds,
          ..._architecturePhotoIds,
          ..._interiorPhotoIds
        ];
    }

    final photoId = photoPool[random.nextInt(photoPool.length)];
    return 'https://picsum.photos/id/$photoId/$width/$height';
  }

  // 2. JSONPlaceholder style with specific IDs
  static String jsonPlaceholderPhoto({
    required String seed,
    int width = 1000,
    int height = 600,
  }) {
    final random = Random(seed.hashCode);
    final photoId = _hotelPhotoIds[random.nextInt(_hotelPhotoIds.length)];
    return 'https://picsum.photos/id/$photoId/$width/$height';
  }

  // 3. Picsum with blur effect for variety
  static String blurredPicsumImage({
    required String seed,
    int width = 1000,
    int height = 600,
    int blurLevel = 1,
  }) {
    final random = Random(seed.hashCode);
    final photoId =
        _architecturePhotoIds[random.nextInt(_architecturePhotoIds.length)];
    return 'https://picsum.photos/id/$photoId/$width/$height?blur=$blurLevel';
  }

  // 4. Grayscale Picsum for variety
  static String grayscalePicsumImage({
    required String seed,
    int width = 1000,
    int height = 600,
  }) {
    final random = Random(seed.hashCode);
    final photoId = _hotelPhotoIds[random.nextInt(_hotelPhotoIds.length)];
    return 'https://picsum.photos/id/$photoId/$width/$height?grayscale';
  }

  // 5. Main method - Mix reliable sources
  static String diverseHotelImage({
    required String seed,
    int width = 1000,
    int height = 600,
    String? category,
  }) {
    final random = Random(seed.hashCode);
    final sourceType = random.nextInt(10); // Increase variety

    switch (sourceType) {
      case 0:
      case 1:
      case 2:
      case 3:
        // 40% chance - Main reliable source
        return reliablePicsumImage(
            seed: seed, width: width, height: height, category: category);
      case 4:
      case 5:
        // 20% chance - JSONPlaceholder style
        return jsonPlaceholderPhoto(seed: seed, width: width, height: height);
      case 6:
        // 10% chance - Slightly blurred for variety
        return blurredPicsumImage(
            seed: seed, width: width, height: height, blurLevel: 1);
      case 7:
        // 10% chance - Grayscale for artistic effect
        return grayscalePicsumImage(seed: seed, width: width, height: height);
      default:
        // 20% chance - Different photo pools
        return reliablePicsumImage(
            seed: '$seed-alt',
            width: width,
            height: height,
            category: category);
    }
  }

  // 6. Themed images with specific photo pools
  static String themedHotelImage({
    required String seed,
    required HotelTheme theme,
    int width = 1000,
    int height = 600,
  }) {
    final random = Random(seed.hashCode);
    List<int> themePhotoPool;

    switch (theme) {
      case HotelTheme.luxury:
      case HotelTheme.business:
        themePhotoPool = _architecturePhotoIds;
        break;
      case HotelTheme.beach:
      case HotelTheme.romantic:
        themePhotoPool = [
          ..._hotelPhotoIds.take(30),
          ..._architecturePhotoIds.take(20)
        ];
        break;
      case HotelTheme.family:
      case HotelTheme.budget:
        themePhotoPool = _interiorPhotoIds;
        break;
      case HotelTheme.city:
        themePhotoPool = _architecturePhotoIds;
        break;
    }

    final photoId = themePhotoPool[random.nextInt(themePhotoPool.length)];
    return 'https://picsum.photos/id/$photoId/$width/$height';
  }

  // 7. Fallback images with guaranteed working URLs
  static List<String> getFallbackImages({
    int width = 1000,
    int height = 600,
  }) {
    return [
      'https://picsum.photos/id/164/$width/$height', // Architecture
      'https://picsum.photos/id/180/$width/$height', // Building
      'https://picsum.photos/id/206/$width/$height', // Modern
      'https://picsum.photos/id/225/$width/$height', // Clean
      'https://picsum.photos/$width/$height', // Random fallback
    ];
  }
}

enum HotelTheme { luxury, beach, city, business, family, romantic, budget }

// Extension để dễ sử dụng
extension HotelImageExtension on String {
  String toHotelImageUrl(
      {int width = 1000, int height = 600, String type = 'general'}) {
    return HotelImageService.diverseHotelImage(
        seed: this, width: width, height: height);
  }
}

// Cách sử dụng trong HomeScreen:
class HotelImageHelper {
  // Thay thế method _picsumSeed cũ
  static String getHotelImage(String seed, int w, int h, {String? category}) {
    // Có thể random giữa các nguồn khác nhau
    return HotelImageService.diverseHotelImage(
        seed: seed, width: w, height: h, category: category);
  }

  // Lấy ảnh theo category cụ thể
  static String getCategoryImage(String seed, String category, int w, int h) {
    final themeMap = {
      'Beach': HotelTheme.beach,
      'City': HotelTheme.city,
      'Business': HotelTheme.business,
      'Family': HotelTheme.family,
      'Romantic': HotelTheme.romantic,
      'Budget': HotelTheme.budget,
      'Luxury': HotelTheme.luxury,
    };

    final theme = themeMap[category];
    if (theme != null) {
      return HotelImageService.themedHotelImage(
          seed: seed, theme: theme, width: w, height: h);
    }

    return HotelImageService.diverseHotelImage(seed: seed, width: w, height: h);
  }
}

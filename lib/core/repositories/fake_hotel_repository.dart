import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter_ui_kit_hotel/core/models/hotel.dart';
import 'package:flutter_ui_kit_hotel/core/models/result.dart';
import 'package:flutter_ui_kit_hotel/core/services/hotel_image_service.dart';

class FakeHotelRepository {
  final _faker = Faker();
  final _rand = Random();

  Future<Result<List<Hotel>>> fetchFeatured(String category) async {
    await Future.delayed(Duration(milliseconds: 600 + _rand.nextInt(600)));
    // 15% lỗi
    if (_rand.nextDouble() < 0.15) {
      return Failure(Exception('Network error: Featured'));
    }
    // 10% empty với một số category
    if (category != 'All' && _rand.nextDouble() < 0.10) {
      return const Success([]);
    }
    final list = List.generate(5, (i) => _buildHotel('featured-$i', category));
    return Success(list);
  }

  Future<Result<List<Hotel>>> fetchPopular(String category) async {
    await Future.delayed(Duration(milliseconds: 700 + _rand.nextInt(800)));
    if (_rand.nextDouble() < 0.15) {
      return Failure(Exception('Network error: Popular'));
    }
    if (category == 'Business' && _rand.nextDouble() < 0.15) {
      return const Success([]);
    }
    final list = List.generate(10, (i) => _buildHotel('popular-$i', category));
    return Success(list);
  }

  Hotel _buildHotel(String id, String category) {
    final city = _faker.address.city();
    final title = _faker.company.name();
    final price = '\$${120 + (_rand.nextInt(10) * 15)}/night';
    final rating = (3.5 + (_rand.nextInt(3) * 0.5)).clamp(3.0, 5.0);
    final seed = '$id-${_rand.nextInt(9999)}';
    final img = category != 'All'
        ? HotelImageHelper.getCategoryImage(seed, category, 1000, 600)
        : HotelImageService.diverseHotelImage(
            seed: seed, width: 1000, height: 600);

    return Hotel(
      id: id,
      title: title,
      imageUrl: img,
      price: price,
      rating: rating.toDouble(),
      location: city,
      category: category,
    );
  }
}

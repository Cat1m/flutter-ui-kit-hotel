class Hotel {
  final String id;
  final String title;
  final String imageUrl;
  final String price; // mock string, sẽ format locale sau
  final double rating;
  final String location;
  final String category;

  const Hotel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.location,
    required this.category,
  });
}

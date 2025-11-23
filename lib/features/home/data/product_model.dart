class ProductModel {
  final int id;
  final String name;
  final String desc;
  final String image;
  final String price;
  final String rating;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.rating,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    bool forceFavorite = false,
  }) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "No Name",
      desc: json['description'] ?? "No Description",
      image: json['image'] ?? "",
      price: json['price']?.toString() ?? "0",
      rating: json['rating']?.toString() ?? "0",

      isFavorite: forceFavorite ? true : (json['is_favorite'] ?? false),
    );
  }
}

class CategoryModel {
  final int code;
  final String message;
  final List<FoodCategory> data;

  CategoryModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? "No Message",
      data: (json['data'] as List)
          .map((e) => FoodCategory.fromJson(e))
          .toList(),
    );
  }
}

class FoodCategory {
  final int id;
  final String name;
  FoodCategory({required this.id, required this.name});
  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(id: json['id'] ?? 0, name: json['name'] ?? "No Name");
  }
}

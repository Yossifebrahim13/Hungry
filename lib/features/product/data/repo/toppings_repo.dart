import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/features/product/data/models/toppings_model.dart';

class ToppingsRepo {
  final ApiService _apiService = ApiService();

  /// GET TOPPINGS

  Future<List<ToppingsModel?>> getToppings() async {
    try {
      final response = await _apiService.get('/toppings');
      return (response['data'] as List)
          .map((topping) => ToppingsModel.fromJson(topping))
          .toList();
    } catch (e) {
      print("Error in toppings is ${e.toString()}");
      return [];
    }
  }
}

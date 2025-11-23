import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/features/product/data/models/sideOptions_model.dart';

class SideOptionsRepo {
  final ApiService _apiService = ApiService();

  /// GET Side Options

  Future<List<SideOptionsModel?>> getSideOptions() async {
    try {
      final response = await _apiService.get('/side-options');
      return (response['data'] as List)
          .map((sideOption) => SideOptionsModel.fromJson(sideOption))
          .toList();
    } catch (e) {
      print("Error in sideOption is ${e.toString()}");
      return [];
    }
  }
}

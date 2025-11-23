import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/cart/data/model/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();

  /// 🛒 Add to cart
  Future<void> addToCart(CartItemModel cartData) async {
    try {
      // 🔐 Print token before sending request
      final token = await PrefHelpers.getToken();
      print("🔐 TOKEN USED => $token");

      final response = await _apiService.post('/cart/add', cartData.toJson());

      print("🛒 Add to Cart response: $response");
      print("🧪 BODY SENT => ${cartData.toJson()}");

      if (response != null && response is Map<String, dynamic>) {
        final code = response['code'] ?? 0;
        if (code == 200) {
          print("✅ Product added successfully to cart");
        }
      } else {
        throw ApiErrors(message: "Invalid server response");
      }
    } catch (e) {
      if (e is ApiErrors) rethrow;

      print("❌ Error adding to cart: $e");
      throw ApiErrors(message: e.toString());
    }
  }

  /// 📦 Get Cart Items
  Future<GetCartModel?> getCartItems() async {
    try {
      final response = await _apiService.get('/cart');
      print("📦 Cart API response: $response");

      // Validate response type
      if (response == null || response is! Map<String, dynamic>) {
        print("❌ Invalid or empty response from server");
        return null;
      }

      // Check for valid structure and success code
      final code = response['code'];
      final message = response['message'];

      if (code != 200) {
        print("❌ Server returned error: $message");
        return null;
      }

      // Ensure data key exists
      if (response['data'] == null) {
        print("⚠️ No data field found in response");
        return null;
      }

      // Parse and return cart data safely
      final model = GetCartModel.fromJson(response);
      print(
        "✅ Cart parsed successfully with ${model.cartData.items.length} items",
      );
      return model;
    } catch (e) {
      print("❌ Exception caught in getCartItems: $e");
      return null;
    }
  }

  /// 🗑️ Delete item from cart
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      final res = await _apiService.delete('/cart/remove/$cartItemId', {});
      print("🗑️ Delete Cart Item response: $res");
      if (res is Map<String, dynamic>) {
        final code = res['code'] ?? 0;
        final message = res['message']?.toString() ?? 'Unknown error';

        if (code == 200) {
          print("✅ Cart Item Deleted Successfully: $message");
        } else {
          print("⚠️ Failed to delete cart item: $message");
          throw ApiErrors(message: message);
        }
      } else if (res is String) {
        print("⚠️ Delete failed: $res");
        throw ApiErrors(message: res);
      } else {
        print("⚠️ Unexpected delete response: $res");
        throw ApiErrors(message: 'Invalid response from server');
      }
    } catch (e) {
      if (e is ApiErrors) {
        rethrow;
      } else {
        print("❌ Error deleting cart item: $e");
        throw ApiErrors(message: e.toString());
      }
    }
  }
}

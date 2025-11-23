import 'package:get/get.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/data/model/cart_model.dart';

class CartController extends GetxController {
  final CartRepo cartRepo = CartRepo();

  var isGuest = false.obs;
  var isLoading = true.obs;
  var isDeleting = false.obs;

  Rx<GetCartModel?> cartModel = Rx<GetCartModel?>(null);

  RxList<int> quantities = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    final token = await PrefHelpers.getToken();

    if (token == null || token.isEmpty || token == "guest") {
      isGuest.value = true;
    } else {
      isGuest.value = false;
      getCartItems();
    }
  }

  Future<void> getCartItems() async {
    isLoading.value = true;

    final res = await cartRepo.getCartItems();

    if (res != null && res.cartData.items.isNotEmpty) {
      cartModel.value = res;
      quantities.value = List.generate(res.cartData.items.length, (_) => 1);
    } else {
      cartModel.value = null;
    }

    isLoading.value = false;
  }

  Future<void> deleteCartItem(int itemId) async {
    try {
      isDeleting.value = true;

      await cartRepo.deleteCartItem(itemId);

      await getCartItems();
    } finally {
      isDeleting.value = false;
    }
  }

  double calculateTotalPrice() {
    final model = cartModel.value;
    if (model == null) return 0.0;

    double total = 0.0;

    for (int i = 0; i < model.cartData.items.length; i++) {
      final item = model.cartData.items[i];
      final quantity = quantities[i];

      final price = double.tryParse(item.price) ?? 0.0;
      final spicy = item.spicy;

      total += (price + spicy) * quantity;
    }

    return total;
  }
}

class CartModel {
  final int productId;
  final int quantity;
  final double? spicy;
  final List<int> toppings;
  final List<int> sideOptions;

  CartModel({
    required this.productId,
    required this.quantity,
    this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    double spicyDouble = 0.0;
    if (json["spicy"] != null) {
      if (json["spicy"] is String) {
        spicyDouble = double.tryParse(json["spicy"]) ?? 0.0;
      } else if (json["spicy"] is int) {
        spicyDouble = (json["spicy"] as int).toDouble();
      } else if (json["spicy"] is double) {
        spicyDouble = json["spicy"];
      }
    }

    return CartModel(
      productId: json["product_id"] ?? 0,
      quantity: json["quantity"] ?? 0,
      toppings: List<int>.from(json["toppings"] ?? []),
      sideOptions: List<int>.from(json["side_options"] ?? []),
      spicy: spicyDouble,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
    'toppings': toppings,
    'side_options': sideOptions,
    if (spicy != null) 'spicy': spicy,
  };
}

class CartItemModel {
  final List<CartModel> items;

  CartItemModel({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class GetCartModel {
  final int code;
  final String message;
  final CartData cartData;

  GetCartModel({
    required this.code,
    required this.message,
    required this.cartData,
  });

  factory GetCartModel.fromJson(Map<String, dynamic> json) {
    return GetCartModel(
      code: json["code"] ?? 0,
      message: json["message"] ?? '',
      cartData: CartData.fromJson(json["data"] ?? {}),
    );
  }
}

class CartData {
  final int id;
  final String totalPrice;
  final List<CartItem> items;

  CartData({required this.id, required this.totalPrice, required this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    String totalPriceString = (json["total_price"] != null)
        ? json["total_price"].toString()
        : '0.0';

    return CartData(
      id: json["id"] ?? 0,
      totalPrice: totalPriceString,
      items:
          (json["items"] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CartItem {
  final int itemId;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final String price;
  final double spicy;
  final List<Map<String, dynamic>> toppings;
  final List<Map<String, dynamic>> sideOptions;

  CartItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    String priceString = (json["price"] != null)
        ? json["price"].toString()
        : '0.0';

    double spicyDouble = 0.0;
    if (json["spicy"] != null) {
      if (json["spicy"] is String) {
        spicyDouble = double.tryParse(json["spicy"]) ?? 0.0;
      } else if (json["spicy"] is int) {
        spicyDouble = (json["spicy"] as int).toDouble();
      } else if (json["spicy"] is double) {
        spicyDouble = json["spicy"];
      }
    }

    return CartItem(
      itemId: json["item_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      productName: json["name"] ?? '',
      productImage: json["image"] ?? '',
      quantity: json["quantity"] ?? 0,
      price: priceString,
      spicy: spicyDouble,
      toppings:
          (json["toppings"] as List?)
              ?.map(
                (t) => {"id": t["id"], "name": t["name"], "image": t["image"]},
              )
              .toList() ??
          [],
      sideOptions:
          (json["side_options"] as List?)
              ?.map(
                (s) => {"id": s["id"], "name": s["name"], "image": s["image"]},
              )
              .toList() ??
          [],
    );
  }
}

class Topping {
  final int id;
  final String name;
  final String image;

  Topping({required this.id, required this.name, required this.image});

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      image: json["image"] ?? '',
    );
  }
}

class SideOption {
  final int id;
  final String name;
  final String image;

  SideOption({required this.id, required this.name, required this.image});

  factory SideOption.fromJson(Map<String, dynamic> json) {
    return SideOption(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      image: json["image"] ?? '',
    );
  }
}

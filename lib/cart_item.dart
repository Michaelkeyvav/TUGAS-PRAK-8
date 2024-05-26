import 'food_menu.dart';

// class CardItem {
//   late FoodMenu foodMenu;
//   late int quantity;
  
//   CartItem({required this.foodMenu, this.quantity = 1})
// }

class CartItem {
  final FoodMenu foodMenu;
  final int? quantity;

  CartItem({required this.foodMenu, this.quantity = 1});
}
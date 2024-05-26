import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'food_menu.dart';
import 'cart_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Flutter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 44, 15, 175), backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CartItem> _cartItems = [];

  void _addToCart(FoodMenu foodMenu) {
    setState(() {
      _cartItems.add(CartItem(foodMenu: foodMenu));
      for (var element in _cartItems) {
        debugPrint(element.foodMenu.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Selamat datang di Praktikum Flutter!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(
                        cartItems: _cartItems,
                        addToCart: _addToCart,
                      ),
                    ),
                  );
                },
                child: const Text('Menu'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
                child: const Text('About'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(FoodMenu) addToCart;

  const MenuPage({super.key, required this.cartItems, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartDialog(cartItems: cartItems)),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 216, 3, 205),
        child: GridView.builder(
          itemCount: foodMenus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailPage(
                      foodMenu: foodMenus[index],
                      addToCart: addToCart,
                      cartItems: cartItems,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          foodMenus[index].imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            foodMenus[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Rp ${foodMenus[index].price.toStringAsFixed(0)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final FoodMenu foodMenu;
  final Function(FoodMenu) addToCart;
  final List<CartItem> cartItems;
  // const FoodDetailPage({super.key, required this.foodMenu, required this.addToCart});
  // ignore: use_key_in_widget_constructors
  const FoodDetailPage({Key? key, required this.foodMenu, required this.addToCart, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodMenu.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartDialog(cartItems: cartItems)),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 236, 233, 9),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(foodMenu.imageUrl),
                const SizedBox(height: 16),
                Text(
                  foodMenu.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Harga: Rp. ${foodMenu.price.toStringAsFixed(0)}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    addToCart(foodMenu);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${foodMenu.name} ditambahkan ke keranjang'),
                      ),
                    );
                  },
                  child: const Text('Tambah Ke Keranjang'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartDialog extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartDialog({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final double totalPrice = cartItems.fold<double>(0, (sum, item) => sum + (item.foodMenu.price * (item.quantity ?? 1)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
      ),
      body: Container(
        color: Color.fromARGB(255, 42, 6, 139),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Image.network(
                        cartItems[index].foodMenu.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(cartItems[index].foodMenu.name),
                      subtitle: Text('Rp. ${cartItems[index].foodMenu.price.toStringAsFixed(0)} x ${cartItems[index].quantity ?? 1}'),
                      trailing: Text('Rp. ${(cartItems[index].foodMenu.price * (cartItems[index].quantity ?? 1)).toStringAsFixed(0)}'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Total Price Rp. ${totalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 187, 13, 13),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frontier Restaurant',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Foto Luar Restaurant: '),
                const SizedBox(height: 8),
                Image.network('https://images.nanawall.com/blog/2023-06/Benefits_of_Outdoor_Seating_Blog-1.jpg?auto=format&fit=max'),
                const SizedBox(height: 16),
                const Text('Foto Interior Restaurant: '),
                const SizedBox(height: 8),
                Image.network('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D'),
                const SizedBox(height: 16),
                const Text('Restaurant Location: '),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://maps.app.goo.gl/YbtR98noWUy9QmGCA');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View on Google Maps'),
                      SizedBox(width: 8),
                      Icon(Icons.map),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<FoodMenu> foodMenus = [
  FoodMenu(
    imageUrl: 'https://www.helpguide.org/wp-content/uploads/fast-foods-candy-cookies-pastries-768.jpg',
    name: 'Fast Food',
    price: 20000,
  ),
  FoodMenu(
    imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/pasta-salad-horizontal-jpg-1522265695.jpg?crop=1.00xw:0.846xh;0,0',
    name: 'Fruits',
    price: 1000,
  ),
  FoodMenu(
    imageUrl: 'https://food-images.files.bbci.co.uk/food/recipes/cobb_salad_62368_16x9.jpg',
    name: 'Salad',
    price: 40000,
  ),
  FoodMenu(
    imageUrl: 'https://asset.kompas.com/crops/C9MxtQFZfFwAxPjSuPMpGreL_OA=/0x11:968x656/750x500/data/photo/2022/12/01/638874fa50147.jpg',
    name: 'Steak',
    price: 100000,
  ),
  FoodMenu(
    imageUrl: 'https://akcdn.detik.net.id/visual/2021/12/02/croffle_11.jpeg?w=480&q=90',
    name: 'Dessert',
    price: 34000,
  ),
];
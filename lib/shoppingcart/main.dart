import 'package:flutter/material.dart';

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shopping List', home: Scaffold(body: ShoppingPlanner()));
  }
}

// START OF ALEX STUFF >>>
// Implement adding and removing products
class ShoppingPlanner extends StatefulWidget {
  const ShoppingPlanner({super.key});

  @override
  State<ShoppingPlanner> createState() => ShoppingPlannerState();
}

class ShoppingPlannerState extends State<ShoppingPlanner> {
  final productList = <Product>[];

  bool checkProductAddedByString(String text) {
    return productList.map((product) {
      return product.name;
    }).contains(text);
  }

  void handleAddProductByString(String text) {
    setState(() {
      final Product newProduct = Product(name: text);
      productList.add(newProduct);
    });
  }

  void handleRemoveProduct(Product product) {
    setState(() {
      if (productList.contains(product)) {
        productList.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ShoppingList(
              products: productList, handleRemoveProduct: handleRemoveProduct)),
      ProductInput(
          handleAddProduct: handleAddProductByString,
          checkProductAdded: checkProductAddedByString)
    ]);
  }
}

typedef HandleProductByStringCallback = Function(String text);

class ProductInput extends StatelessWidget {
  ProductInput({
    required this.handleAddProduct,
    required this.checkProductAdded,
    super.key,
  });
  final HandleProductByStringCallback handleAddProduct;
  final HandleProductByStringCallback checkProductAdded;

  final productNameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: productNameInputController,
        onSubmitted: (String productName) {
          if (checkProductAdded(productName)) {
            return;
          }
          handleAddProduct(productName);
          productNameInputController.clear();
        });
  }
}
// <<< END OF ALEX STUFF

// START OF TUTORIAL STUFF >>>
// src: https://docs.flutter.dev/development/ui/widgets-intro

class Product {
  const Product({required this.name});

  final String name;
}

// Dart's typedef ~ TypeScript's type
typedef CartChangedCallback = Function(Product product, bool inCart);
// ALEX STUFF >>>
typedef ProductCallback = Function(Product product);
// <<< ALEX STUFF

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
    required this.removeProduct,
  }) : super(key: ObjectKey(product));

  // Common stateless widget pattern: Store "prop" values from constructor in `final` member variables
  // `final` variables used in build()
  // Pattern enables storing state higher in widget hierarhcy, which causes longer state persistence
  // onPress: widget calls onCartChange function received from parent widget, triggers parent state update (and rebuild)
  // Parent rebuild creates new instance of ShoppingListsItem
  // State passed to runApp() persists for application lifetime
  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;
  // ALEX STUFF >>>
  final ProductCallback removeProduct;
  // <<< ALEX STUFF

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onCartChanged(product, inCart);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(product.name[0]),
        ),
        title: Text(product.name, style: _getTextStyle(context)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () => removeProduct(product), child: Text('X'))
          ],
        ));
  }
}

// StatefulWidgets store mutable state
class ShoppingList extends StatefulWidget {
  const ShoppingList(
      {required this.products, required this.handleRemoveProduct, super.key});

  final List<Product> products;
  // ALEX STUFF >>>
  final ProductCallback handleRemoveProduct;
  // <<< ALEX STUFF

  // The framework calls createState the first time
  // a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

// _) indicates private implementation details
class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>{};

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need
      // to change _shoppingCart inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  // To access properties of ShoppingList, _ShoppingListState uses its widget property
  // When handling onCartChanged callback, _ShoppingListState mutates its internal state
  // by either adding or removing a product from _shoppingCart.
  //
  // setState signals to Flutter that widget changed its internal state; marks widget as dirty and
  // schedules it to be rebuilt the next time app needs to update the screen.
  //
  // Without setState call wrapping widget's internal state modifications, Flutter won't know
  // widget is dirty --> might not call widget's build() function --> UI won't reflect changed state
  //
  // By managing state in this way, you don’t need to write separate code for creating and updating child widgets.
  // Instead, you simply implement the build function, which handles both situations.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((product) {
          return ShoppingListItem(
              product: product,
              inCart: _shoppingCart.contains(product),
              onCartChanged: _handleCartChanged,
              // ALEX STUFF >>>
              removeProduct: widget.handleRemoveProduct
              // <<< ALEX STUFF
              );
        }).toList(),
      ),
    );
  }
}

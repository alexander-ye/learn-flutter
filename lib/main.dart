import 'package:flutter/material.dart';
import './default/main.dart'; // MyApp (counter button app)
import './randomwordpairgenerator/main.dart'; // RandomWordPairGeneratorApp
import './shoppingcart/main.dart'; // ShoppingCartApp

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    // Replace the return value with an App of interest
    return ShoppingCartApp();
  }
}

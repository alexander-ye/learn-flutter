import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

// Widgets are components.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider is equivalent to React Context?
    return ChangeNotifierProvider(
      // create is similar to Context.Provider's value
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

// A widget's state gets defined as a class separate from the actual widget?
class AppState extends ChangeNotifier {
  // State data goes here
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    // So I need to call this notifyListeners method otherwise AppState watchers don't rerender?
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  // Widget's build() method is equivalent to component's render() method
  // build() gets called every time relevant state changes and must return a widget
  Widget build(BuildContext context) {
    print('render widget');
    // context.watch is Flutter's useContext(AppContext);
    // child widgets rerender even if they don't themselves call context.watch
    // it seems all child widgets rerender if a parent's state changes, even if only
    // some of the child widgets call context.watch
    // var appState = context.watch<AppState>();
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Text('Some random text:'),
          TestText(),
          TestChangeButton(),
          TestButton(),
        ],
      ),
    ));
  }
}

class TestText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('render test text');
    var appState = context.watch<AppState>();
    return Text(appState.current.asLowerCase);
  }
}

class TestChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('render test changebutton');
    var appState = context.watch<AppState>();
    return ElevatedButton(
      onPressed: () {
        appState.getNext();
      },
      child: Text('Next'),
    );
  }
}

class TestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('render test button widget');
    return ElevatedButton(
      onPressed: () {
        print('TEST');
      },
      child: Text('Next'),
    );
  }
}

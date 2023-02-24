import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

// Fluter Widgets === React Components
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter's ChangeNotifierProvider ~ React's Context
    return ChangeNotifierProvider(
      // create: (context) => AppState() ~ <Context.Provider value={appStateWithSetters}>
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

// Widget's state defined as a class separate from rendered widget?
class AppState extends ChangeNotifier {
  // Current word pair to display
  var current = WordPair.random();

  // Generate new word pair
  void getNext() {
    current = WordPair.random();
    // Flutter "context" provider requires additional notify function
    notifyListeners();
  }

  // Flutter is strongly typed; Dart refueses to run if type safety gets broken. Nice.
  // [] indicates List, {} indicates Set
  var favorites = <WordPair>{};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  // Flutter Widget's build() == React component's render()
  // build() must return a widget, gets called every time "relevant" state changes
  Widget build(BuildContext context) {
    print('render HomeScreen');
    // Flutter's context.watch<AppState>() === React's useContext(AppContext);
    // Observation: child widgets rerender even if they don't themselves call context.watch
    // (it seems all widgets rerender if a parent's state changes, even if only
    // some child widgets call context.watch)
    var appState = context.watch<AppState>();
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RandomTextCard(pair: appState.current),
            SizedBox(height: 10),
            Row(
              // Prevent Row from taking all available horizontal space
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleFavoriteButton(),
                SizedBox(width: 10),
                ChangeTextButton(),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class RandomTextCard extends StatelessWidget {
  const RandomTextCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    print('render RandomTextCard');
    var theme = Theme.of(context);
    // ! bypasses null safety, use when "potentially null" var is "definitely not null"
    var style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.secondary,
      shadowColor: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          // semanticsLabel for accessibility (e.g. screen readers)
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

class ToggleFavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('render ToggleFavoriteButton');
    var appState = context.watch<AppState>();
    var favorited = appState.favorites.contains(appState.current);
    return ElevatedButton.icon(
      onPressed: () {
        appState.toggleFavorite();
      },
      icon: FavoriteButtonIcon(favorited: favorited),
      label: FavoriteButtonText(favorited: favorited),
    );
  }
}

class FavoriteButtonText extends StatelessWidget {
  const FavoriteButtonText({
    Key? key,
    required this.favorited,
  }) : super(key: key);

  final bool favorited;
  @override
  Widget build(BuildContext context) {
    print('render FavoriteButtonHeart');
    if (favorited) {
      return Text('Remove');
    }
    return Text('Favorite');
  }
}

class FavoriteButtonIcon extends StatelessWidget {
  const FavoriteButtonIcon({
    Key? key,
    required this.favorited,
  }) : super(key: key);

  final bool favorited;
  @override
  Widget build(BuildContext context) {
    print('render FavoriteButtonHeart');
    if (favorited) {
      return Icon(Icons.favorite);
    }
    return Icon(Icons.favorite_outline);
  }
}

class ChangeTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('render ChangeTextButton');
    var appState = context.watch<AppState>();
    return ElevatedButton(
      onPressed: () {
        appState.getNext();
      },
      child: Text('Next'),
    );
  }
}

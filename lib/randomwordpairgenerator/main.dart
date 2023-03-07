import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Fluter Widgets === React Components
class RandomWordPairGeneratorApp extends StatelessWidget {
  const RandomWordPairGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('render App');
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
        home: Home(),
      ),
    );
  }
}

// Widget's state defined as a class separate from rendered widget?
// In Flutter, Widgets and State have different lifecycles:
// Widgets: temporary, construct presentation of application in current state, build() called on every state change
// State: persistent between Widget build() calls---can remember information
// Like child useEffects in React, change notifications flow up
// Like state hierarchy in React, state flows down
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

  void removeFavorite(WordPair wordpair) {
    favorites.remove(wordpair);
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      removeFavorite(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

// _ makes class private, enforced by compiler
// State enables widget to manage its own values, which persist across renders
class _HomeState extends State<Home> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    print('render Home');

    Widget page;
    Widget appbartitle;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        appbartitle = Text('Word Pair Generator');
        break;
      case 1:
        page = FavoritesPage();
        appbartitle = Text('Favorite Pairs');
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // For web, we might want to use LayoutBuilder (to change widget tree depending on available space) with NavigationRail
    // LayoutBuilder's builder() called every time constraints change (e.g. resize app window, rotate phone, adjacent widget grows, etc...)
    return Scaffold(
      appBar: AppBar(title: appbartitle),
      drawer: NavigationDrawer(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
            Navigator.pop(context);
          },
          children: [
            NavigationDrawerDestination(
                icon: Icon(Icons.home), label: Text('Home')),
            NavigationDrawerDestination(
                icon: Icon(Icons.favorite), label: Text('Favorites')),
          ]),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}

// You have X favorites
// Add ability to remove favorites?
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites')),
      Expanded(
          child: ListView(
              children: appState.favorites.map((WordPair wordpair) {
        return FavoriteListItem(pair: wordpair);
      }).toList())),
    ]);
  }
}

class FavoriteListItem extends StatelessWidget {
  const FavoriteListItem({Key? key, required this.pair}) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return ListTile(
        leading: Icon(Icons.favorite),
        title: Text(pair.asLowerCase, semanticsLabel: pair.asPascalCase),
        trailing: ElevatedButton(
            // BUG: removing pair does NOT reflect in UI until next render
            onPressed: () => appState.removeFavorite(pair),
            child: Text('X')));
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  // Flutter Widget's build() ~ React component's render()
  // build() must return a widget, gets called every time "relevant" state changes
  Widget build(BuildContext context) {
    print('render Generator page');
    // Flutter's context.watch<AppState>() ~ React's useContext(AppContext);
    // Observation: child widgets rerender even if they don't themselves call context.watch
    // (it seems all widgets rerender if a parent's state changes, even if only
    // some child widgets call context.watch)
    var appState = context.watch<AppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RandomTextCard(pair: appState.current),
          // Flutter uses "logical pixels" ("device-independent pixels": 38px ~ 1cm)
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
    );
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

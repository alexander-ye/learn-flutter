import 'package:flutter/material.dart';

class ExpansionPanelsApp extends StatelessWidget {
  const ExpansionPanelsApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const ExampleExpansionPanelList(),
      ),
    );
  }
}

// stores ExpansionPanel state information
class ExpansionPanelItem {
  ExpansionPanelItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<ExpansionPanelItem> generateExpansionPanelItems(
    int numberOfExpansionPanelItems) {
  return List<ExpansionPanelItem>.generate(numberOfExpansionPanelItems,
      (int index) {
    return ExpansionPanelItem(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class ExampleExpansionPanelList extends StatefulWidget {
  const ExampleExpansionPanelList({super.key});

  @override
  State<ExampleExpansionPanelList> createState() =>
      _ExampleExpansionPanelListState();
}

class _ExampleExpansionPanelListState extends State<ExampleExpansionPanelList> {
  final List<ExpansionPanelItem> _data = generateExpansionPanelItems(8);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: ListView(children: [_buildPanel()]))
    ]);
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ExpansionPanelItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere(
                      (ExpansionPanelItem currentExpansionPanelItem) =>
                          item == currentExpansionPanelItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

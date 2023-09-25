import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/widgets/note_item.dart';

import '../constants.dart';

class SearchWidget extends SearchDelegate<NoteModel> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}

class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key? key, required this.query}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<NoteModel>(kNotesBox).listenable(),
      builder: (context, Box<NoteModel> noteBox, _) {
        //* this is where we filter data
        var results = query.isEmpty
            ? noteBox.values.toList() // whole list
            : noteBox.values.where((c) {
                return c.title.toLowerCase().contains(query) ||
                    c.subTitle.toLowerCase().contains(query);
              }).toList();

        return results.isEmpty
            ? const Center(
                child: Text('No results found !',
                    style: TextStyle(color: kPrimaryColor)),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  // passing as a custom list
                  final NoteModel note = results[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NoteItem(note: note),
                  );
                },
              );
      },
    );
  }
}

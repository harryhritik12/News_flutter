import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({
    required Key key,
    required Widget child,
  })  : bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    final storiesProvider =
        context.dependOnInheritedWidgetOfExactType<StoriesProvider>();
    if (storiesProvider != null) {
      // Return the bloc directly without a print statement.
      return storiesProvider.bloc;
    } else {
      throw Exception('Error: StoriesProvider not found');
    }
  }
}

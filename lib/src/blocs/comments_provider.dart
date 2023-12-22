import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({required Key key, required Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CommentsBloc of(BuildContext context) {
    final commentsProvider = context.dependOnInheritedWidgetOfExactType<CommentsProvider>();
    if (commentsProvider == null) {
      throw Exception('CommentsProvider not found in the context');
    }
    return commentsProvider.bloc;
  }
}

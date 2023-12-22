import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({required this.child});

  @override
  Widget build(BuildContext context) {
    print('Debug: Building Refresh - class: Refresh');

    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        print('Debug: Refreshing data - class: Refresh');
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}

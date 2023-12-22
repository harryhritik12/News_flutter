import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tiles.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder<List<int>>(
      stream: bloc.topIds,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.requireData;

        return Refresh(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (index < data.length) {
                bloc.fetchItem(data[index]);
                return NewsListTile(itemId: data[index]);
              } else {
                return const SizedBox(); // or any other fallback widget
              }
            },
          ),
        );
      },
    );
  }
}

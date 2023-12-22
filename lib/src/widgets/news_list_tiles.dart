import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_models.dart';
import '../blocs/stories_provider.dart';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({required this.itemId});

  @override
  Widget build(BuildContext context) {
    print('Debug: Building NewsListTile for item ID: $itemId - class: NewsListTile');

    final bloc = StoriesProvider.of(context);

    return StreamBuilder<Map<int, Future<ItemModel?>>>(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          print('Debug: No data in snapshot or snapshot is null (Error 1) - class: NewsListTile');
          return LoadingContainer();
        }

        final data = snapshot.requireData; // Use requireData for non-null assertion
        final itemFuture = data[itemId];

        return FutureBuilder<ItemModel?>(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              print('Debug: Item snapshot has no data (Error 1) - class: NewsListTile');
              return LoadingContainer();
            }

            final item = itemSnapshot.requireData!; // Use requireData for non-null assertion
            return buildTile(context, item);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: [
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ],
          ),
        ),
        const Divider(
          height: 8.0,
        ),
      ],
    );
  }
}

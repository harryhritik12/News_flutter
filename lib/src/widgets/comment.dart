import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_models.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({required this.itemId, required this.itemMap, required this.depth, Future<ItemModel?>? itemFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
      future: itemMap[itemId],
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingContainer();
        }

        if (!snapshot.hasData) {
          return const SizedBox(); // Replace with your desired fallback widget
        }

        final item = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: buildText(item),
              subtitle: Text(item.by.isEmpty ? 'Deleted' : item.by),
              contentPadding: EdgeInsets.only(left: (depth + 1) * 16.0),
            ),
            const Divider(),
            ...item.kids.map((kidId) {
              return Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              );
            }),
          ],
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');

    return Text(text);
  }
}

import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
          title: SizedBox(
            height: 24.0,
            width: double.infinity,
            child: Placeholder(color: Colors.grey),
          ),
          subtitle: SizedBox(
            height: 24.0,
            width: double.infinity,
            child: Placeholder(color: Colors.grey),
          ),
        ),
        Divider(height: 8.0),
      ],
    );
  }
}

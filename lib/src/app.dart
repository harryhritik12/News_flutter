import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Debug: Building App');

    return CommentsProvider(
      key: GlobalKey(), // Key for CommentsProvider
      child: StoriesProvider(
        key: GlobalKey(), // Key for StoriesProvider
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route<dynamic> routes(RouteSettings settings) {
    print('Debug: Generating Route - Name: ${settings.name}');

    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          print('Debug: Building Route for NewsList');

          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();

          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          print('Debug: Building Route for NewsDetail');

          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.tryParse(settings.name?.replaceFirst('/', '') ?? '');

          if (itemId != null) {
            commentsBloc.fetchItemWithComments(itemId);
            return NewsDetail(itemId: itemId);
          } else {
            // Handle invalid or null itemId scenario
            return const Scaffold(
              body: Center(
                child: Text('Invalid Item'),
              ),
            );
          }
        },
      );
    }
  }
}

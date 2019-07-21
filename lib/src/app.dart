import 'package:flutter/material.dart';
import 'screens/topnews.dart';
import 'bloc/stories_provider.dart';
import 'screens/news_details.dart';
import 'bloc/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
        title: 'Hacker App',
        onGenerateRoute: route, 
        ),
      ),
    );
  }

  Route route(RouteSettings settings) {
    if(settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return TopNews();
        },
      );
    }
    else {
      return MaterialPageRoute(
        builder: (context) {
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final bloc = CommentsProvider.of(context);
          bloc.fetchItemWithComment(itemId);
          return NewsDetails(itemId :itemId);
        }
      );
    }
  }
}
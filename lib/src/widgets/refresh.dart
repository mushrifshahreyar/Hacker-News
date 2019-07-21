import 'package:flutter/material.dart';
import '../bloc/stories_provider.dart';

class Refresh extends StatelessWidget {
  Widget child;
  Refresh({this.child});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../bloc/stories_provider.dart';
import 'dart:async';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget{
  final itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if(!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemsnapshot) {
            if(!itemsnapshot.hasData) {
              return LoadingContainer();
            }
            return buildList(itemsnapshot.data, context);
          },
        );
      },

    );
  }

  Widget buildList(ItemModel item, BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle: Text("${item.score} votes"),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendant}'), 
            ],
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    ); 
  }
  
}
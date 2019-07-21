import 'package:flutter/material.dart';
// import 'dart:async';
import '../bloc/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class TopNews extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }
  
  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context,AsyncSnapshot<List<int>> snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
          
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,int index) {
              // print(snapshot.data[index]);
              bloc.fetchItem(snapshot.data[index]);
              return NewsListTile(
                itemId : snapshot.data[index]);   
            },
          ),
        );
      }, 
    ); 
  }
} 

import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test_api/test_api.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart';

void main() {
  test('Fetch Top Id should return lists of Ids', () async {
    NewsApiProvider newsapi = new NewsApiProvider();
    newsapi.client =  MockClient( (request) async {
      return Response(json.encode([1,2,3,4,5,6,7,8,9,0]),200);
    });
    
    final ids = await newsapi.fetchTopIds();

    expect(ids, [1,2,3,4,5,6,7,8,9,0]);
  });
}
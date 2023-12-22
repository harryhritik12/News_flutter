import 'package:http/http.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/testing.dart';

void main(){
  test('FetchTopIds return a list of ids',() async {

   final newsApi=NewsApiProvider();
   newsApi.client=MockClient((request) async{

      return Response(json.encode([1,2,3,4]),200);

   });
   final id =await newsApi.fetchTopIds();
   expect(id, [1,2,3,4]);

 
    
  });
  test('FetchItem return a item moodel',()async{
      final newsAPi= NewsApiProvider();
      newsAPi.client=MockClient((request) async{
        final jsonMap={'id':123};
          return Response(json.encode(jsonMap), 200);
      });
      final item=await newsAPi.fetchItem(999);
      expect(item.id, 123);

  });
}

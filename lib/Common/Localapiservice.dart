
import 'package:dio/dio.dart';
import 'package:movie/Response/MyTheater.dart';

final dio = Dio(
    BaseOptions(
      baseUrl: 'https://hs-cinemagix.duckdns.org/api/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*', // 또는 application/json
      },
    )
);
//http://10.0.2.2:8080/api/
class Localapiservice {

  Future<List<MyTheater>> getMyTheater(int user_id) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.post(
        'v1/detail/retrieve/myTheater',
        queryParameters: {'user_id': user_id},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if(data == null) return [];

        //if (data['errorCode'] == 'SUCCESS') {
        final List<dynamic> rawList = data['myTheaterList'];
        for(int i=0; i< rawList.length;i++){
          print(rawList[i]);
        }
        return rawList.map((e) => MyTheater.fromJson(e)).toList();
        // }
        // return [];
      }
      return [];
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return [];
    } catch (e) {
      print("기타 예외: $e");
      return [];
    }
  }

  Future<List<MyTheater>> setMyTheater(int user_id, List<int> mySpotList) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.post(
        'v1/detail/update/myTheater',
        queryParameters: {'user_id': user_id, 'mySpotList': mySpotList},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if(data == null) return [];

        //if (data['errorCode'] == 'SUCCESS') {
        final List<dynamic> rawList = data['myTheaterList'];
        for(int i=0; i< rawList.length;i++){
          print(rawList[i]);
        }
        return rawList.map((e) => MyTheater.fromJson(e)).toList();
        // }
        // return [];
      }
      return [];
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return [];
    } catch (e) {
      print("기타 예외: $e");
      return [];
    }
  }
}
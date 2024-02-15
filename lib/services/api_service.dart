import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_episodes_model.dart';
import 'package:webtoon/models/webtoon_model.dart';

import '../models/webtoon_detail_model.dart';

class ApiService{
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebToonModel>> getTodaysToons() async {
    List<WebToonModel> toonsInstances = [];
    final url = Uri.parse("$baseUrl/$today");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final webtoons = jsonDecode(response.body);
      for(var webtoon in webtoons){
        toonsInstances.add(WebToonModel.fromJson(webtoon));
      }
      return toonsInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodesModel>> getLatestEpisodesById(String id) async {
    List<WebtoonEpisodesModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if(response.statusCode == 200){
      List episodes = jsonDecode(response.body);
      for(final episode in episodes){
        episodesInstances.add(WebtoonEpisodesModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
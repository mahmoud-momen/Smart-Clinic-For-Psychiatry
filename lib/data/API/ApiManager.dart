import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_clinic_for_psychiatry/data/Constant/Constant.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/ArticlesModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/sourceModel/SourceModel.dart';



class ApiManager {
  static Future<SourceModel> getSources(String category) async {
    var query = {
      'apiKey': Constant.apiKey,
      'category': category,
    };
    Uri url = Uri.https(Constant.baseUrl, Constant.topHeadlines, query);
    final response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 'ok') {
      return SourceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load source');
    }
  }

  static Future<ArticlesModle> getNewsData(String sourceId) async {
    var query = {
      'apiKey': Constant.apiKey,
      'sources': sourceId,
    };

    Uri url = Uri.https(Constant.baseUrl, Constant.everything, query);

    var response = await http.get(url);
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 'ok') {
      var articelModel = ArticlesModle.fromJson(jsonDecode(response.body));
      return articelModel;
    } else {
      throw Exception('Failed to load source');
    }
  }

  static Future<ArticlesModle> searchNews(String q) async {
    Uri url = Uri.https(Constant.baseUrl, Constant.everything,
        {'q': q, 'apiKey': Constant.apiKey});
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 'ok') {
      var articleModel = ArticlesModle.fromJson(result);
      return articleModel;
    } else {
      throw Exception('Failed to load source');
    }
  }
}

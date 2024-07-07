import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_clinic_for_psychiatry/data/Constant/Constant.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/ArticlesModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/article.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/logic/cubit/search_state.dart';



class SearchCubit extends Cubit<SearchState> {
  List<Article> articlesList = [];
  bool isSearch = false;
  var searchController = TextEditingController();
  SearchCubit() : super(SearchInitial());
  static SearchCubit get  (context) => BlocProvider.of(context);
  Future<void> seachNews(String query) async {
    try {
      emit(SearchLoading());
      var q = {
        'apiKey': Constant.apiKey,
        'q': query,
      };
      Uri url = Uri.https(Constant.baseUrl, Constant.everything, q);
      var response = await http.get(url);
      var result = jsonDecode(response.body);
      articlesList = ArticlesModle.fromJson(result).articles ?? [];
      emit(SearchSuccess());
    } on Exception catch (e) {
      emit(SearchError(e.toString()));
    }
  }
  cahngeAppBar(){
    isSearch = !isSearch;
    emit(SearchChangeAppBarState());
  }
}

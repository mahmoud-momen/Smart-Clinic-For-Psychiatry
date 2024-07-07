import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_clinic_for_psychiatry/data/API/CasheHelper.dart';
import 'package:smart_clinic_for_psychiatry/data/Constant/Constant.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/ArticlesModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/article.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/categoriesModel/CategoriesModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/sourceModel/SourceModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/logic/cubit/NewsState.dart';


class NewsCubit extends Cubit<HomeState> {
  static NewsCubit get(context) => BlocProvider.of(context);
  NewsCubit() : super(HomeInitialState());

  List<Sources> sources = [];
  List<Article> articlesList = [];
  CatergorieModel? catergorieModel;
  bool isSearch = true;
  var searchController = TextEditingController();

  int index = 0;
  int indexList = 0;

  changeIndex(int value) {
    emit(HomeInitialState());
    index = value;
    emit(HomeChangeIndexState());
  }

  Future<void> getSources(String category) async {
    try {
      var query = {'apiKey': Constant.apiKey, 'category': category};
      emit(HomeLoadindState());
      Uri url = Uri.https(Constant.baseUrl, Constant.topHeadlines, query);
      final response = await http.get(url);

      var result = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          jsonDecode(response.body)['status'] == 'ok') {
        sources = SourceModel.fromJson(result).sources ?? [];

        emit(HomeSorcesSuccessState());
      } else {
        throw Exception('Failed to load source');
      }
    } on Exception catch (e) {
      emit(HomeSorcesErrorState(e.toString()));
    }
  }

  Future<void> getNewsData() async {
    try {
      emit(HomeLoadindState());
      var query = {
        'apiKey': Constant.apiKey,
        'sources': sources[index].id ?? '',
      };

      Uri url = Uri.https(Constant.baseUrl, Constant.everything, query);

      var response = await http.get(url);
      var result = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['status'] == 'ok') {
        articlesList = ArticlesModle.fromJson(result).articles ?? [];
        emit(HomeNewsSuccessState());
      } else {
        throw Exception('Failed to load source');
      }
    } on Exception catch (e) {
      emit(HomeNewsErrorState(e.toString()));
    }
  }

  Future<void> getSearchData(String q) async {
    try {
      emit(HomeLoadindState());
      var query = {'apiKey': Constant.apiKey, 'q': q};

      Uri url = Uri.https(Constant.baseUrl, Constant.everything, query);

      var response = await http.get(url);
      var result = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['status'] == 'ok') {
        articlesList = ArticlesModle.fromJson(result).articles ?? [];
        emit(HomeNewsSuccessState());
      } else {
        throw Exception('Failed to load source');
      }
    } on Exception catch (e) {
      emit(HomeNewsErrorState(e.toString()));
    }
  }

  makeModelNull(context) {
    emit(HomeInitialState());

    catergorieModel = null;
    Navigator.pop(context);
    CasheHelper.pref.clear();

    emit(HomeView());
  }

  onClick(
    CatergorieModel catergorieModel,
  ) {
    emit(HomeInitialState());
    this.catergorieModel = catergorieModel;
    CasheHelper.saveData('news', catergorieModel.id);
    emit(NewsView());
  }

  changeSearchIcon() {
    isSearch = !isSearch;
    emit(HomeSearchIconState());
  }

  makeCasheNull(context) {
    emit(HomeInitialState());
    CasheHelper.getData('news') == null;
    CasheHelper.pref.clear();
    Navigator.pop(context);

    emit(HomeClear());
  }

  onSave(
    bool isSaved,
  ) {
    emit(HomeInitialState());
    CasheHelper.saveData('news', isSaved);
    emit(HomeSaved());
  }

  String? cashe = CasheHelper.getData('news') ?? '';


}


import 'package:smart_clinic_for_psychiatry/domain/model/categoriesModel/CategoriesModel.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadindState extends HomeState {}

class HomeSorcesSuccessState extends HomeState {
CatergorieModel? catergorieModel;
  
  
}

class HomeSorcesErrorState extends HomeState {
  final String error;
  HomeSorcesErrorState(this.error);
}

class HomeNewsSuccessState extends HomeState {}

class HomeNewsErrorState extends HomeState {
  final String error;
  HomeNewsErrorState(this.error);
}

class HomeChangeIndexState extends HomeState {}
class HomeChangeIndexListState extends HomeState {}


class HomeView extends HomeState {}

class NewsView extends HomeState {}
class HomeSearchIconState extends HomeState {}
class HomeSaved extends HomeState {}
class HomeClear extends HomeState {}

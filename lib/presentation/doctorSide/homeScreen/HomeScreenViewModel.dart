import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModelDoctor extends Cubit<HomeScreenState>{
  @factoryMethod HomeViewModelDoctor():super(HomeScreenTabState());

  void onTabClick(int tabIndex){
    if(tabIndex ==0){
      emit(HomeScreenTabState());
    }else if (tabIndex ==1){
      emit(NewsScreenState());
    }else if (tabIndex ==2){
      emit(ChatScreenState());
    }else if (tabIndex ==3){
      emit(SettingsScreenStateDoctor());
    }
  }
}
sealed class HomeScreenState{}
class HomeScreenTabState extends HomeScreenState{}
class NewsScreenState extends HomeScreenState{}
class ChatScreenState extends HomeScreenState{}
class SettingsScreenStateDoctor extends HomeScreenState{}
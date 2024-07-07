import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/LogoutUseCase.dart';

@injectable
class SettingsViewModel extends Cubit<SettingsViewState> {
  LogoutUseCase logoutUseCase;

  @factoryMethod SettingsViewModel(this.logoutUseCase) : super(InitialState());

  void logout() async {
    try {
      emit(LoadingState());
      await logoutUseCase.invoke();
      emit(LogoutSuccessState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}


sealed class SettingsViewState {}

class InitialState extends SettingsViewState {}

class ErrorState extends SettingsViewState {
  final String message;

  ErrorState(this.message);
}

class LoadingState extends SettingsViewState {}

class LogoutSuccessState extends SettingsViewState {

}

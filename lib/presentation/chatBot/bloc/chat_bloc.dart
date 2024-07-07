import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_clinic_for_psychiatry/data/repository/chatBotRepository.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/chatBotModel/ChatBotMessageModel.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }
  List<ChatBotMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    if (event.inputMessage != null) {
      messages.add(ChatBotMessageModel(
          role: "user", parts: [ChatPartModel(text: event.inputMessage!)]));
      emit(ChatSuccessState(messages: messages));
      generating =true;
      String? generatedText = await ChatRepo.chatTextGenerationRepo(messages);
      if (generatedText != null && generatedText.length > 0) {
        messages.add(ChatBotMessageModel(
            role: 'model', parts: [ChatPartModel(text: generatedText)]));
        emit(ChatSuccessState(messages: messages));
      }
      generating = false;
    }
  }

}
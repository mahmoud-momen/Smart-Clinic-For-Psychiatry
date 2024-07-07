import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_clinic_for_psychiatry/data/constant/Constant.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/chatBotModel/ChatBotMessageModel.dart';

class ChatRepo {
  static Future<String?> chatTextGenerationRepo(
      List<ChatBotMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();

      final response = await dio.post(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${Constant.apiKeyChatBot}",
        data: {
          "contents": previousMessages.map((e) => e.toMap()).toList(),
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        },
        options: Options(
          headers: {
            "Content-Type": "application/json", // Set the content-type to JSON
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data['candidates'].first['content']['parts'].first['text'];
      }
    } catch (e) {
      log(e.toString());
    }
    // Handle the case where response is null or the status code is not in the successful range
    return null; // Or you can return a default value or throw an error here
  }
}
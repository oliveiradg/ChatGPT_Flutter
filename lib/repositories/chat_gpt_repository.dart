import 'package:dio/dio.dart';

import 'package:fluttergpt/core/app_config.dart';

class ChatGptRepository {
  final Dio _dio;

  ChatGptRepository(Dio dio) : _dio = dio;

  Future<String> promptMessage(String prompt) async {
    try {
      const url = "https://api.openai.com/v1/completions";

      final response = await _dio.post(url,
          data: {
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 1000,
            "temperature": 0.9,
            "top_p": 1,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.0
          },
          options: Options(headers: {
            'Authorization': 'Bearer ${Appconfig.getOpenAIAPIKey}',
          }));

      return response.data['choices'][0]['text'];
    } catch (error) {
      print(error);

      return 'Ocorreu um Erro! por favor, tente novamente';
    }
  }
}

import 'package:smart_clinic_for_psychiatry/data/API/CasheHelper.dart';

class Constant {
  static const String apiKey = '4a5e76e7117d4b8ba2aca9b23daf1354';
  static const String baseUrl = 'newsapi.org';
  static const String topHeadlines = '/v2/top-headlines/sources';
  static const String everything = '/v2/everything';
  static const String sources = '/v2/sources';

  static String? cashe = CasheHelper.getData('news');

  static const String apiKeyChatBot = "AIzaSyANMbrnpnXKihPBEh3zsFJjLhVpicXSd18";
  static const String geminiVisionModel = "gemini-pro-vision";
  static const String geminiModel = "gemini-pro";
}

const String newsAPIBaseUrl = 'https://newsapi.org/v2';
const String newsAPIKey = '9d16c190c465497d8e9210a8a4f642b0';
const String countryQuery = 'us';
const String kDefaultImage =
    "https://www.google.com/search?q=default+image&client=firefox-b-d&sxsrf=APq-WBskmtr-ix6NUAqqiHFNpsJX6JSOTg:1650026644151&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjEi_qfjJb3AhXvQd8KHd02BKUQ_AUoAXoECAEQAw#imgrc=A0pMe2lq2NT_jM";
const androidOAuthClientId = '629772530088-ud6gq1l7uarlhi1r42du6rp05rso5oom.apps.googleusercontent.com';
//facebook app secret: sdghs8395ituhkfhsdksd
const deeplLink = 'nsmnrz4528://com.manirahmanzadeh.news';
const appLink = 'https://com.manirahmanzadeh.news';

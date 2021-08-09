import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello World',
    },
    'de_DE': {
      'hello': 'Hallo Welt',
    }
  };
}
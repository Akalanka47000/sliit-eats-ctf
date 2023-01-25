import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static const SLIIT_EATS_APP_ENV =  String.fromEnvironment("SLIIT_EATS_APP_ENV", defaultValue: "LOCAL");
  static const SLIIT_EATS_FIREBASE_API_KEY = String.fromEnvironment("SLIIT_EATS_FIREBASE_API_KEY", defaultValue:"");
  static const SLIIT_EATS_FIREBASE_APP_ID = String.fromEnvironment("SLIIT_EATS_FIREBASE_APP_ID", defaultValue: "");
  static const SLIIT_EATS_FCM_SENDER_ID = String.fromEnvironment("SLIIT_EATS_FCM_SENDER_ID", defaultValue: "318959193972");
  static const SLIIT_EATS_FIREBASE_PROJECT_ID = String.fromEnvironment("SLIIT_EATS_FIREBASE_PROJECT_ID", defaultValue: "");
  static const SLIIT_EATS_FIREBASE_BUCKET = String.fromEnvironment("SLIIT_EATS_FIREBASE_BUCKET", defaultValue: "");
  static const SLIIT_EATS_SERVER_URL = String.fromEnvironment("SLIIT_EATS_SERVER_URL", defaultValue: "http://35.212.141.104:8000");
  static const SLIIT_EATS_SERVER_AUTH = String.fromEnvironment("SLIIT_EATS_SERVER_AUTH", defaultValue: "");
  static const ENCRYPTION_KEY = String.fromEnvironment("ENCRYPTION_KEY", defaultValue: "rtyfds0pOsafsfrvdsafbvgf56@wa&a#");
  static const PREMIUM_SUPPORT_ENABLED_USERS = String.fromEnvironment("PREMIUM_SUPPORT_ENABLED_USERS", defaultValue: "");
  static const DYNAMIC_FLAG_1 = String.fromEnvironment("DYNAMIC_FLAG_1");
}
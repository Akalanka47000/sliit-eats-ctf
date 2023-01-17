import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static final SLIIT_EATS_APP_ENV =  String.fromEnvironment("SLIIT_EATS_APP_ENV", defaultValue: "LOCAL");
  static final SLIIT_EATS_FIREBASE_API_KEY = String.fromEnvironment("SLIIT_EATS_FIREBASE_API_KEY", defaultValue: dotenv.env['SLIIT_EATS_FIREBASE_API_KEY']!);
  static final SLIIT_EATS_FIREBASE_APP_ID = String.fromEnvironment("SLIIT_EATS_FIREBASE_APP_ID", defaultValue: dotenv.env['SLIIT_EATS_FIREBASE_APP_ID']!);
  static final SLIIT_EATS_FCM_SENDER_ID = String.fromEnvironment("SLIIT_EATS_FCM_SENDER_ID", defaultValue: dotenv.env['SLIIT_EATS_FCM_SENDER_ID']!);
  static final SLIIT_EATS_FIREBASE_PROJECT_ID = String.fromEnvironment("SLIIT_EATS_FIREBASE_PROJECT_ID", defaultValue: dotenv.env['SLIIT_EATS_FIREBASE_PROJECT_ID']!);
  static final SLIIT_EATS_FIREBASE_BUCKET = String.fromEnvironment("SLIIT_EATS_FIREBASE_BUCKET", defaultValue: dotenv.env['SLIIT_EATS_FIREBASE_BUCKET']!);
  static final SLIIT_EATS_SERVER_URL = String.fromEnvironment("SLIIT_EATS_SERVER_URL", defaultValue: dotenv.env['SLIIT_EATS_SERVER_URL']!);
}
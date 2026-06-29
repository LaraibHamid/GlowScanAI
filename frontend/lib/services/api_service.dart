import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {

// =========================
// BASE URL AUTO SWITCH
// =========================
  static String get baseUrl {


// Android emulator detection
    if (Platform.isAndroid) {

    // Emulator normally has these fingerprints
    if (Platform.environment.containsKey('ANDROID_ROOT')) {

    try {
    final isEmulator = Platform.environment.containsKey('ANDROID_EMULATOR');

    if (isEmulator) {
    return "http://10.0.2.2:5000";
    }

    } catch (_) {}
    }
    }

// Physical phone
    return "http://192.168.100.28:5000";


  }

// =========================================================
// SKIN ANALYSIS API
// =========================================================
  static Future<Map<String, dynamic>> analyzeSkin(File imageFile) async {


    try {

    final user = FirebaseAuth.instance.currentUser;

    final request = http.MultipartRequest(
    'POST',
    Uri.parse("$baseUrl/analyze"),
    );

    request.files.add(
    await http.MultipartFile.fromPath(
    "image",
    imageFile.path,
    ),
    );

    // send user id
    if (user != null) {
    request.fields["uid"] = user.uid;
    }

    final response = await request.send();

    final responseData = await response.stream.bytesToString();

    return jsonDecode(responseData);

    } catch (e) {

    return {
    "issue": "Connection Error",
    "description": "Server connection failed",
    "severity": "Unknown",
    "skin_score": 0
    };

    }


  }

// =========================================================
// CHATBOT API
// =========================================================
  static Future<String> sendChatMessage(String message) async {


    try {

    final response = await http.post(
    Uri.parse("$baseUrl/chat"),
    headers: {
    "Content-Type": "application/json"
    },
    body: jsonEncode({
    "message": message
    }),
    );

    if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["reply"] ?? "No response";

    } else {

    return "Server error";

    }

    } catch (e) {

    return "Server connection failed";

    }


  }

// =========================================================
// SCAN HISTORY API
// =========================================================
  static Future<List<dynamic>> getScanHistory() async {


    try {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
    return [];
    }

    final response = await http.get(
    Uri.parse("$baseUrl/history?uid=${user.uid}"),
    );

    if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    if (data is List) {
    return data;
    }

    return [];

    } else {

    throw Exception("Failed to load history");

    }

    } catch (e) {

    return [];

    }


  }

}

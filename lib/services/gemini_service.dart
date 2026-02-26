import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_gemerator_ai/models/task.dart';

class GeminiService {
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";
  final String apiKey;

  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "Please input your API KEY" {
    if (apiKey.isEmpty) { // kalo kosong
      throw ArgumentError("API KEY is missing");
    }
  }

  Future<String> generateSchedule(List<Task> tasks) async { // ini pake async karena ada proses menunggu dan proses yang berjalan bersamaan (misal btn generate schedule, terus sambil menampilkan loading indicator, )
    _validateTasks(tasks);
    final prompt = _buildPrompt(tasks);
    try {
      // nanti ke print di debug console
      print("Prompt: \n$prompt");
      // add request time out message to avoid indefinate hangs if the API doesn't response
      final response = await http
          .post(Uri.parse("$_baseUrl?key=$apiKey"), headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {"text": prompt}
                ]
              }
            ]
          })
          ).timeout(Duration(seconds: 20)); // kalo misal AI tidak merespon selama 20 detik, biar ga kelamaan juga dan bikin bete
          return _handleResponse(response);
    } catch (e) {
      throw ArgumentError("Failed to generate schedule: $e");
    }
  }

  String _handleResponse(http.Response responses) {
    final data = jsonDecode(responses.body);
    if (responses.statusCode == 401) { // 401 itu atrinya Unauthorized / api tidak valid (kode status HTTP yang menunjukkan permintaan ke server ditolak karena kredensial autentikasi (username/password) tidak valid, kedaluwarsa, atau tidak ada)
      throw ArgumentError("Invalid API Key or Unauthorized Access");
    } else if(responses.statusCode == 429) { // 429 atrinya too many request/ tokennya abis
      throw ArgumentError("Rate limit exceeded");
    } else if (responses.statusCode == 500) { // 500 artinya server error
      throw ArgumentError("Intenal server error");
    } else if (responses.statusCode == 503) { // 503 Service Unavailable / server tidak tersedia
      throw ArgumentError("Service unavailable");
    } else if (responses.statusCode == 200) { // 200 = ok bisa dipake
      return data["candidates"][0]["content"]["parts"][0]["tetx"]; // response yang akan di kembalikan oleh AI
    } else { // kalo misla errornya diluar dari kondisi error yag sudah diberikan
      throw ArgumentError("Unknown error");
    }
  }

  String _buildPrompt(List<Task> tasks) {
    final tasksList = tasks.map((tasks) => "${tasks.name} (Priority: ${tasks.priority}, Duration: ${tasks.duration} minute, Deadline: ${tasks.deadline})").join("\n");
    return "Buatkan jadwal harian yang optimal berdasarkan task berikut:\n$tasksList";
  }

  // kadang yang bikin error itu adalah perubahan versi library
  void _validateTasks(List<Task> tasks) {
    if (tasks.isEmpty) throw ArgumentError("Task cannot be empty. Please insert your prompt");
  }
}


/**
 * Note =
 * Sebuah kode yang letaknya setelah await itu hasilnya akan di generate setelah proses async selesai
 * Async = proses dimulai, tanda 2 atau lebih proses sedang berjalan bersamaan
 * Await = berakhirnya proses asynchronous
 * 
 * Perbedaan encode dan decode = decode itu data mentah
 * Json itu sama kyk html, jadi dia itu bahasa scripting smaa kyk yaml, pokoknya kyk temennya html lah yang sejenis
 * 
 * provider itu kyk misal Gemini itu google ai studio, kalo Chat GPT itu open AI
 */
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-render-app-url.onrender.com/api';

  // Rewrite bio endpoint
  static Future<String> rewriteBio(String rawBio, String mode, int maxLength) async {
    final url = Uri.parse('$baseUrl/bio-rewrite');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'raw_bio': rawBio,
        'mode': mode,
        'max_length': maxLength,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rewritten_bio'];
    } else {
      throw Exception('Failed to rewrite bio: ${response.statusCode}');
    }
  }

  // Generate badge text endpoint
  static Future<Map<String, dynamic>> generateBadgeText(
    String badgeId,
    String eventContext,
    String userRole,
  ) async {
    final url = Uri.parse('$baseUrl/badge-text');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'badge_id': badgeId,
        'event_context': eventContext,
        'user_role': userRole,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate badge text: ${response.statusCode}');
    }
  }

  // Suggest follow-up endpoint
  static Future<Map<String, dynamic>> suggestFollowUp(
    String contactId,
    String previousConversation,
    String lastMeetingDate,
  ) async {
    final url = Uri.parse('$baseUrl/follow-up');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contact_id': contactId,
        'previous_conversation': previousConversation,
        'last_meeting_date': lastMeetingDate,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to suggest follow-up: ${response.statusCode}');
    }
  }

  // Summarize notes endpoint
  static Future<List<String>> summarizeNotes(String notes) async {
    final url = Uri.parse('$baseUrl/notes-summary');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notes': notes}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['summary_bullets']);
    } else {
      throw Exception('Failed to summarize notes: ${response.statusCode}');
    }
  }
}
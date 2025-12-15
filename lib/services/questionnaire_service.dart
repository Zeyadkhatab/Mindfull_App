import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionnaireService {
  final supabase = Supabase.instance.client;

  // Save answers to Supabase
  Future<bool> saveAnswers(Map<int, String> answers) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        print('No user logged in');
        return false;
      }

      // Convert answers map to a format suitable for storage
      final answersJson = answers.map((key, value) => MapEntry(key.toString(), value));

      // Save to Supabase
      await supabase.from('questionnaire_responses').upsert({
        'user_id': userId,
        'answers': answersJson,
        'completed_at': DateTime.now().toIso8601String(),
      });

      print('Answers saved successfully');
      return true;
    } catch (e) {
      print('Error saving answers: $e');
      return false;
    }
  }

  // Get answers from Supabase
  Future<Map<String, dynamic>?> getAnswers(String userId) async {
    try {
      final response = await supabase
          .from('questionnaire_responses')
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error getting answers: $e');
      return null;
    }
  }

  // Format answers for AI prompt
  String formatAnswersForAI(Map<int, String> answers, List<String> questions) {
    StringBuffer prompt = StringBuffer();
    prompt.writeln('Mental Health Questionnaire Results:\n');

    answers.forEach((index, answer) {
      if (index < questions.length) {
        prompt.writeln('Q${index + 1}: ${questions[index]}');
        prompt.writeln('A: $answer\n');
      }
    });

    return prompt.toString();
  }
}
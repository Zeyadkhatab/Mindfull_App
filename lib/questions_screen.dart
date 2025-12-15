import 'package:flutter/material.dart';
import 'package:mindful/face_detection.dart';
import '../models/question_model.dart';
import '../widgets/question_card.dart';
import '../services/questionnaire_service.dart';
// TODO: Update this import path based on your project structure
// import 'package:mindful/screens/face_detection_screen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;
  final Map<int, String> answers = {};
  final ScrollController _scrollController = ScrollController();
  final QuestionnaireService _questionnaireService = QuestionnaireService();

  final List<Question> questions = [
    Question(
      text: 'How often do you find it hard to stay focused on your own when reading or watching TV?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do you forget things like appointments, obligations or deadlines, where others have to remind you about them?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do you feel restless, fidgety, or unable to sit still for long?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do you find it difficult to understand hints, body language, or "read the room?"',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do changes in routine or unexpected events make you feel anxious or off-balance?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often are you very sensitive to sounds, lights, textures, or touch that others rarely notice?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often have you felt down, sad, or emotionally heavy?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often have you lost interest or pleasure in activities you usually enjoy?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do you feel excessive worry or overthinking that you can\'t seem to stop?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'How often do you experience physical symptoms when stressed (such as a fast heartbeat, shortness of breath, dizziness, sweating or tense muscles)?',
      options: ['not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    ),
    Question(
      text: 'Have you had thoughts about hurting yourself, wishing you were not alive, or that you would be better off dead?',
      options: ['YES', 'NO'],
      isYesNo: true,
    ),
    Question(
      text: 'How much do these difficulties interfere with your daily life (work, studying, home life, social activities)?',
      options: ['A little', 'A lot', 'Extremely'],
    ),
  ];

  void _selectAnswer(String answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        // Scroll to show next question
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        // All questions answered - save and show completion
        _saveAndComplete();
      }
    });
  }

  Future<void> _saveAndComplete() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Save answers to database
    final saved = await _questionnaireService.saveAnswers(answers);

    // Close loading dialog
    if (mounted) Navigator.pop(context);

    if (saved) {
      _showCompletionDialog();
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save answers. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Thank You',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You have completed the self-reflection questionnaire. Your responses have been recorded.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Navigate to face detection screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmotionDetectionScreen(),
                ),
              );
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.lightBlue.shade300,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to get formatted answers for AI
  String getFormattedAnswersForAI() {
    List<String> questionTexts = questions.map((q) => q.text).toList();
    return _questionnaireService.formatAnswersForAI(answers, questionTexts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mindfull Ai',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${answers.length + 1} of ${questions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${((answers.length / questions.length) * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: answers.length / questions.length,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightBlue.shade300,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            // Questions list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: currentQuestionIndex + 1,
                itemBuilder: (context, index) {
                  return QuestionCard(
                    question: questions[index],
                    questionNumber: index + 1,
                    selectedAnswer: answers[index],
                    onAnswerSelected: index == currentQuestionIndex
                        ? _selectAnswer
                        : null,
                    isAnswered: answers.containsKey(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
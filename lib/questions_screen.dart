import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../widgets/question_card.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;
  final Map<int, String> answers = {};
  final ScrollController _scrollController = ScrollController();

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
        // All questions answered - show completion
        _showCompletionDialog();
      }
    });
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
              Navigator.of(context).pop(); // Return to previous screen
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
          'MindAuA',
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
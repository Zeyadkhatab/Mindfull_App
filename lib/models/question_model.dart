class Question {
  final String text;
  final List<String> options;
  final bool isYesNo;

  Question({
    required this.text,
    required this.options,
    this.isYesNo = false,
  });
}
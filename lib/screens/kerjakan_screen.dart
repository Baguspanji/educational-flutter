import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';

enum IconPosition { before, after }

class KerjakanScreen extends StatefulWidget {
  final LKPD lkpd;

  const KerjakanScreen({super.key, required this.lkpd});

  @override
  State<KerjakanScreen> createState() => _KerjakanScreenState();
}

class _KerjakanScreenState extends State<KerjakanScreen> {
  int _currentQuestionIndex = 0;
  late final List<Question> _questions;
  late final Map<int, dynamic> _answers;
  bool _isLoading = true;
  bool _showingSummary = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    // In a real app, this would fetch questions from a backend or local database
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    setState(() {
      // Dummy questions for demonstration
      _questions = List.generate(
        widget.lkpd.questionCount,
        (index) => _generateQuestion(index),
      );
      _answers = {};
      _isLoading = false;
    });
  }

  Question _generateQuestion(int index) {
    // For demonstration purposes, we'll create different types of questions
    if (widget.lkpd.type == 'Pilihan Ganda' || index % 3 == 0) {
      return MultipleChoiceQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: Manakah pernyataan berikut yang benar tentang ${widget.lkpd.title}?',
        options: [
          'Pilihan A untuk pertanyaan ${index + 1}',
          'Pilihan B untuk pertanyaan ${index + 1}',
          'Pilihan C untuk pertanyaan ${index + 1}',
          'Pilihan D untuk pertanyaan ${index + 1}',
        ],
        correctAnswer: index % 4, // Random correct answer
      );
    } else if (widget.lkpd.type == 'Essay' || index % 3 == 1) {
      return EssayQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: Jelaskan secara detail konsep utama dari ${widget.lkpd.title}.',
      );
    } else {
      return TrueFalseQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: Konsep ${widget.lkpd.title} selalu dapat diterapkan dalam kondisi apapun.',
        correctAnswer: index % 2 == 0,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showSubmitConfirmation();
    }
  }

  void _showSubmitConfirmation() {
    final unansweredCount = widget.lkpd.questionCount - _answers.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selesai Mengerjakan?'),
        content: Text(
          unansweredCount > 0
              ? 'Ada $unansweredCount pertanyaan yang belum dijawab. Yakin ingin mengumpulkan?'
              : 'Yakin ingin mengumpulkan jawaban?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitAnswers();
            },
            child: const Text('Kumpulkan'),
          ),
        ],
      ),
    );
  }

  void _submitAnswers() {
    setState(() {
      _showingSummary = true;
    });

    // In a real app, this would submit answers to a backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jawaban berhasil dikumpulkan')),
    );
  }

  void _updateAnswer(dynamic answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lkpd.title),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_showingSummary) {
      return _buildSummaryScreen();
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lkpd.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _showSubmitConfirmation,
            icon: const Icon(Icons.send, color: Colors.white),
            label: const Text('Selesai', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

          // Question number and timer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Soal ${_currentQuestionIndex + 1} dari ${_questions.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text('${widget.lkpd.estimatedTimeMinutes} menit'),
              ],
            ),
          ),

          // Question and answer
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question text
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (currentQuestion is MultipleChoiceQuestion)
                          _buildMultipleChoiceAnswers(currentQuestion),
                        if (currentQuestion is EssayQuestion)
                          _buildEssayAnswer(currentQuestion),
                        if (currentQuestion is TrueFalseQuestion)
                          _buildTrueFalseAnswers(currentQuestion),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Sebelumnya'),
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                _currentQuestionIndex < _questions.length - 1
                    ? ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Selanjutnya',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Selesai',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.check, size: 16),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceAnswers(MultipleChoiceQuestion question) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ...List.generate(
          question.options.length,
          (index) => RadioListTile<int>(
            title: Text(question.options[index]),
            value: index,
            groupValue: _answers[_currentQuestionIndex] as int?,
            onChanged: (value) => _updateAnswer(value),
            activeColor: Theme.of(context).colorScheme.primary,
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEssayAnswer(EssayQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Jawaban:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          minLines: 5,
          maxLines: 10,
          onChanged: _updateAnswer,
          controller: TextEditingController(
            text: _answers[_currentQuestionIndex]?.toString() ?? '',
          ),
          decoration: InputDecoration(
            hintText: 'Tulis jawaban Anda di sini...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseAnswers(TrueFalseQuestion question) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Benar'),
                value: true,
                groupValue: _answers[_currentQuestionIndex] as bool?,
                onChanged: (value) => _updateAnswer(value),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Salah'),
                value: false,
                groupValue: _answers[_currentQuestionIndex] as bool?,
                onChanged: (value) => _updateAnswer(value),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryScreen() {
    int correctAnswers = 0;

    // Calculate score for multiple choice and true/false questions
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = _answers[i];

      if (question is MultipleChoiceQuestion &&
          userAnswer == question.correctAnswer) {
        correctAnswers++;
      } else if (question is TrueFalseQuestion &&
          userAnswer == question.correctAnswer) {
        correctAnswers++;
      }
    }

    // For essay questions, we'd need teacher evaluation in a real app
    final mcQuestions = _questions.whereType<MultipleChoiceQuestion>().toList();
    final tfQuestions = _questions.whereType<TrueFalseQuestion>().toList();
    final totalObjectiveQuestions = mcQuestions.length + tfQuestions.length;

    // Calculate percentage score for objective questions only
    final percentScore = totalObjectiveQuestions > 0
        ? (correctAnswers / totalObjectiveQuestions * 100).round()
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil ${widget.lkpd.title}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Nilai Objektif',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getScoreColor(percentScore).withOpacity(0.1),
                        border: Border.all(
                          color: _getScoreColor(percentScore),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$percentScore%',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(percentScore),
                              ),
                            ),
                            Text(
                              '$correctAnswers/$totalObjectiveQuestions',
                              style: TextStyle(
                                fontSize: 14,
                                color: _getScoreColor(percentScore),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Soal esai akan dinilai oleh guru',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Question review
            Text(
              'Tinjauan Jawaban',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final question = _questions[index];
                final userAnswer = _answers[index];
                return _buildQuestionReviewItem(index, question, userAnswer);
              },
            ),

            const SizedBox(height: 24),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Kembali ke Detail LKPD',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionReviewItem(
    int index,
    Question question,
    dynamic userAnswer,
  ) {
    bool isCorrect = false;
    bool isEssay = false;
    String answerText = 'Tidak dijawab';

    if (userAnswer != null) {
      if (question is MultipleChoiceQuestion) {
        isCorrect = userAnswer == question.correctAnswer;
        answerText = question.options[userAnswer];
      } else if (question is TrueFalseQuestion) {
        isCorrect = userAnswer == question.correctAnswer;
        answerText = userAnswer ? 'Benar' : 'Salah';
      } else if (question is EssayQuestion) {
        answerText = userAnswer;
        // Essay questions need teacher evaluation
        isEssay = true;
      }
    }

    return ListTile(
      title: Row(
        children: [
          Text(
            'Soal ${index + 1}:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (!isEssay)
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
              size: 16,
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.text, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            'Jawaban Anda: $answerText',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isEssay
                  ? Colors.grey.shade700
                  : (isCorrect ? Colors.green : Colors.red),
            ),
          ),
          if (!isCorrect &&
              !isEssay &&
              (question is MultipleChoiceQuestion ||
                  question is TrueFalseQuestion))
            Text(
              'Jawaban benar: ${question is MultipleChoiceQuestion
                  ? question.options[question.correctAnswer]
                  : (question as TrueFalseQuestion).correctAnswer
                  ? "Benar"
                  : "Salah"}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

// Question models
abstract class Question {
  final String id;
  final String text;

  Question({required this.id, required this.text});
}

class MultipleChoiceQuestion extends Question {
  final List<String> options;
  final int correctAnswer;

  MultipleChoiceQuestion({
    required super.id,
    required super.text,
    required this.options,
    required this.correctAnswer,
  });
}

class EssayQuestion extends Question {
  EssayQuestion({required super.id, required super.text});
}

class TrueFalseQuestion extends Question {
  final bool correctAnswer;

  TrueFalseQuestion({
    required super.id,
    required super.text,
    required this.correctAnswer,
  });
}

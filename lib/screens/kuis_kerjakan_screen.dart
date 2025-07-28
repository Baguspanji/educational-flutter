import 'package:flutter/material.dart';
import 'dart:async';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';

class KuisKerjakanScreen extends StatefulWidget {
  final Kuis kuis;
  final bool showResults;

  const KuisKerjakanScreen({
    super.key,
    required this.kuis,
    this.showResults = false,
  });

  @override
  State<KuisKerjakanScreen> createState() => _KuisKerjakanScreenState();
}

class _KuisKerjakanScreenState extends State<KuisKerjakanScreen> {
  int _currentQuestionIndex = 0;
  late final List<Question> _questions;
  late final Map<int, dynamic> _answers;
  bool _isLoading = true;
  bool _showingSummary = false;

  // Timer related
  late Timer _timer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();

    // Set timer if not in results mode
    if (!widget.showResults) {
      _remainingSeconds = widget.kuis.timeInMinutes * 60;
    }
  }

  @override
  void dispose() {
    if (_isTimerRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _isTimerRunning = false;
          _submitAnswers();
        }
      });
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _loadQuestions() async {
    // In a real app, this would fetch questions from a backend or local database
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    setState(() {
      // Dummy questions for demonstration
      _questions = List.generate(
        widget.kuis.questionCount,
        (index) => _generateQuestion(index),
      );
      _answers = {};
      _isLoading = false;

      // Start timer if not in results mode
      if (!widget.showResults && !_isTimerRunning) {
        _startTimer();
      }

      // If showing results, simulate completed answers
      if (widget.showResults) {
        _showingSummary = true;
        // Simulate answers (in a real app, these would come from the backend)
        for (int i = 0; i < _questions.length; i++) {
          if (_questions[i] is MultipleChoiceQuestion) {
            _answers[i] = i % 4; // Just a pattern for demo
          } else if (_questions[i] is TrueFalseQuestion) {
            _answers[i] = i % 2 == 0; // Alternating true/false
          }
        }
      }
    });
  }

  Question _generateQuestion(int index) {
    // Generate different types of questions
    if (index % 3 == 0) {
      return MultipleChoiceQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: Manakah pernyataan berikut yang benar tentang ${widget.kuis.title}?',
        options: [
          'Pilihan A untuk pertanyaan ${index + 1}',
          'Pilihan B untuk pertanyaan ${index + 1}',
          'Pilihan C untuk pertanyaan ${index + 1}',
          'Pilihan D untuk pertanyaan ${index + 1}',
        ],
        correctAnswer: index % 4, // Random correct answer
      );
    } else if (index % 3 == 1) {
      return MultipleChoiceQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: Pilih istilah yang paling tepat untuk ${widget.kuis.category}:',
        options: [
          'Konsep ${widget.kuis.category} 1',
          'Konsep ${widget.kuis.category} 2',
          'Konsep ${widget.kuis.category} 3',
          'Konsep ${widget.kuis.category} 4',
        ],
        correctAnswer: (index + 1) % 4, // Different pattern for variety
      );
    } else {
      return TrueFalseQuestion(
        id: 'q${index + 1}',
        text:
            'Pertanyaan ${index + 1}: ${widget.kuis.title} merupakan bagian penting dari kurikulum ${widget.kuis.category}.',
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
    final unansweredCount = widget.kuis.questionCount - _answers.length;

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
    if (_isTimerRunning) {
      _timer.cancel();
      _isTimerRunning = false;
    }

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
          title: Text(widget.kuis.title),
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
        title: Text(widget.kuis.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _remainingSeconds < 60
                    ? Colors.red.withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
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

          // Question number
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatQuestionType(currentQuestion),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  String _formatQuestionType(Question question) {
    if (question is MultipleChoiceQuestion) {
      return 'Pilihan Ganda';
    } else if (question is TrueFalseQuestion) {
      return 'Benar/Salah';
    }
    return 'Pertanyaan';
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
    int totalQuestions = _questions.length;

    // Calculate score for multiple choice and true/false questions
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = _answers[i];

      if (userAnswer != null) {
        if (question is MultipleChoiceQuestion &&
            userAnswer == question.correctAnswer) {
          correctAnswers++;
        } else if (question is TrueFalseQuestion &&
            userAnswer == question.correctAnswer) {
          correctAnswers++;
        }
      }
    }

    // Calculate percentage score
    final percentScore = (correctAnswers / totalQuestions * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil ${widget.kuis.title}'),
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
                      'Nilai Kuis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 140,
                      height: 140,
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
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(percentScore),
                              ),
                            ),
                            Text(
                              '$correctAnswers/$totalQuestions',
                              style: TextStyle(
                                fontSize: 16,
                                color: _getScoreColor(percentScore),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getScoreIcon(percentScore),
                          color: _getScoreColor(percentScore),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getScoreMessage(percentScore),
                          style: TextStyle(
                            color: _getScoreColor(percentScore),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                label: 'Kembali ke Detail Kuis',
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.teal,
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
    String answerText = 'Tidak dijawab';

    if (userAnswer != null) {
      if (question is MultipleChoiceQuestion) {
        isCorrect = userAnswer == question.correctAnswer;
        answerText = question.options[userAnswer];
      } else if (question is TrueFalseQuestion) {
        isCorrect = userAnswer == question.correctAnswer;
        answerText = userAnswer ? 'Benar' : 'Salah';
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
          Icon(
            userAnswer == null
                ? Icons.remove_circle
                : (isCorrect ? Icons.check_circle : Icons.cancel),
            color: userAnswer == null
                ? Colors.grey
                : (isCorrect ? Colors.green : Colors.red),
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
              color: userAnswer == null
                  ? Colors.grey.shade700
                  : (isCorrect ? Colors.green : Colors.red),
            ),
          ),
          if (!isCorrect && userAnswer != null)
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

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.sentiment_very_satisfied;
    if (score >= 60) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return 'Sangat Baik!';
    if (score >= 60) return 'Cukup Baik';
    return 'Perlu Ditingkatkan';
  }
}

// Question models - reused from the kerjakan_screen.dart
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

class TrueFalseQuestion extends Question {
  final bool correctAnswer;

  TrueFalseQuestion({
    required super.id,
    required super.text,
    required this.correctAnswer,
  });
}

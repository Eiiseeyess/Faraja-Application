import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({Key? key}) : super(key: key);

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isWriting = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleFinish() {
    setState(() {
      _isWriting = false;
    });
    _controller.clear();

    // Start the confetti animation
    _confettiController.play();

    // Show completion dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("🎉 Congratulations! 🎉"),
          content: const Text(
            "Great job! You've completed your Morning Pages. 📝",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Awesome, let's go!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Write your thoughts freely for 15 minutes or until you reach 300 words.",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: "Start writing...",
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isWriting = text.isNotEmpty;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isWriting ? _handleFinish : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor: theme.disabledColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledForegroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.38),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Finish"),
                ),
              ],
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                Colors.blue,
                Colors.pink,
                Colors.green,
                Colors.yellow,
              ],
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}

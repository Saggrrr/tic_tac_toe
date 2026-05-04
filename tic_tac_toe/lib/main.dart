import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        textTheme: GoogleFonts.orbitronTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NEON\nTIC TAC TOE',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00FFFF),
                height: 1.2,
                shadows: [
                  const Shadow(
                    blurRadius: 20.0,
                    color: Color(0xFF00FFFF),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            CyberButton(
              text: 'VS PLAYER',
              color: const Color(0xFF00FFFF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen(isAiMode: false)),
                );
              },
            ),
            const SizedBox(height: 30),
            CyberButton(
              text: 'VS A.I.',
              color: const Color(0xFFFF007F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen(isAiMode: true)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CyberButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CyberButton({super.key, required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0E15),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.orbitron(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: color.withOpacity(0.8),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final bool isAiMode;
  const GameScreen({super.key, required this.isAiMode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true; // true = X, false = O
  bool isGameOver = false;
  String winner = '';
  int player1Score = 0;
  int player2Score = 0;

  final Color colorX = const Color(0xFF00FFFF); // Neon Cyan
  final Color colorO = const Color(0xFFFF007F); // Neon Pink

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
      winner = '';
      isPlayer1Turn = true;
    });
  }

  void handleTap(int index) {
    if (board[index] != '' || isGameOver) return;
    if (widget.isAiMode && !isPlayer1Turn) return; // Prevent player tap during AI turn
    
    _processMove(index);
  }

  void _processMove(int index) {
    setState(() {
      board[index] = isPlayer1Turn ? 'X' : 'O';
      if (checkWinner(board[index])) {
        isGameOver = true;
        winner = board[index];
        if (winner == 'X') {
          player1Score++;
        } else {
          player2Score++;
        }
      } else if (!board.contains('')) {
        isGameOver = true;
        winner = 'Draw';
      } else {
        isPlayer1Turn = !isPlayer1Turn;
        if (widget.isAiMode && !isPlayer1Turn && !isGameOver) {
          Future.delayed(const Duration(milliseconds: 600), () => makeAiMove());
        }
      }
    });
  }

  void makeAiMove() {
    if (isGameOver || !mounted) return;
    int move = -1;

    // 1. Can AI win?
    move = findWinningMove('O');
    // 2. Can Player win? Block.
    if (move == -1) move = findWinningMove('X');
    // 3. Take center if available
    if (move == -1 && board[4] == '') move = 4;
    // 4. Random available move
    if (move == -1) {
      List<int> available = [];
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') available.add(i);
      }
      if (available.isNotEmpty) {
        move = available[Random().nextInt(available.length)];
      }
    }

    if (move != -1) {
      _processMove(move);
    }
  }

  int findWinningMove(String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var pattern in winPatterns) {
      int a = pattern[0], b = pattern[1], c = pattern[2];
      if (board[a] == player && board[b] == player && board[c] == '') return c;
      if (board[a] == player && board[c] == player && board[b] == '') return b;
      if (board[b] == player && board[c] == player && board[a] == '') return a;
    }
    return -1;
  }

  bool checkWinner(String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isAiMode ? 'VS A.I.' : 'VS PLAYER',
          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Scoreboard
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScorePanel('PLAYER X', player1Score, colorX),
                _buildScorePanel(widget.isAiMode ? 'A.I. O' : 'PLAYER O', player2Score, colorO),
              ],
            ),
            const SizedBox(height: 40),
            // Game Status
            Text(
              isGameOver 
                ? (winner == 'Draw' ? 'IT\'S A DRAW!' : 'PLAYER $winner WINS!')
                : 'PLAYER ${isPlayer1Turn ? 'X' : 'O'}\'S TURN',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isGameOver && winner == 'Draw'
                    ? Colors.white
                    : (isGameOver ? (winner == 'X' ? colorX : colorO) : (isPlayer1Turn ? colorX : colorO)),
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: isGameOver && winner == 'Draw'
                        ? Colors.white.withOpacity(0.5)
                        : (isGameOver ? (winner == 'X' ? colorX : colorO) : (isPlayer1Turn ? colorX : colorO)),
                  )
                ],
              ),
            ),
            const Spacer(),
            // Game Board
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141620),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1F2232),
                          width: 2,
                        ),
                        boxShadow: [
                          if (board[index] != '')
                            BoxShadow(
                              color: board[index] == 'X' 
                                  ? colorX.withOpacity(0.15) 
                                  : colorO.withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                        ]
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Text(
                            board[index],
                            key: ValueKey<String>(board[index]),
                            style: GoogleFonts.rajdhani(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: board[index] == 'X' ? colorX : colorO,
                              shadows: board[index] == '' ? [] : [
                                Shadow(
                                  blurRadius: 20,
                                  color: board[index] == 'X' ? colorX : colorO,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            if (isGameOver)
              CyberButton(
                text: 'PLAY AGAIN',
                color: Colors.white,
                onTap: resetGame,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildScorePanel(String title, int score, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: Colors.white70,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: GoogleFonts.rajdhani(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [
              Shadow(
                blurRadius: 20.0,
                color: color.withOpacity(0.8),
              )
            ],
          ),
        ),
      ],
    );
  }
}

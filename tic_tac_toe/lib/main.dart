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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color colorX = const Color(0xFF00FFFF);
  Color colorO = const Color(0xFFFF007F);

  static const List<Color> neonColors = [
    Color(0xFF00FFFF), // Cyan
    Color(0xFFFF007F), // Pink
    Color(0xFF39FF14), // Green
    Color(0xFFFFEA00), // Yellow
    Color(0xFFB026FF), // Purple
    Color(0xFFFF4500), // Orange
  ];

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF141620),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF1F2232), width: 2),
                borderRadius: BorderRadius.circular(16)
              ),
              title: Text('CHOOSE COLORS', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PLAYER X', style: GoogleFonts.orbitron(color: colorX, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: neonColors.map((c) => GestureDetector(
                      onTap: () {
                        setStateDialog(() => colorX = c);
                        setState(() {});
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorX == c ? Colors.white : Colors.transparent, width: 3),
                          boxShadow: [BoxShadow(color: c.withAlpha(150), blurRadius: 10)]
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('PLAYER O', style: GoogleFonts.orbitron(color: colorO, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: neonColors.map((c) => GestureDetector(
                      onTap: () {
                        setStateDialog(() => colorO = c);
                        setState(() {});
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorO == c ? Colors.white : Colors.transparent, width: 3),
                          boxShadow: [BoxShadow(color: c.withAlpha(150), blurRadius: 10)]
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('DONE', style: GoogleFonts.orbitron(color: Colors.white)),
                )
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NEON\nTIC TAC TOE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(blurRadius: 20.0, color: Colors.white.withAlpha(150), offset: const Offset(0, 0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    CyberButton(
                      text: 'VS PLAYER',
                      color: colorX,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen(isAiMode: false, colorX: colorX, colorO: colorO)),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    CyberButton(
                      text: 'VS A.I.',
                      color: colorO,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen(isAiMode: true, colorX: colorX, colorO: colorO)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 30),
                onPressed: _openSettings,
              ),
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
              color: color.withAlpha(76),
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
                  color: color.withAlpha(204),
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
  final Color colorX;
  final Color colorO;
  
  const GameScreen({super.key, required this.isAiMode, required this.colorX, required this.colorO});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true; // true = X, false = O
  bool isGameOver = false;
  String winner = '';
  List<int> winningLine = [];
  int player1Score = 0;
  int player2Score = 0;

  late Color colorX;
  late Color colorO;

  @override
  void initState() {
    super.initState();
    colorX = widget.colorX;
    colorO = widget.colorO;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
      winner = '';
      winningLine = [];
      isPlayer1Turn = true;
    });
  }

  void handleTap(int index) {
    if (board[index] != '' || isGameOver) return;
    if (widget.isAiMode && !isPlayer1Turn) return; // Prevent player tap during AI turn
    
    _processMove(index);
  }

  List<int>? getWinningPattern(String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return pattern;
      }
    }
    return null;
  }

  void _processMove(int index) {
    setState(() {
      board[index] = isPlayer1Turn ? 'X' : 'O';
      
      var winPattern = getWinningPattern(board[index]);
      if (winPattern != null) {
        isGameOver = true;
        winner = board[index];
        winningLine = winPattern;
        if (winner == 'X') {
          player1Score++;
        } else {
          player2Score++;
        }
      } else if (!board.contains('')) {
        isGameOver = true;
        winner = 'Draw';
        winningLine = [];
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
              children: [
                // Scoreboard
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScorePanel('PLAYER X', player1Score, colorX),
                    _buildScorePanel(widget.isAiMode ? 'A.I. O' : 'PLAYER O', player2Score, colorO),
                  ],
                ),
                const SizedBox(height: 30),
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
                            ? Colors.white.withAlpha(128)
                            : (isGameOver ? (winner == 'X' ? colorX : colorO) : (isPlayer1Turn ? colorX : colorO)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Game Board
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: [
                            GridView.builder(
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
                                                ? colorX.withAlpha(38) 
                                                : colorO.withAlpha(38),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          )
                                      ]
                                    ),
                                    child: Center(
                                      child: _buildNeonShape(board[index]),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (winningLine.isNotEmpty)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic,
                                    builder: (context, double val, child) {
                                      return CustomPaint(
                                        painter: StrikeLinePainter(
                                          winningLine: winningLine,
                                          color: winner == 'X' ? colorX : colorO,
                                          progress: val,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              if (isGameOver)
                CyberButton(
                  text: 'PLAY AGAIN',
                  color: Colors.white,
                  onTap: resetGame,
                ),
              if (!isGameOver) const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonShape(String value) {
    if (value == '') return const SizedBox.shrink();
    
    if (value == 'X') {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, double val, child) {
          return Transform.scale(
            scale: val,
            child: Transform.rotate(
              angle: (1.0 - val) * pi,
              child: child,
            ),
          );
        },
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: colorX,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(color: colorX.withAlpha(150), blurRadius: 12, spreadRadius: 2)
                    ]
                  ),
                ),
              ),
              Transform.rotate(
                angle: -pi / 4,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: colorX,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(color: colorX.withAlpha(150), blurRadius: 12, spreadRadius: 2)
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, double val, child) {
          return Transform.scale(
            scale: val,
            child: child,
          );
        },
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.6,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorO, width: 10),
              boxShadow: [
                BoxShadow(color: colorO.withAlpha(150), blurRadius: 12, spreadRadius: 2)
              ]
            ),
          ),
        ),
      );
    }
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
                color: color.withAlpha(204),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class StrikeLinePainter extends CustomPainter {
  final List<int> winningLine;
  final Color color;
  final double progress;

  StrikeLinePainter({required this.winningLine, required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (winningLine.isEmpty || progress == 0) return;

    final glowPaint = Paint()
      ..color = color.withAlpha(150)
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double spacing = 12.0;
    double cellW = (size.width - 2 * spacing) / 3;
    double cellH = (size.height - 2 * spacing) / 3;

    Offset getCenter(int index) {
      int row = index ~/ 3;
      int col = index % 3;
      double x = col * (cellW + spacing) + cellW / 2;
      double y = row * (cellH + spacing) + cellH / 2;
      return Offset(x, y);
    }

    Offset startPoint = getCenter(winningLine.first);
    Offset endPoint = getCenter(winningLine.last);

    Offset direction = endPoint - startPoint;
    double length = direction.distance;
    if (length == 0) return;
    direction = direction / length;

    Offset p1 = startPoint - direction * (cellW * 0.35);
    Offset p2 = endPoint + direction * (cellW * 0.35);

    Offset currentP2 = p1 + (p2 - p1) * progress;

    canvas.drawLine(p1, currentP2, glowPaint);
    canvas.drawLine(p1, currentP2, paint);
  }

  @override
  bool shouldRepaint(covariant StrikeLinePainter oldDelegate) {
    return oldDelegate.winningLine != winningLine || 
           oldDelegate.color != color || 
           oldDelegate.progress != progress;
  }
}

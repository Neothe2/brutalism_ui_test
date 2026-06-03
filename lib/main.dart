import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const BrutalDebuggerApp());
}

class BrutalDebuggerApp extends StatelessWidget {
  const BrutalDebuggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debugger Sandbox',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE5E5E5),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      home: const DebuggerDashboard(),
    );
  }
}

class DebuggerDashboard extends StatefulWidget {
  const DebuggerDashboard({super.key});

  @override
  State<DebuggerDashboard> createState() => _DebuggerDashboardState();
}

class _DebuggerDashboardState extends State<DebuggerDashboard> {
  // ==========================================
  // STATE TO INSPECT (Variable Inspection Test)
  // ==========================================
  int _executionCount = 0;
  String _latestLog = "SYSTEM READY.";
  bool _isRunning = false;

  // Complex state to test deep tree inspection in the debugger
  final Map<String, dynamic> _complexStateTree = {
    "engine": "V8_SIM",
    "metrics": {
      "threads": 4,
      "heap_usage_mb": 12.4,
      "flags": ["--optimize", "--strict", "--verbose"],
    },
    "history": <int>[],
  };

  // ==========================================
  // DEBUGGER TEST METHODS
  // ==========================================

  void _testStepInAndOver() {
    setState(() => _latestLog = "Running Step Test...");

    // [DEBUGGER TEST: SET BREAKPOINT ON THE LINE BELOW]
    int x = Random().nextInt(50);
    int y = Random().nextInt(50);
    print("Hello this is something I am printing in the console.");

    // Test 'Step Over' on the next few lines
    int multiplier = 42;
    int baseValue = x + y;

    // Test 'Step In' when you hit this function call
    int finalResult = _complexCalculation(baseValue, multiplier);

    setState(() {
      _executionCount++;
      _complexStateTree["history"].add(finalResult);
      _latestLog = "Step test complete. Result: $finalResult";
    });
  }

  int _complexCalculation(int a, int b) {
    // You should now be stepped INTO this method.
    int intermediate = a * b;

    // Inspect the 'intermediate' variable here.
    if (intermediate % 2 == 0) {
      intermediate = intermediate ~/ 2;
    } else {
      intermediate = (intermediate * 3) + 1;
    }

    return intermediate;
  }

  void _testAsyncPause() async {
    setState(() {
      _isRunning = true;
      _latestLog = "Running Async Loop... Try hitting PAUSE.";
    });

    // [DEBUGGER TEST: HIT THE 'PAUSE' BUTTON IN YOUR IDE WHILE THIS LOOPS]
    for (int i = 1; i <= 50; i++) {
      if (!mounted) return;

      // Update state to see changes happen slowly
      setState(() {
        _complexStateTree["metrics"]["heap_usage_mb"] = 12.4 + (i * 0.1);
      });

      // The debugger should halt execution right around here if you hit pause.
      await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      _isRunning = false;
      _executionCount++;
      _latestLog = "Async loop finished.";
    });
  }

  void _testVariableMutation() {
    // [DEBUGGER TEST: SET BREAKPOINT HERE]
    // 1. Hover over '_executionCount'
    // 2. Use the debugger console/variables tab to MANUALLY change its value
    // 3. Resume execution to see your forced value rendered in the UI
    int originalValue = _executionCount;
    int newValue = originalValue + 100;

    setState(() {
      _executionCount = newValue;
      _latestLog = "Mutated value. Did you change it in the debugger?";
    });
  }

  // ==========================================
  // BRUTALIST UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildLogConsole(),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    BrutalistButton(
                      label: "TEST: STEP IN & OVER",
                      color: const Color(0xFF00FF41),
                      onPressed: _testStepInAndOver,
                    ),
                    const SizedBox(height: 24),
                    BrutalistButton(
                      label: _isRunning ? "RUNNING..." : "TEST: ASYNC PAUSE",
                      color: const Color(0xFFFFE600),
                      onPressed: _isRunning ? () {} : _testAsyncPause,
                    ),
                    const SizedBox(height: 24),
                    BrutalistButton(
                      label: "TEST: VARIABLE MUTATION",
                      color: const Color(0xFFFF003C),
                      onPressed: _testVariableMutation,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DEBUGGER_UI",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "EXECUTION COUNT: $_executionCount",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLogConsole() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LATEST LOG_OUTPUT:",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            _latestLog,
            style: const TextStyle(
              color: Color(0xFF00FF41),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CUSTOM BRUTALIST COMPONENTS
// ==========================================

class BrutalistButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const BrutalistButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<BrutalistButton> createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<BrutalistButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) =>
      setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    // Brutalist animations use stark, solid translations rather than soft blurs.
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 75),
        curve: Curves.easeOutQuad,
        // The core brutalist interaction: physical translation mimicking a heavy mechanical switch
        transform: Matrix4.translationValues(
          _isPressed ? 6.0 : 0.0,
          _isPressed ? 6.0 : 0.0,
          0.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.black, width: 4),
            // The shadow disappears as the button physically translates to fill that space
            boxShadow: _isPressed
                ? []
                : const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

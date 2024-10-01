import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

/// Simplest possible model, with just one field.
class Counter with ChangeNotifier {
  int value = 0; // Initial age value set to 0

  void increment() {
    value += 1; // Increase the age by 1
    notifyListeners(); // Notify listeners to rebuild
  }

  void decrement() {
    value -= 1; // Decrease the age by 1
    notifyListeners(); // Notify listeners to rebuild
  }

  String get milestoneMessage {
    if (value >= 0 && value <= 12) {
      return "You're a child!";
    } else if (value >= 13 && value <= 19) {
      return "Teenager time!";
    } else if (value >= 20 && value <= 30) {
      return "You're a young adult!";
    } else if (value >= 31 && value <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color get backgroundColor {
    if (value >= 0 && value <= 12) {
      return Colors.lightBlue; // Light Blue
    } else if (value >= 13 && value <= 19) {
      return Colors.lightGreen; // Light Green
    } else if (value >= 20 && value <= 30) {
      return const Color(0xFFFEFFB3); // Light Yellow using hex code #FEFFB3
    } else if (value >= 31 && value <= 50) {
      return Colors.orange; // Orange
    } else {
      return Colors.grey[300]!; // Light Gray
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>(); // Listen to counter changes
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: counter.backgroundColor, // Set background color based on age
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<Counter>(
                builder: (context, counter, child) => Text(
                  'I am ${counter.value} years old', // Displays the current age
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 20), // Add space between text and buttons
              Text(
                counter.milestoneMessage, // Display milestone message
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Add space between message and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.increment(); // Increases age by 1
                    },
                    child: const Text('Increase Age'),
                  ),
                  const SizedBox(width: 20), // Add space between buttons
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.decrement(); // Decreases age by 1
                    },
                    child: const Text('Decrease Age'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

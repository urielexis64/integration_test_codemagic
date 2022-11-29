import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Typing App',
      home: TypingPage(),
    );
  }
}

class TypingPage extends StatefulWidget {
  const TypingPage({super.key});

  @override
  State<TypingPage> createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Typing")),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Form(
              key: _formKey,
              child: TextFormField(
                key: const Key("your-text-field"),
                controller: _controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Your text"),
                validator: (value) {
                  return value != null && value.isEmpty
                      ? "Input at least one character"
                      : null;
                },
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPage(
                  displayText: _controller.text,
                  doOnInit: () => Future.microtask(() => _controller.clear()),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class DisplayPage extends StatefulWidget {
  const DisplayPage(
      {super.key, required this.displayText, required this.doOnInit});

  final String displayText;
  final VoidCallback doOnInit;

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  void initState() {
    super.initState();
    widget.doOnInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(widget.displayText),
      ),
    );
  }
}

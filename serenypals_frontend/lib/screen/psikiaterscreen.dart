import 'package:flutter/material.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Page")),
      body: Center(child: Text("AI Assistant")),
    );
  }
}

class PsikiaterPage extends StatelessWidget {
  const PsikiaterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Psikiater")),
      body: Center(child: Text("Hubungi Psikiater")),
    );
  }
}

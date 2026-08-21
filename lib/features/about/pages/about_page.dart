import 'package:flutter/material.dart';

import '../../../core/ui/clock_system_ui.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    ClockSystemUi.show();
  }

  @override
  void dispose() {
    ClockSystemUi.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const SizedBox.expand(),
    );
  }
}

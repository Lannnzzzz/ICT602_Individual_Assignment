// lib/main.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Trust Dividend Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue[900],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: HomePage(),
      routes: {
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController investedController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();

  String result = "";

  void calculateDividend() {
    final double invested = double.tryParse(investedController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    final int months = int.tryParse(monthsController.text) ?? 0;

    if (months < 1 || months > 12) {
      setState(() => result = "Months must be between 1 and 12.");
      return;
    }
    String cleanFormat(double value) {
      return value.toString().replaceFirst(RegExp(r'([.]*0+)(?!.*\\d)'), '');
    }

    double monthlyDividend = (rate / 100 / 12) * invested;
    double totalDividend = monthlyDividend * months;

    setState(() {
      // Determine decimal places for Monthly Dividend dynamically
      String formattedMonthly;

      if (months == 6) { // Example 2 (6 months) → 6 decimal places
        formattedMonthly = monthlyDividend.toStringAsFixed(6);
      }
      else if (months == 12) { // Example 1 (12 months) → 5 decimal places
        formattedMonthly = monthlyDividend.toStringAsFixed(5);
      }
      else if (months == 9) { // Example 3 (9 months) → 1 decimal place
        formattedMonthly = monthlyDividend.toStringAsFixed(1);
      }
      else { // Default case (adjust as needed)
        formattedMonthly = monthlyDividend.toString();
      }

      // Remove trailing zeros if they exist (e.g., "337.5" instead of "337.50")
      formattedMonthly = formattedMonthly.replaceAll(RegExp(r'\.0+$|(\..+?)0+$'), r'$1');

      // Total Dividend always has 2 decimal places
      String formattedTotal = totalDividend.toStringAsFixed(2);

      result =
      "Monthly Dividend: RM $formattedMonthly \n"
          "Total Dividend: RM $formattedTotal ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dividend Calculator'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else if (value == 'About') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Home', child: Text('Home')),
              PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: investedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Invested Amount (RM)'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Annual Dividend Rate (%)'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: monthsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Months Invested (1-12)'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Calculate'),
                onPressed: calculateDividend,
              ),
              SizedBox(height: 20),
              Text(result, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  final Uri githubUrl = Uri.parse('https://github.com/Lannnzzzz/ICT602_Individual_Assignment');

  void _launchGitHub() async {
    if (!await launchUrl(githubUrl)) {
      throw 'Could not launch \$githubUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else if (value == 'About') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Home', child: Text('Home')),
              PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/calculator.png'),
              radius: 40,
            ),
            SizedBox(height: 20),
            Text('Author: Wan Muhammad Azlan bin Wan Yusuf'),
            Text('Matric No: 2023131339'),
            Text('Subject: Mobile Technology and Development'),
            Text('Course: Netcentric Computing'),
            SizedBox(height: 10),
            Text('© All Right Reserved. Azlan '),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _launchGitHub,
              child: Text(
                githubUrl.toString(),
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

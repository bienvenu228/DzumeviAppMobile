
import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/core/provider/candidats.dart';
import 'package:dzumevimobile/core/provider/concours.dart';
import 'package:dzumevimobile/core/provider/paiement.dart';
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:dzumevimobile/core/theme.dart';
import 'package:dzumevimobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const DzumeviApp());
}

class DzumeviApp extends StatelessWidget {
  const DzumeviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConcoursProvider()),
        ChangeNotifierProvider(create: (_) => CandidatProvider()),
        ChangeNotifierProvider(create: (_) => PaiementProvider()),
      ],

      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashEntry(),
      ),
    );
  }
}

// SplashScreen animé (inchangé, magnifique)
class SplashEntry extends StatefulWidget {
  const SplashEntry({super.key});

  @override
  State<SplashEntry> createState() => _SplashEntryState();
}

class _SplashEntryState extends State<SplashEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ConcoursListScreen(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primary,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: AppConstants.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, size: 90, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Text(
                "Dzumevi",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Votez avec votre cœur",
                style: TextStyle(fontSize: 18, color: AppConstants.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/user_profile.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a mock user profile
    final mockProfile = UserProfile(
      professional: ProfileData(
        name: 'Alex Johnson',
        bio: 'Senior Product Manager with 8+ years of experience in tech. Passionate about building products that solve real-world problems.',
        role: 'Senior Product Manager',
        company: 'Tech Innovations Inc.',
        links: [
          'https://linkedin.com/in/alexjohnson',
          'https://twitter.com/alexjohnson'
        ],
        photoUrl: 'https://example.com/photos/alex_professional.jpg',
      ),
      personal: ProfileData(
        name: 'Alex J.',
        bio: 'Hiking enthusiast and amateur photographer. Love exploring new places and capturing moments.',
        role: 'Adventure Seeker',
        links: [
          'https://instagram.com/alexj_adventures',
        ],
        photoUrl: 'https://example.com/photos/alex_personal.jpg',
      ),
    );

    return MaterialApp(
      title: 'Dekad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(profile: mockProfile),
    );
  }
}
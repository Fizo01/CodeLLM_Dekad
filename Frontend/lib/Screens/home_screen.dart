import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../services/exchange_service.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isProfessionalMode = true;
  String? _rewrittenBio;

  ProfileData get _currentProfile =>
      isProfessionalMode ? widget.profile.professional : widget.profile.personal;

  void _toggleProfileMode() {
    setState(() {
      isProfessionalMode = !isProfessionalMode;
    });
  }

  void _exchangeViaNFC() async {
    try {
      await ExchangeService.exchangeViaNFC(widget.profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NFC exchange completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NFC exchange failed: $e')),
      );
    }
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final qrPayload = ExchangeService.generateQRPayload(widget.profile);
        return AlertDialog(
          title: const Text('Your QR Code'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: QrImageView(
              data: qrPayload,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _rewriteBio() async {
    try {
      final rewrittenBio = await ApiService.rewriteBio(
        _currentProfile.bio,
        isProfessionalMode ? 'professional' : 'personal',
        200,
      );
      
      setState(() {
        _rewrittenBio = rewrittenBio;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bio rewritten: $rewrittenBio')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rewrite bio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dekad'),
        actions: [
          Switch(
            value: isProfessionalMode,
            onChanged: (value) => _toggleProfileMode(),
          ),
          const Text('Personal'),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentProfile.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(_currentProfile.role),
            if (_currentProfile.company != null)
              Text(_currentProfile.company!),
            const SizedBox(height: 16),
            Text(
              _rewrittenBio ?? _currentProfile.bio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _exchangeViaNFC,
                  child: const Text('Exchange via NFC'),
                ),
                ElevatedButton(
                  onPressed: _showQRCode,
                  child: const Text('Show QR Code'),
                ),
                ElevatedButton(
                  onPressed: _rewriteBio,
                  child: const Text('Rewrite Bio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
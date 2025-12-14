import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String websiteUrl = 'https://www.redarrowloans.net/';

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFFE53935); // Brand red
    final Color accent = const Color(0xFFD32F2F); // Slightly darker red
    final Color muted = Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),
            Text(
              'Red Arrow Loans',
              style: TextStyle(color: primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _launchURL(websiteUrl),
            icon: const Icon(Icons.language),
            tooltip: 'Visit Website',
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _heroSection(primary, accent),
            const SizedBox(height: 24),
            _quickApplyCard(context, primary, accent),
            const SizedBox(height: 24),
            _sectionTitle('Why Choose Us'),
            const SizedBox(height: 12),
            _featuresRow(primary),
            const SizedBox(height: 24),
            _sectionTitle('Our Services'),
            const SizedBox(height: 12),
            _serviceCards(context, primary, accent),
            const SizedBox(height: 24),
            _trustSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchURL(websiteUrl),
        label: const Text('Apply Now'),
        icon: const Icon(Icons.arrow_forward),
        backgroundColor: accent,
      ),
    );
  }

  Widget _heroSection(Color primary, Color accent) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.9), accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0x66000000), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'Fast • Simple • Secure',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get Funds When You Need',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _launchURL(websiteUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 28),
                      elevation: 6,
                    ),
                    child: const Text('Apply Now'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Trust Score',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 8),
                  Text('4.8/5',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickApplyCard(BuildContext context, Color primary, Color accent) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: accent.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.edit_note, color: primary, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Application',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Fill a short form and get instant response.',
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _launchURL(websiteUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                elevation: 4,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _featuresRow(Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureItem(Icons.flash_on, 'Instant', primary),
        _featureItem(Icons.attach_money, 'Low Rates', primary),
        _featureItem(Icons.lock, 'Secure', primary),
      ],
    );
  }

  Widget _featureItem(IconData icon, String title, Color primary) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: primary.withOpacity(0.15),
            child: Icon(icon, color: primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _serviceCards(BuildContext context, Color primary, Color accent) {
    final services = [
      {
        'title': 'Personal Loan',
        'desc': 'Quick funds for personal needs.',
        'img': 'assets/images/feature1.png'
      },
      {
        'title': 'Business Loan',
        'desc': 'Fuel your business growth.',
        'img': 'assets/images/feature2.png'
      },
      {
        'title': 'Loan Against Property',
        'desc': 'Use your property for better rates.',
        'img': 'assets/images/feature3.png'
      },
    ];

    return Column(
      children: services
          .map((s) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: accent.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.asset(s['img']!, width: 56, height: 56),
                  title: Text(s['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(s['desc']!),
                  trailing: ElevatedButton(
                    onPressed: () => _launchURL(websiteUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                    ),
                    child: const Text('Know More'),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _trustSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('What Customers Say',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 12),
        Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
                '"Excellent and quick service. Highly recommended!" — Priya, Mumbai'),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

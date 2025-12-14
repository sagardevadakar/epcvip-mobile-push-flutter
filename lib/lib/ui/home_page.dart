import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String websiteUrl = 'https://www.redarrowloans.net/';

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF4CAF50); // Fresh green
    final Color dark = const Color(0xFF111111);
    final Color muted = Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),
            Text('Red Arrow Loans', style: TextStyle(color: dark)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _launchURL(websiteUrl),
            icon: const Icon(Icons.language, color: Colors.black87),
            tooltip: 'Visit Website',
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
              .copyWith(bottom: 120), // extra bottom space for FAB
          children: [
            _hero(context, primary),
            const SizedBox(height: 20),
            _quickApplyCard(context, primary),
            const SizedBox(height: 18),
            Text('Why Choose Us',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _featuresRow(primary),
            const SizedBox(height: 22),
            Text('Our Services',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _serviceCards(context),
            const SizedBox(height: 24),
            _trustSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchURL(websiteUrl),
        label: const Text(
          'Get Your Loan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        backgroundColor: primary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }

  // HERO BANNER (responsive height)
  Widget _hero(BuildContext context, Color primary) {
  final double height = MediaQuery.of(context).size.height * 0.28;

    return Container(
    constraints: BoxConstraints(minHeight: height),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      image: const DecorationImage(
        image: AssetImage('assets/images/banner.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Color(0x66000000), BlendMode.darken),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(), // prevent scroll
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // adapt to content
                children: [
                  Text('Fast • Simple • Secure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      )),
                  const SizedBox(height: 8),
                  Text('Get Funds When You Need',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: primary,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20))),
                  //   onPressed: () => _launchURL(HomePage.websiteUrl),
                  //   child: const Text('Get Your Loan'),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
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


  Widget _quickApplyCard(BuildContext context, Color primary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
        child: Row(
          children: [
            Icon(Icons.edit_note, color: primary, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Application',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('Fill a short form and get instant response.',
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              onPressed: () async => await _launchURL(HomePage.websiteUrl),
              child: const Text('Start', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuresRow(Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureItem(icon: Icons.flash_on, title: 'Instant', primary: primary),
        _featureItem(
            icon: Icons.attach_money, title: 'Low Rates', primary: primary),
        _featureItem(icon: Icons.lock, title: 'Secure', primary: primary),
      ],
    );
  }

  Widget _featureItem(
      {required IconData icon, required String title, required Color primary}) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: primary.withOpacity(0.12),
            child: Icon(icon, color: primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _serviceCards(BuildContext context) {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Personal Loan',
      'desc': 'Quick funds for personal needs.',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'title': 'Business Loan',
      'desc': 'Fuel your business growth.',
      'icon': Icons.business_center,
      'color': Colors.green,
    },
    {
      'title': 'Loan Against Property',
      'desc': 'Use your property for better rates.',
      'icon': Icons.house,
      'color': Colors.green,
    },
  ];

  return Column(
    children: services.map((s) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: s['color'].withOpacity(0.12),
            child: Icon(s['icon'], color: s['color'], size: 28),
          ),
          title: Text(s['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(s['desc']),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: s['color']),
            onPressed: () async => await _launchURL(HomePage.websiteUrl),
            child: const Text('Know More', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _trustSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('What customers say',
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
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint(" Invalid URL: $url");
      return;
    }

    if (!await canLaunchUrl(uri)) {
      debugPrint(" Cannot launch: $url");
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // ensures browser opens
    );
  }

}

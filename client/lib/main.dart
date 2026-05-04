import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiBase = 'http://localhost:8080';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion La Poste',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFD700)),
        useMaterial3: true,
        cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text('Gestion La Poste', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('La Poste', style: TextStyle(fontWeight: FontWeight.w600)),
          )
        ],
      ),
      floatingActionButton: Tooltip(
        message: 'Demande client',
        child: FloatingActionButton(
          backgroundColor: Colors.cyan,
          child: const Text('!', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrestationsPage())),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _MenuTile(icon: Icons.calendar_today, label: 'Planning du jour', color: const Color(0xFFFFD700), page: const PlaceholderPage(title: 'Planning du jour')),
              _MenuTile(icon: Icons.swap_horiz, label: 'Affecter Tournée', color: const Color(0xFF4CAF50), page: const PlaceholderPage(title: 'Affecter Tournée')),
              _MenuTile(icon: Icons.local_shipping, label: 'Affecter Prestation', color: const Color(0xFF2196F3), page: const PlaceholderPage(title: 'Affecter Prestation')),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String label;
  final Widget page;
  final IconData icon;
  final Color color;
  const _MenuTile({required this.label, required this.page, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class PrestationsPage extends StatefulWidget {
  const PrestationsPage({super.key});

  @override
  State<PrestationsPage> createState() => _PrestationsPageState();
}

class _PrestationsPageState extends State<PrestationsPage> {
  List prestations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPrestations();
  }

  Future<void> fetchPrestations() async {
    final response = await http.get(Uri.parse('$apiBase/prestations'));
    if (response.statusCode == 200) {
      setState(() {
        prestations = jsonDecode(response.body);
        loading = false;
      });
    }
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'collecte': return Icons.inbox;
      case 'expbal': return Icons.send;
      default: return Icons.mail_outline;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'collecte': return Colors.orange;
      case 'expbal': return Colors.blue;
      default: return Colors.yellow.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text('Demandes client', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prestations.length,
              itemBuilder: (context, index) {
                final p = prestations[index];
                final type = p['type'] ?? '';
                final color = _colorForType(type);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_iconForType(type), color: color, size: 22),
                    ),
                    title: Text(type, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey))),
                        ],
                      ),
                    ),
                    trailing: p['tournee'] != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text('T${p['tournee']['numero']}', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Non affectée', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ),
                  ),
                );
              },
            ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: const SizedBox(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Adresse de base de l'API Spring Boot — à modifier à chaque changement de réseau
const String apiBase = 'http://192.168.1.14:8080'; // A MODIFIER A CHAQUE FOIS

// --- COULEURS DU THÈME MODERNE ---
const Color kPrimaryColor = Color(0xFFFFCC00); // Jaune La Poste adouci
const Color kBackgroundColor = Color(0xFFF4F6F8); // Fond gris/bleuté très clair
const Color kTextColor = Color(0xFF2D3142); // Bleu nuit pour le texte (plus doux que le noir)
const Color kCardColor = Colors.white;

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
        scaffoldBackgroundColor: kBackgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          primary: kPrimaryColor,
          surface: kBackgroundColor,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: kTextColor),
          titleTextStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kTextColor),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ==========================================
// ACCUEIL
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion La Poste'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Connecté',
              style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor, fontSize: 13),
            ),
          )
        ],
      ),
      // Boutons flottants modernisés avec icônes et textes
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'admin',
            backgroundColor: kTextColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.admin_panel_settings_rounded, size: 20),
            label: const Text('Administration', style: TextStyle(fontWeight: FontWeight.w600)),
            elevation: 4,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage())),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'demande',
            backgroundColor: Colors.cyan.shade600,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.support_agent_rounded, size: 20),
            label: const Text('Demandes Client', style: TextStyle(fontWeight: FontWeight.w600)),
            elevation: 4,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrestationsPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Que souhaitez-vous faire ?',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _MenuTile(
                    icon: Icons.calendar_month_rounded,
                    label: 'Planning du jour',
                    color: kPrimaryColor,
                    page: const PlanningPage(),
                  ),
                  _MenuTile(
                    icon: Icons.person_add_alt_1_rounded,
                    label: 'Affecter Tournée',
                    color: const Color(0xFF4CAF50),
                    page: const AffecterFacteurPage(),
                  ),
                  _MenuTile(
                    icon: Icons.local_shipping_rounded,
                    label: 'Affecter Prestation',
                    color: const Color(0xFF2196F3),
                    page: const AffecterTourneePage(),
                  ),
                ],
              ),
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

  const _MenuTile({
    required this.label,
    required this.page,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul de la largeur pour s'adapter à l'écran tout en gardant l'aspect tuile
    double screenWidth = MediaQuery.of(context).size.width;
    double tileWidth = screenWidth > 400 ? 160 : (screenWidth / 2) - 34;

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: tileWidth,
        height: 160,
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// DEMANDES CLIENTS (PRESTATIONS)
// ==========================================
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
      case 'collecte': return Icons.inbox_rounded;
      case 'expbal': return Icons.send_rounded;
      default: return Icons.mark_email_unread_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'collecte': return Colors.orange;
      case 'expbal': return Colors.blue;
      default: return Colors.amber.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demandes client')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: prestations.length,
              itemBuilder: (context, index) {
                final p = prestations[index];
                final type = p['type'] ?? '';
                final color = _colorForType(type);
                final bool isAssigned = p['tournee'] != null;

                return _ModernCard(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                      child: Icon(_iconForType(type), color: color, size: 24),
                    ),
                    title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black54))),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isAssigned ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isAssigned ? Colors.green.shade200 : Colors.grey.shade300),
                      ),
                      child: Text(
                        isAssigned ? 'T${p['tournee']['numero']}' : 'Non affectée',
                        style: TextStyle(
                          fontSize: 12,
                          color: isAssigned ? Colors.green.shade700 : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// AFFECTER TOURNEE (Facteur -> Tournée)
// ==========================================
class AffecterFacteurPage extends StatefulWidget {
  const AffecterFacteurPage({super.key});

  @override
  State<AffecterFacteurPage> createState() => _AffecterFacteurPageState();
}

class _AffecterFacteurPageState extends State<AffecterFacteurPage> {
  List facteurs = [];
  List tournees = [];
  bool loading = true;
  int? selectedFacteurId;
  int? selectedTourneeId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final resFacteurs = await http.get(Uri.parse('$apiBase/facteurs'));
    final resTournees = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() {
      facteurs = jsonDecode(resFacteurs.body);
      tournees = jsonDecode(resTournees.body);
      loading = false;
    });
  }

  Future<void> affecter() async {
    if (selectedFacteurId == null) {
      _showSnackBar('Sélectionne un facteur', Colors.redAccent);
      return;
    }
    final response = await http.post(
      Uri.parse('$apiBase/affectations/simple'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idFacteur': selectedFacteurId,
        'idTournee': selectedTourneeId,
        'roleAffectation': 'TITULAIRE',
      }),
    );
    if (response.statusCode == 200) {
      _showSnackBar('Affectation enregistrée !', Colors.green);
      setState(() {
        selectedFacteurId = null;
        selectedTourneeId = null;
      });
    } else {
      _showSnackBar('Erreur lors de l\'affectation', Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affecter Tournée')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Sélectionnez un facteur'),
                  const SizedBox(height: 12),
                  _ModernDropdown<int?>(
                    value: selectedFacteurId,
                    hint: 'Choisir un facteur',
                    items: facteurs.map((f) => DropdownMenuItem<int?>(
                      value: f['id'] as int,
                      child: Text('${f['prenom']} ${f['nom']} — ${f['role']}'),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedFacteurId = val),
                  ),
                  const SizedBox(height: 32),
                  const _SectionTitle('Sélectionnez une tournée'),
                  const SizedBox(height: 12),
                  _ModernDropdown<int?>(
                    value: selectedTourneeId,
                    hint: 'Choisir une tournée',
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('Aucune tournée', style: TextStyle(color: Colors.grey))),
                      ...tournees.map((t) => DropdownMenuItem<int?>(
                        value: t['id'] as int,
                        child: Text('T${t['numero']} — ${t['vehicule']}'),
                      )),
                    ],
                    onChanged: (val) => setState(() => selectedTourneeId = val),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: affecter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kTextColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                      ),
                      child: const Text('Confirmer l\'affectation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ==========================================
// AFFECTER PRESTATION (Prestation -> Tournée)
// ==========================================
class AffecterTourneePage extends StatefulWidget {
  const AffecterTourneePage({super.key});

  @override
  State<AffecterTourneePage> createState() => _AffecterTourneePageState();
}

class _AffecterTourneePageState extends State<AffecterTourneePage> {
  List prestations = [];
  List tournees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final resPrestations = await http.get(Uri.parse('$apiBase/prestations'));
    final resTournees = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() {
      prestations = jsonDecode(resPrestations.body);
      tournees = jsonDecode(resTournees.body);
      loading = false;
    });
  }

  Future<void> setTournee(int idPrestation, int? idTournee) async {
    await http.put(
      Uri.parse('$apiBase/prestations/$idPrestation/tournee'),
      headers: {'Content-Type': 'application/json'},
      body: idTournee == null ? 'null' : '$idTournee',
    );
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affecter Prestation')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: prestations.length,
              itemBuilder: (context, index) {
                final p = prestations[index];
                final int? currentTourneeId = p['tournee']?['id'];
                
                return _ModernCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_shipping_rounded, color: Colors.blue.shade400, size: 20),
                            const SizedBox(width: 8),
                            Text(p['type'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(child: Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black54))),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        _ModernDropdown<int?>(
                          value: currentTourneeId,
                          hint: 'Aucune tournée',
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: Text('Aucune tournée', style: TextStyle(color: Colors.grey))),
                            ...tournees.map((t) => DropdownMenuItem<int?>(
                              value: t['id'] as int,
                              child: Text('T${t['numero']} — ${t['vehicule']}'),
                            )),
                          ],
                          onChanged: (val) => setTournee(p['id'] as int, val),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// PLANNING DU JOUR
// ==========================================
class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List facteurs = [];
  List affectations = [];
  bool loading = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      fetchData();
    } else {
      _initialized = true;
    }
  }

  Future<void> fetchData() async {
    final resFacteurs = await http.get(Uri.parse('$apiBase/facteurs'));
    final resAffectations = await http.get(Uri.parse('$apiBase/affectations'));
    setState(() {
      facteurs = jsonDecode(resFacteurs.body);
      affectations = jsonDecode(resAffectations.body);
      loading = false;
    });
  }

  Map? getAffectation(int idFacteur) {
    final aff = affectations.where((a) => a['facteur']['id'] == idFacteur).toList();
    if (aff.isEmpty) return null;
    aff.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
    return aff.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning du jour'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => loading = true);
              fetchData();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: facteurs.length,
              itemBuilder: (context, index) {
                final f = facteurs[index];
                final aff = getAffectation(f['id'] as int);
                
                return _ModernCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: kPrimaryColor.withValues(alpha: 0.2),
                              child: const Icon(Icons.person_rounded, color: Color(0xFFB8960C), size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${f['prenom']} ${f['nom']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  const SizedBox(height: 4),
                                  Text('${f['role']} • ${f['contrat']}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        
                        if (aff != null && aff['tournee'] != null) ...[
                          _InfoRow(icon: Icons.route_rounded, label: 'Tournée', value: 'T${aff['tournee']['numero']} — ${aff['tournee']['vehicule']}'),
                          const SizedBox(height: 10),
                          _InfoRow(icon: Icons.map_rounded, label: 'Rues', value: aff['tournee']['rues']),
                          const SizedBox(height: 10),
                          _InfoRow(icon: Icons.event_rounded, label: 'Depuis', value: aff['dateDebut']),
                        ] else if (aff != null && aff['tournee'] == null) ...[
                          _InfoRow(icon: Icons.event_rounded, label: 'Depuis', value: aff['dateDebut']),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Text('Aucune tournée assignée', style: TextStyle(color: Colors.orange.shade700, fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ] else
                          Row(
                            children: const [
                              Icon(Icons.history_rounded, size: 18, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Aucune affectation', style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic)),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: kTextColor, fontFamily: 'Roboto'),
              children: [
                TextSpan(text: '$label : ', style: const TextStyle(color: Colors.black54)),
                TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// ADMINISTRATION (Dashboard)
// ==========================================
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTextColor, // Header sombre pour le mode admin
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Administration', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Création'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MenuTile(icon: Icons.person_add_rounded, label: 'Nouveau facteur', color: Colors.deepPurple, page: const NouveauFacteurPage()),
                _MenuTile(icon: Icons.add_road_rounded, label: 'Nouvelle tournée', color: Colors.teal, page: const NouvelleTourneePage()),
                _MenuTile(icon: Icons.add_box_rounded, label: 'Nouvelle prestation', color: Colors.orange, page: const NouvellePrestationPage()),
              ],
            ),
            const SizedBox(height: 40),
            const _SectionTitle('Gestion'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MenuTile(icon: Icons.people_alt_rounded, label: 'Gérer Facteurs', color: Colors.deepPurple, page: const GererFacteursPage()),
                _MenuTile(icon: Icons.route_rounded, label: 'Gérer Tournées', color: Colors.teal, page: const GererTourneesPage()),
                _MenuTile(icon: Icons.local_shipping_rounded, label: 'Gérer Prestations', color: Colors.orange, page: const GererPrestationsPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// FORMULAIRES DE CRÉATION
// ==========================================
class NouveauFacteurPage extends StatefulWidget {
  const NouveauFacteurPage({super.key});
  @override
  State<NouveauFacteurPage> createState() => _NouveauFacteurPageState();
}

class _NouveauFacteurPageState extends State<NouveauFacteurPage> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  String selectedContrat = 'CDI';
  String selectedRole = 'TITULAIRE';

  Future<void> creer() async {
    if (nomController.text.isEmpty || prenomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remplis tous les champs')));
      return;
    }
    final response = await http.post(
      Uri.parse('$apiBase/facteurs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nomController.text.toUpperCase(), 'prenom': prenomController.text, 'contrat': selectedContrat, 'role': selectedRole}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Facteur créé !')));
      nomController.clear();
      prenomController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouveau facteur', style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModernTextField(label: 'Nom', controller: nomController, hint: 'DUPONT'),
            const SizedBox(height: 20),
            _ModernTextField(label: 'Prénom', controller: prenomController, hint: 'Jean'),
            const SizedBox(height: 20),
            const _SectionTitle('Contrat', fontSize: 14),
            const SizedBox(height: 8),
            _ModernDropdown<String>(value: selectedContrat, items: const [DropdownMenuItem(value: 'CDI', child: Text('CDI')), DropdownMenuItem(value: 'CDD', child: Text('CDD')), DropdownMenuItem(value: 'INTERIM', child: Text('Intérim'))], onChanged: (val) => setState(() => selectedContrat = val!)),
            const SizedBox(height: 20),
            const _SectionTitle('Rôle', fontSize: 14),
            const SizedBox(height: 8),
            _ModernDropdown<String>(value: selectedRole, items: const [DropdownMenuItem(value: 'TITULAIRE', child: Text('Titulaire')), DropdownMenuItem(value: 'REMPLACANT', child: Text('Remplaçant')), DropdownMenuItem(value: 'ROULEUR', child: Text('Rouleur'))], onChanged: (val) => setState(() => selectedRole = val!)),
            const SizedBox(height: 40),
            _ModernButton(label: 'Créer le facteur', color: Colors.deepPurple, onPressed: creer),
          ],
        ),
      ),
    );
  }
}

class NouvelleTourneePage extends StatefulWidget {
  const NouvelleTourneePage({super.key});
  @override
  State<NouvelleTourneePage> createState() => _NouvelleTourneePageState();
}

class _NouvelleTourneePageState extends State<NouvelleTourneePage> {
  final numeroController = TextEditingController();
  final ruesController = TextEditingController();
  String selectedVehicule = 'VAE';

  Future<void> creer() async {
    if (numeroController.text.isEmpty || ruesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remplis tous les champs')));
      return;
    }
    final response = await http.post(Uri.parse('$apiBase/tournees'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'numero': int.parse(numeroController.text), 'vehicule': selectedVehicule, 'rues': ruesController.text}));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Tournée créée !')));
      numeroController.clear();
      ruesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouvelle tournée', style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModernTextField(label: 'Numéro', controller: numeroController, hint: '3101', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            const _SectionTitle('Véhicule', fontSize: 14),
            const SizedBox(height: 8),
            _ModernDropdown<String>(value: selectedVehicule, items: const [DropdownMenuItem(value: 'VAE', child: Text('VAE')), DropdownMenuItem(value: 'VCAE', child: Text('VCAE')), DropdownMenuItem(value: 'VOITURE', child: Text('Voiture')), DropdownMenuItem(value: 'STABY', child: Text('Staby'))], onChanged: (val) => setState(() => selectedVehicule = val!)),
            const SizedBox(height: 20),
            _ModernTextField(label: 'Rues', controller: ruesController, hint: 'Rue Alfred Herault, Rue du General...', maxLines: 4),
            const SizedBox(height: 40),
            _ModernButton(label: 'Créer la tournée', color: Colors.teal, onPressed: creer),
          ],
        ),
      ),
    );
  }
}

class NouvellePrestationPage extends StatefulWidget {
  const NouvellePrestationPage({super.key});
  @override
  State<NouvellePrestationPage> createState() => _NouvellePrestationPageState();
}

class _NouvellePrestationPageState extends State<NouvellePrestationPage> {
  final adresseController = TextEditingController();
  String selectedType = 'BAL Jaune';
  List tournees = [];
  int? selectedTourneeId;

  @override
  void initState() {
    super.initState();
    fetchTournees();
  }

  Future<void> fetchTournees() async {
    final res = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() => tournees = jsonDecode(res.body));
  }

  Future<void> creer() async {
    if (adresseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remplis l\'adresse')));
      return;
    }
    final body = {'type': selectedType, 'adresse': adresseController.text};
    if (selectedTourneeId != null) body['tournee'] = {'id': selectedTourneeId} as dynamic;
    final response = await http.post(Uri.parse('$apiBase/prestations'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Prestation créée !')));
      adresseController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouvelle prestation', style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Type', fontSize: 14),
            const SizedBox(height: 8),
            _ModernDropdown<String>(value: selectedType, items: const [DropdownMenuItem(value: 'BAL Jaune', child: Text('BAL Jaune')), DropdownMenuItem(value: 'Collecte', child: Text('Collecte')), DropdownMenuItem(value: 'ExpBal', child: Text('ExpBal'))], onChanged: (val) => setState(() => selectedType = val!)),
            const SizedBox(height: 20),
            _ModernTextField(label: 'Adresse', controller: adresseController, hint: '12 Rue des Lilas'),
            const SizedBox(height: 20),
            const _SectionTitle('Tournée (optionnel)', fontSize: 14),
            const SizedBox(height: 8),
            _ModernDropdown<int?>(value: selectedTourneeId, hint: 'Aucune', items: [const DropdownMenuItem<int?>(value: null, child: Text('Aucune', style: TextStyle(color: Colors.grey))), ...tournees.map((t) => DropdownMenuItem<int?>(value: t['id'] as int, child: Text('T${t['numero']} — ${t['vehicule']}')))], onChanged: (val) => setState(() => selectedTourneeId = val)),
            const SizedBox(height: 40),
            _ModernButton(label: 'Créer la prestation', color: Colors.orange, onPressed: creer),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAGES DE GESTION (MODIFICATION/SUPPRESSION)
// ==========================================
class GererFacteursPage extends StatefulWidget {
  const GererFacteursPage({super.key});
  @override
  State<GererFacteursPage> createState() => _GererFacteursPageState();
}

class _GererFacteursPageState extends State<GererFacteursPage> {
  List facteurs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final res = await http.get(Uri.parse('$apiBase/facteurs'));
    setState(() { facteurs = jsonDecode(res.body); loading = false; });
  }

  Future<void> supprimer(int id) async {
    await http.delete(Uri.parse('$apiBase/facteurs/$id'));
    await fetchData();
  }

  void modifier(Map facteur) {
    final nomController = TextEditingController(text: facteur['nom']);
    final prenomController = TextEditingController(text: facteur['prenom']);
    String contrat = facteur['contrat'];
    String role = facteur['role'];
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Modifier le facteur'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: contrat, decoration: const InputDecoration(labelText: 'Contrat'), items: const [DropdownMenuItem(value: 'CDI', child: Text('CDI')), DropdownMenuItem(value: 'CDD', child: Text('CDD')), DropdownMenuItem(value: 'INTERIM', child: Text('Intérim'))], onChanged: (val) => setStateDialog(() => contrat = val!)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: role, decoration: const InputDecoration(labelText: 'Rôle'), items: const [DropdownMenuItem(value: 'TITULAIRE', child: Text('Titulaire')), DropdownMenuItem(value: 'REMPLACANT', child: Text('Remplaçant')), DropdownMenuItem(value: 'ROULEUR', child: Text('Rouleur'))], onChanged: (val) => setStateDialog(() => role = val!)),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                await http.put(Uri.parse('$apiBase/facteurs/${facteur['id']}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'nom': nomController.text.toUpperCase(), 'prenom': prenomController.text, 'contrat': contrat, 'role': role}));
                Navigator.pop(context);
                await fetchData();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les facteurs', style: TextStyle(color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: facteurs.length,
        itemBuilder: (context, index) {
          final f = facteurs[index];
          return _ModernCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person_rounded, color: Colors.deepPurple, size: 24)),
              title: Text('${f['prenom']} ${f['nom']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text('${f['role']} — ${f['contrat']}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.deepPurple), onPressed: () => modifier(f)),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.redAccent), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Supprimer ?'), content: Text('Supprimer ${f['prenom']} ${f['nom']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(f['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class GererTourneesPage extends StatefulWidget {
  const GererTourneesPage({super.key});
  @override
  State<GererTourneesPage> createState() => _GererTourneesPageState();
}

class _GererTourneesPageState extends State<GererTourneesPage> {
  List tournees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final res = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() { tournees = jsonDecode(res.body); loading = false; });
  }

  Future<void> supprimer(int id) async {
    await http.delete(Uri.parse('$apiBase/tournees/$id'));
    await fetchData();
  }

  void modifier(Map tournee) {
    final numeroController = TextEditingController(text: '${tournee['numero']}');
    final ruesController = TextEditingController(text: tournee['rues']);
    String vehicule = tournee['vehicule'];
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Modifier la tournée'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: numeroController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Numéro')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: vehicule, decoration: const InputDecoration(labelText: 'Véhicule'), items: const [DropdownMenuItem(value: 'VAE', child: Text('VAE')), DropdownMenuItem(value: 'VCAE', child: Text('VCAE')), DropdownMenuItem(value: 'VOITURE', child: Text('Voiture')), DropdownMenuItem(value: 'STABY', child: Text('Staby'))], onChanged: (val) => setStateDialog(() => vehicule = val!)),
            const SizedBox(height: 12),
            TextField(controller: ruesController, maxLines: 3, decoration: const InputDecoration(labelText: 'Rues')),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                await http.put(Uri.parse('$apiBase/tournees/${tournee['id']}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'numero': int.parse(numeroController.text), 'vehicule': vehicule, 'rues': ruesController.text}));
                Navigator.pop(context);
                await fetchData();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les tournées', style: TextStyle(color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tournees.length,
        itemBuilder: (context, index) {
          final t = tournees[index];
          return _ModernCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.route_rounded, color: Colors.teal, size: 24)),
              title: Text('T${t['numero']} — ${t['vehicule']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(t['rues'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.teal), onPressed: () => modifier(t)),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.redAccent), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Supprimer ?'), content: Text('Supprimer la tournée T${t['numero']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(t['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class GererPrestationsPage extends StatefulWidget {
  const GererPrestationsPage({super.key});
  @override
  State<GererPrestationsPage> createState() => _GererPrestationsPageState();
}

class _GererPrestationsPageState extends State<GererPrestationsPage> {
  List prestations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final res = await http.get(Uri.parse('$apiBase/prestations'));
    setState(() { prestations = jsonDecode(res.body); loading = false; });
  }

  Future<void> supprimer(int id) async {
    await http.delete(Uri.parse('$apiBase/prestations/$id'));
    await fetchData();
  }

  void modifier(Map prestation) {
    final adresseController = TextEditingController(text: prestation['adresse']);
    String type = prestation['type'];
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Modifier la prestation'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: 'Type'), items: const [DropdownMenuItem(value: 'BAL Jaune', child: Text('BAL Jaune')), DropdownMenuItem(value: 'Collecte', child: Text('Collecte')), DropdownMenuItem(value: 'ExpBal', child: Text('ExpBal'))], onChanged: (val) => setStateDialog(() => type = val!)),
            const SizedBox(height: 12),
            TextField(controller: adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                await http.put(Uri.parse('$apiBase/prestations/${prestation['id']}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'type': type, 'adresse': adresseController.text}));
                Navigator.pop(context);
                await fetchData();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kTextColor, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les prestations', style: TextStyle(color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: prestations.length,
        itemBuilder: (context, index) {
          final p = prestations[index];
          return _ModernCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_shipping_rounded, color: Colors.orange, size: 24)),
              title: Text(p['type'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.black54)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.orange), onPressed: () => modifier(p)),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.redAccent), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Supprimer ?'), content: Text('Supprimer ${p['type']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(p['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// WIDGETS REUTILISABLES (Design System)
// ==========================================

class _ModernCard extends StatelessWidget {
  final Widget child;
  const _ModernCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const _SectionTitle(this.title, {this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, color: Colors.grey.shade700),
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const _ModernTextField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(label, fontSize: 14),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }
}

class _ModernDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const _ModernDropdown({required this.value, required this.items, required this.onChanged, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: hint != null ? Text(hint!) : null,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class _ModernButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ModernButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Package pour faire des requêtes HTTP vers l'API
import 'dart:convert'; // Pour encoder/décoder le JSON

// Adresse de base de l'API Spring Boot — à modifier à chaque changement de réseau
const String apiBase = 'http://192.168.1.14:8080'; // A MODIFIER A CHAQUE FOIS

void main() {
  runApp(const MyApp()); // Point d'entrée de l'application Flutter
}

// Widget racine de l'application — configure le thème global
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion La Poste',
      debugShowCheckedModeBanner: false, // Masque le bandeau "debug" en haut à droite
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFD700)), // Thème jaune La Poste
        useMaterial3: true, // Utilise la dernière version du design Material
        cardTheme: CardThemeData(
          elevation: 0, // Pas d'ombre sur les cartes
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200), // Bordure grise légère
          ),
        ),
      ),
      home: const HomePage(), // Page affichée au démarrage
    );
  }
}

// Page d'accueil avec les 3 tuiles principales et les 2 boutons flottants
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Fond gris très clair
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700), // Barre jaune La Poste
        elevation: 0,
        title: const Text('Gestion La Poste', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [
          // Logo "La Poste" affiché à droite de la barre
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
      // Deux boutons flottants empilés verticalement en bas à droite
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Bouton Admin (petit, noir) → ouvre la page d'administration
          FloatingActionButton.small(
            heroTag: 'admin', // Tag unique pour éviter les conflits d'animation
            backgroundColor: Colors.black87,
            child: const Text('A', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage())),
          ),
          const SizedBox(height: 12),
          // Bouton Demande client (cyan) → ouvre la liste des prestations
          Tooltip(
            message: 'Demande client', // Texte affiché au survol
            child: FloatingActionButton(
              heroTag: 'demande',
              backgroundColor: Colors.cyan,
              child: const Text('!', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrestationsPage())),
            ),
          ),
        ],
      ),
      // Corps de la page : 3 tuiles centrées
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Wrap(
            spacing: 24, // Espacement horizontal entre les tuiles
            runSpacing: 24, // Espacement vertical si les tuiles passent à la ligne
            alignment: WrapAlignment.center,
            children: [
              _MenuTile(icon: Icons.calendar_today, label: 'Planning du jour', color: const Color(0xFFFFD700), page: const PlanningPage()),
              _MenuTile(icon: Icons.swap_horiz, label: 'Affecter Tournée', color: const Color(0xFF4CAF50), page: const AffecterFacteurPage()),
              _MenuTile(icon: Icons.local_shipping, label: 'Affecter Prestation', color: const Color(0xFF2196F3), page: const AffecterTourneePage()),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget réutilisable représentant une tuile de menu cliquable
class _MenuTile extends StatelessWidget {
  final String label;   // Texte affiché sous l'icône
  final Widget page;    // Page vers laquelle naviguer au clic
  final IconData icon;  // Icône affichée dans la tuile
  final Color color;    // Couleur de l'icône et du fond coloré
  const _MenuTile({required this.label, required this.page, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)), // Navigation vers la page
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
            // Cercle coloré contenant l'icône
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15), // Couleur transparente à 15%
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

// Page "Demande client" : liste toutes les prestations avec leur tournée associée
class PrestationsPage extends StatefulWidget {
  const PrestationsPage({super.key});

  @override
  State<PrestationsPage> createState() => _PrestationsPageState();
}

class _PrestationsPageState extends State<PrestationsPage> {
  List prestations = []; // Liste des prestations récupérées depuis l'API
  bool loading = true;   // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    fetchPrestations(); // Chargement des données au démarrage de la page
  }

  // Appel API GET /prestations → récupère toutes les prestations
  Future<void> fetchPrestations() async {
    final response = await http.get(Uri.parse('$apiBase/prestations'));
    if (response.statusCode == 200) {
      setState(() {
        prestations = jsonDecode(response.body); // Décode le JSON en liste Dart
        loading = false;
      });
    }
  }

  // Retourne l'icône correspondant au type de prestation
  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'collecte': return Icons.inbox;
      case 'expbal': return Icons.send;
      default: return Icons.mail_outline;
    }
  }

  // Retourne la couleur correspondant au type de prestation
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
          ? const Center(child: CircularProgressIndicator()) // Spinner pendant le chargement
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
                        color: color.withValues(alpha: 0.15),
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
                    // Badge vert si la prestation a une tournée, gris sinon
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

// Page "Affecter Tournée" : permet d'affecter un facteur à une tournée pour une date donnée
class AffecterFacteurPage extends StatefulWidget {
  const AffecterFacteurPage({super.key});

  @override
  State<AffecterFacteurPage> createState() => _AffecterFacteurPageState();
}

class _AffecterFacteurPageState extends State<AffecterFacteurPage> {
  List facteurs = [];          // Liste des facteurs disponibles
  List tournees = [];          // Liste des tournées disponibles
  bool loading = true;
  int? selectedFacteurId;      // ID du facteur sélectionné dans le dropdown
  int? selectedTourneeId;      // ID de la tournée sélectionnée dans le dropdown
  DateTime selectedDate = DateTime.now(); // Date de début de l'affectation

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Récupère facteurs et tournées en parallèle depuis l'API
  Future<void> fetchData() async {
    final resFacteurs = await http.get(Uri.parse('$apiBase/facteurs'));
    final resTournees = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() {
      facteurs = jsonDecode(resFacteurs.body);
      tournees = jsonDecode(resTournees.body);
      loading = false;
    });
  }

  // Envoie une affectation via POST /affectations/simple
  Future<void> affecter() async {
    if (selectedFacteurId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionne un facteur')),
      );
      return;
    }
    final response = await http.post(
      Uri.parse('$apiBase/affectations/simple'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idFacteur': selectedFacteurId,
        'idTournee': selectedTourneeId,
        'dateDebut': selectedDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
        'roleAffectation': 'TITULAIRE', // Rôle par défaut
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Affectation enregistrée !')),
      );
      // Réinitialise les sélections après affectation réussie
      setState(() {
        selectedFacteurId = null;
        selectedTourneeId = null;
        selectedDate = DateTime.now();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Erreur lors de l\'affectation')),
      );
    }
  }

  // Ouvre le sélecteur de date natif Flutter
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text('Affecter Tournée', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Facteur', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  // Dropdown listant tous les facteurs
                  DropdownButtonFormField<int?>(
                    initialValue: selectedFacteurId,
                    hint: const Text('Choisir un facteur'),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                    items: facteurs.map((f) => DropdownMenuItem<int?>(
                      value: f['id'] as int,
                      child: Text('${f['prenom']} ${f['nom']} — ${f['role']}'),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedFacteurId = val),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tournée', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  // Dropdown listant toutes les tournées
                  DropdownButtonFormField<int?>(
                    initialValue: selectedTourneeId,
                    hint: const Text('Choisir une tournée'),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('Aucune tournée', style: TextStyle(color: Colors.grey))),
                      ...tournees.map((t) => DropdownMenuItem<int?>(
                        value: t['id'] as int,
                        child: Text('T${t['numero']} — ${t['vehicule']}'),
                      )),
                    ],
                    onChanged: (val) => setState(() => selectedTourneeId = val),
                  ),
                  const SizedBox(height: 20),
                  const Text('Date de début', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  // Bouton d'ouverture du calendrier
                  InkWell(
                    onTap: pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton de validation de l'affectation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: affecter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Affecter', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Page "Affecter Prestation" : permet d'associer une prestation à une tournée via un dropdown
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

  // Envoie un PUT /prestations/{id}/tournee pour modifier la tournée d'une prestation
  Future<void> setTournee(int idPrestation, int? idTournee) async {
    await http.put(
      Uri.parse('$apiBase/prestations/$idPrestation/tournee'),
      headers: {'Content-Type': 'application/json'},
      body: idTournee == null ? 'null' : '$idTournee', // null si on enlève la tournée
    );
    await fetchData(); // Rafraîchit la liste après modification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text('Affecter Prestation', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prestations.length,
              itemBuilder: (context, index) {
                final p = prestations[index];
                final int? currentTourneeId = p['tournee']?['id']; // ID de la tournée actuelle (peut être null)
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['type'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Dropdown pré-sélectionné sur la tournée actuelle de la prestation
                      DropdownButtonFormField<int?>(
                        initialValue: currentTourneeId,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                        ),
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
                );
              },
            ),
    );
  }
}

// Page "Planning du jour" : affiche pour chaque facteur sa tournée et ses infos d'affectation
// Se rafraîchit automatiquement à chaque retour sur la page via didChangeDependencies
class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List facteurs = [];
  List affectations = [];
  bool loading = true;
  bool _initialized = false; // Evite un double chargement au premier affichage

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // didChangeDependencies est appelé à chaque fois que la page redevient visible
  // Permet de rafraîchir automatiquement les données au retour depuis une autre page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      // Rechargement uniquement si la page a déjà été initialisée une fois
      fetchData();
    } else {
      _initialized = true;
    }
  }

  // Récupère facteurs et affectations depuis l'API
  Future<void> fetchData() async {
    final resFacteurs = await http.get(Uri.parse('$apiBase/facteurs'));
    final resAffectations = await http.get(Uri.parse('$apiBase/affectations'));
    setState(() {
      facteurs = jsonDecode(resFacteurs.body);
      affectations = jsonDecode(resAffectations.body);
      loading = false;
    });
  }

  // Retourne l'affectation la plus récente d'un facteur (par ID — le plus grand = le plus récent)
  Map? getAffectation(int idFacteur) {
    final aff = affectations.where((a) => a['facteur']['id'] == idFacteur).toList();
    if (aff.isEmpty) return null;
    aff.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int)); // Trie par ID décroissant
    return aff.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text('Planning du jour', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          // Bouton de rafraîchissement manuel
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              setState(() { loading = true; });
              fetchData();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: facteurs.length,
              itemBuilder: (context, index) {
                final f = facteurs[index];
                final aff = getAffectation(f['id'] as int); // Récupère l'affectation du facteur
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête : avatar + nom/rôle du facteur
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.person, color: Color(0xFFB8960C), size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${f['prenom']} ${f['nom']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                              Text('${f['role']} — ${f['contrat']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      
                      // --- LA CORRECTION EST ICI : Gestion sécurisée de l'affichage ---
                      if (aff != null && aff['tournee'] != null) ...[
                        // CAS 1 : Affectation AVEC tournée
                        _InfoRow(icon: Icons.route, label: 'Tournée', value: 'T${aff['tournee']['numero']} — ${aff['tournee']['vehicule']}'),
                        const SizedBox(height: 6),
                        _InfoRow(icon: Icons.location_on_outlined, label: 'Rues', value: aff['tournee']['rues']),
                        const SizedBox(height: 6),
                        _InfoRow(icon: Icons.calendar_today, label: 'Depuis', value: aff['dateDebut']),
                      ] else if (aff != null && aff['tournee'] == null) ...[
                        // CAS 2 : Affectation SANS tournée ("Aucune tournée")
                        _InfoRow(icon: Icons.calendar_today, label: 'Depuis', value: aff['dateDebut']),
                        const SizedBox(height: 6),
                        const Text('Aucune tournée assignée', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w600)),
                      ] else
                        // CAS 3 : Aucune affectation du tout
                        const Text('Aucune affectation', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      // -----------------------------------------------------------------
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// Widget réutilisable pour afficher une ligne icône + label + valeur dans le planning
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
        Icon(icon, size: 15, color: Colors.grey),
        const SizedBox(width: 6),
        Text('$label : ', style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      ],
    );
  }
}

// Page Administration : deux sections — Créer et Gérer
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.black87, // Barre noire pour distinguer la zone admin
        elevation: 0,
        title: const Text('Administration', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Créer : formulaires de création
            const Text('Créer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MenuTile(icon: Icons.person_add, label: 'Nouveau facteur', color: Colors.deepPurple, page: const NouveauFacteurPage()),
                _MenuTile(icon: Icons.add_road, label: 'Nouvelle tournée', color: Colors.teal, page: const NouvelleTourneePage()),
                _MenuTile(icon: Icons.add_box, label: 'Nouvelle prestation', color: Colors.orange, page: const NouvellePrestationPage()),
              ],
            ),
            const SizedBox(height: 32),
            // Section Gérer : listes avec modification et suppression
            const Text('Gérer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MenuTile(icon: Icons.people, label: 'Facteurs', color: Colors.deepPurple, page: const GererFacteursPage()),
                _MenuTile(icon: Icons.route, label: 'Tournées', color: Colors.teal, page: const GererTourneesPage()),
                _MenuTile(icon: Icons.local_shipping, label: 'Prestations', color: Colors.orange, page: const GererPrestationsPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Page de création d'un nouveau facteur avec formulaire
class NouveauFacteurPage extends StatefulWidget {
  const NouveauFacteurPage({super.key});

  @override
  State<NouveauFacteurPage> createState() => _NouveauFacteurPageState();
}

class _NouveauFacteurPageState extends State<NouveauFacteurPage> {
  final nomController = TextEditingController();     // Contrôleur du champ Nom
  final prenomController = TextEditingController(); // Contrôleur du champ Prénom
  String selectedContrat = 'CDI';   // Valeur par défaut du dropdown Contrat
  String selectedRole = 'TITULAIRE'; // Valeur par défaut du dropdown Rôle

  // Envoie un POST /facteurs avec les données du formulaire
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouveau facteur', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nom', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(controller: nomController, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), hintText: 'DUPONT')),
          const SizedBox(height: 20),
          const Text('Prénom', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(controller: prenomController, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), hintText: 'Jean')),
          const SizedBox(height: 20),
          const Text('Contrat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(initialValue: selectedContrat, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))), items: const [DropdownMenuItem(value: 'CDI', child: Text('CDI')), DropdownMenuItem(value: 'CDD', child: Text('CDD')), DropdownMenuItem(value: 'INTERIM', child: Text('Intérim'))], onChanged: (val) => setState(() => selectedContrat = val!)),
          const SizedBox(height: 20),
          const Text('Rôle', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(initialValue: selectedRole, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))), items: const [DropdownMenuItem(value: 'TITULAIRE', child: Text('Titulaire')), DropdownMenuItem(value: 'REMPLACANT', child: Text('Remplaçant')), DropdownMenuItem(value: 'ROULEUR', child: Text('Rouleur'))], onChanged: (val) => setState(() => selectedRole = val!)),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: creer, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0), child: const Text('Créer le facteur', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))),
        ]),
      ),
    );
  }
}

// Page de création d'une nouvelle tournée
class NouvelleTourneePage extends StatefulWidget {
  const NouvelleTourneePage({super.key});

  @override
  State<NouvelleTourneePage> createState() => _NouvelleTourneePageState();
}

class _NouvelleTourneePageState extends State<NouvelleTourneePage> {
  final numeroController = TextEditingController(); // Numéro de tournée
  final ruesController = TextEditingController();   // Liste des rues
  String selectedVehicule = 'VAE'; // Véhicule par défaut

  // Envoie un POST /tournees avec les données du formulaire
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouvelle tournée', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Numéro', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(controller: numeroController, keyboardType: TextInputType.number, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), hintText: '3101')),
          const SizedBox(height: 20),
          const Text('Véhicule', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(initialValue: selectedVehicule, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))), items: const [DropdownMenuItem(value: 'VAE', child: Text('VAE')), DropdownMenuItem(value: 'VCAE', child: Text('VCAE')), DropdownMenuItem(value: 'VOITURE', child: Text('Voiture')), DropdownMenuItem(value: 'STABY', child: Text('Staby'))], onChanged: (val) => setState(() => selectedVehicule = val!)),
          const SizedBox(height: 20),
          const Text('Rues', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(controller: ruesController, maxLines: 4, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), hintText: 'Rue Alfred Herault, Rue du General Reibel...')),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: creer, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0), child: const Text('Créer la tournée', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))),
        ]),
      ),
    );
  }
}

// Page de création d'une nouvelle prestation
class NouvellePrestationPage extends StatefulWidget {
  const NouvellePrestationPage({super.key});

  @override
  State<NouvellePrestationPage> createState() => _NouvellePrestationPageState();
}

class _NouvellePrestationPageState extends State<NouvellePrestationPage> {
  final adresseController = TextEditingController();
  String selectedType = 'BAL Jaune'; // Type par défaut
  List tournees = [];
  int? selectedTourneeId; // Tournée optionnelle

  @override
  void initState() {
    super.initState();
    fetchTournees();
  }

  Future<void> fetchTournees() async {
    final res = await http.get(Uri.parse('$apiBase/tournees'));
    setState(() => tournees = jsonDecode(res.body));
  }

  // Envoie un POST /prestations — la tournée est optionnelle
  Future<void> creer() async {
    if (adresseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remplis l\'adresse')));
      return;
    }
    final body = {'type': selectedType, 'adresse': adresseController.text};
    if (selectedTourneeId != null) body['tournee'] = {'id': selectedTourneeId} as dynamic; // Ajoute la tournée si sélectionnée
    final response = await http.post(Uri.parse('$apiBase/prestations'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Prestation créée !')));
      adresseController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Nouvelle prestation', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(initialValue: selectedType, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))), items: const [DropdownMenuItem(value: 'BAL Jaune', child: Text('BAL Jaune')), DropdownMenuItem(value: 'Collecte', child: Text('Collecte')), DropdownMenuItem(value: 'ExpBal', child: Text('ExpBal'))], onChanged: (val) => setState(() => selectedType = val!)),
          const SizedBox(height: 20),
          const Text('Adresse', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(controller: adresseController, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), hintText: '12 Rue des Lilas')),
          const SizedBox(height: 20),
          const Text('Tournée (optionnel)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int?>(initialValue: selectedTourneeId, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))), items: [const DropdownMenuItem<int?>(value: null, child: Text('Aucune', style: TextStyle(color: Colors.grey))), ...tournees.map((t) => DropdownMenuItem<int?>(value: t['id'] as int, child: Text('T${t['numero']} — ${t['vehicule']}')))], onChanged: (val) => setState(() => selectedTourneeId = val)),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: creer, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0), child: const Text('Créer la prestation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))),
        ]),
      ),
    );
  }
}

// Page de gestion des facteurs : liste avec boutons modifier et supprimer
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

  // Envoie un DELETE /facteurs/{id} puis rafraîchit la liste
  Future<void> supprimer(int id) async {
    await http.delete(Uri.parse('$apiBase/facteurs/$id'));
    await fetchData();
  }

  // Ouvre une boîte de dialogue avec un formulaire pré-rempli pour modifier un facteur
  void modifier(Map facteur) {
    final nomController = TextEditingController(text: facteur['nom']);
    final prenomController = TextEditingController(text: facteur['prenom']);
    String contrat = facteur['contrat'];
    String role = facteur['role'];
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder( // StatefulBuilder permet de rafraîchir uniquement la dialog
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Modifier le facteur'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(initialValue: contrat, decoration: const InputDecoration(labelText: 'Contrat'), items: const [DropdownMenuItem(value: 'CDI', child: Text('CDI')), DropdownMenuItem(value: 'CDD', child: Text('CDD')), DropdownMenuItem(value: 'INTERIM', child: Text('Intérim'))], onChanged: (val) => setStateDialog(() => contrat = val!)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(initialValue: role, decoration: const InputDecoration(labelText: 'Rôle'), items: const [DropdownMenuItem(value: 'TITULAIRE', child: Text('Titulaire')), DropdownMenuItem(value: 'REMPLACANT', child: Text('Remplaçant')), DropdownMenuItem(value: 'ROULEUR', child: Text('Rouleur'))], onChanged: (val) => setStateDialog(() => role = val!)),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              onPressed: () async {
                // Envoie un PUT /facteurs/{id} avec les nouvelles valeurs
                await http.put(Uri.parse('$apiBase/facteurs/${facteur['id']}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'nom': nomController.text.toUpperCase(), 'prenom': prenomController.text, 'contrat': contrat, 'role': role}));
                Navigator.pop(context);
                await fetchData(); // Rafraîchit la liste après modification
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les facteurs', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: facteurs.length,
        itemBuilder: (context, index) {
          final f = facteurs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person, color: Colors.deepPurple, size: 22)),
              title: Text('${f['prenom']} ${f['nom']}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${f['role']} — ${f['contrat']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.deepPurple), onPressed: () => modifier(f)),
                // Bouton supprimer avec confirmation via AlertDialog
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Supprimer ?'), content: Text('Supprimer ${f['prenom']} ${f['nom']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(f['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// Page de gestion des tournées : liste avec modifier et supprimer (même logique que GererFacteursPage)
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
          title: const Text('Modifier la tournée'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: numeroController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Numéro')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(initialValue: vehicule, decoration: const InputDecoration(labelText: 'Véhicule'), items: const [DropdownMenuItem(value: 'VAE', child: Text('VAE')), DropdownMenuItem(value: 'VCAE', child: Text('VCAE')), DropdownMenuItem(value: 'VOITURE', child: Text('Voiture')), DropdownMenuItem(value: 'STABY', child: Text('Staby'))], onChanged: (val) => setStateDialog(() => vehicule = val!)),
            const SizedBox(height: 12),
            TextField(controller: ruesController, maxLines: 3, decoration: const InputDecoration(labelText: 'Rues')),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les tournées', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournees.length,
        itemBuilder: (context, index) {
          final t = tournees[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.route, color: Colors.teal, size: 22)),
              title: Text('T${t['numero']} — ${t['vehicule']}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(t['rues'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.teal), onPressed: () => modifier(t)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Supprimer ?'), content: Text('Supprimer la tournée T${t['numero']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(t['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// Page de gestion des prestations : liste avec modifier et supprimer (même logique)
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
          title: const Text('Modifier la prestation'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(initialValue: type, decoration: const InputDecoration(labelText: 'Type'), items: const [DropdownMenuItem(value: 'BAL Jaune', child: Text('BAL Jaune')), DropdownMenuItem(value: 'Collecte', child: Text('Collecte')), DropdownMenuItem(value: 'ExpBal', child: Text('ExpBal'))], onChanged: (val) => setStateDialog(() => type = val!)),
            const SizedBox(height: 12),
            TextField(controller: adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: Colors.black87, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Gérer les prestations', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prestations.length,
        itemBuilder: (context, index) {
          final p = prestations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.local_shipping, color: Colors.orange, size: 22)),
              title: Text(p['type'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(p['adresse'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => modifier(p)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Supprimer ?'), content: Text('Supprimer ${p['type']} ?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); supprimer(p['id'] as int); }, child: const Text('Supprimer'))]))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// Page vide utilisée comme placeholder pour les pages non encore développées
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(backgroundColor: const Color(0xFFFFD700), elevation: 0, title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
      body: const SizedBox(),
    );
  }
}
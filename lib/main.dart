
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const VxKitApp());
}

class VxKitApp extends StatelessWidget {
  const VxKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VxKit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: Colors.blueAccent,
        fontFamily: 'SF Pro Display', // Utilise la police système par défaut
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- Modèles de données ---
class PentestTool {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Map<String, String> installCommands;
  final List<ToolUsageExample> usages;

  const PentestTool({
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.installCommands,
    required this.usages,
  });
}

class ToolUsageExample {
  final String title;
  final String command;
  final String explanation;

  const ToolUsageExample({
    required this.title,
    required this.command,
    required this.explanation,
  });
}

class UpdateRelease {
  final String version;
  final String date;
  final List<String> changes;

  const UpdateRelease({
    required this.version,
    required this.date,
    required this.changes,
  });
}

// --- Navigation Principale ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ToolsPage(),
    const CommandsQuickPage(),
    const UpdatesPage(),
    const VxAboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[700],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Outils'),
            BottomNavigationBarItem(icon: Icon(Icons.terminal_rounded), label: 'Flash'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Logs'),
            BottomNavigationBarItem(icon: Icon(Icons.shield_rounded), label: 'VxKit'),
          ],
        ),
      ),
    );
  }
}

// --- Page 1: Grille des outils (Nouveau Design) ---
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Réseau", "icon": Icons.lan_rounded, "color": Colors.blue},
    {"name": "Web", "icon": Icons.public_rounded, "color": Colors.green},
    {"name": "Passwords", "icon": Icons.key_rounded, "color": Colors.orange},
    {"name": "Wifi", "icon": Icons.wifi_rounded, "color": Colors.purple},
    {"name": "Reversing", "icon": Icons.memory_rounded, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "VXKIT",
            style: TextStyle(letterSpacing: 6, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 22),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "INFRASTRUCTURE",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.blueAccent, letterSpacing: 2),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return _buildCategoryCard(cat);
                },
              ),
            ],
          ),
        ),
      );
    }

    final filteredTools = _ToolsData.tools.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => setState(() => _selectedCategory = null),
        ),
        title: Text(_selectedCategory!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredTools.length,
        itemBuilder: (context, index) {
          final tool = filteredTools[index];
          return _buildToolTile(tool);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    return InkWell(
      onTap: () => setState(() => _selectedCategory = cat["name"]),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.06),
              Colors.white.withOpacity(0.01),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat["icon"], size: 36, color: cat["color"]),
            const SizedBox(height: 12),
            Text(cat["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTile(PentestTool tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
          child: Icon(tool.icon, color: Colors.white, size: 24),
        ),
        title: Text(tool.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(tool.description, style: TextStyle(color: Colors.grey[500], fontSize: 12, height: 1.3)),
        ),
        onTap: () => _showToolDetails(context, tool),
      ),
    );
  }

  void _showToolDetails(BuildContext context, PentestTool tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ToolDetailSheet(tool: tool),
    );
  }
}

// --- Feuille de détails (Modernisée) ---
class _ToolDetailSheet extends StatelessWidget {
  final PentestTool tool;
  const _ToolDetailSheet({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(tool.icon, color: Colors.blueAccent, size: 32),
                const SizedBox(width: 16),
                Text(tool.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.blueAccent,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                    tabs: [Tab(text: "INSTALL"), Tab(text: "COMMANDS")],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildInstallTab(context),
                        _buildUsageTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: tool.installCommands.entries.map((e) => _buildCodeSection(context, e.key, e.value)).toList(),
    );
  }

  Widget _buildUsageTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tool.usages.length,
      itemBuilder: (context, i) {
        final u = tool.usages[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(u.title, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(u.explanation, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            _buildCodeSection(context, "", u.command, showLabel: false),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildCodeSection(BuildContext context, String label, String code, {bool showLabel = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 10),
          child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(code, style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 13)),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white30),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copié !")));
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

// --- Page 2: Flash Commands ---
class CommandsQuickPage extends StatelessWidget {
  const CommandsQuickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FLASH COMMANDS", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildQuickCard(context, "IP Publique", "curl ifconfig.me", Icons.public),
          _buildQuickCard(context, "Nettoyer Traces", "history -c && rm -rf ~/.bash_history", Icons.delete_sweep),
          _buildQuickCard(context, "Ports Ouverts", "netstat -tuln", Icons.settings_ethernet),
          _buildQuickCard(context, "Processus Root", "ps aux | grep root", Icons.admin_panel_settings),
        ],
      ),
    );
  }

  Widget _buildQuickCard(BuildContext context, String title, String cmd, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(cmd, style: const TextStyle(fontFamily: 'monospace', color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Colors.white24),
            onPressed: () => Clipboard.setData(ClipboardData(text: cmd)),
          ),
        ],
      ),
    );
  }
}

// --- Page 3: Updates ---
class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  static const List<UpdateRelease> updates = [
    UpdateRelease(
      version: "v0.0.2",
      date: "17 Mai 2026",
      changes: [
        "Nouveau design Cyber-Dark Premium.",
        "Redirection directe vers le Telegram officiel.",
        "Ajout de la bibliothèque d'outils complète.",
      ],
    ),
    UpdateRelease(
      version: "v0.0.1",
      date: "16 Mai 2026",
      changes: ["Lancement initial.", "Bypass Xcode pour Codemagic."],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CHANGELOGS", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: updates.length,
        itemBuilder: (context, i) {
          final up = updates[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(up.version, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
                    Text(up.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                ...up.changes.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.chevron_right, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Expanded(child: Text(c, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Page 4: About & Telegram (Bouton Bleu Officiel) ---
class VxAboutPage extends StatelessWidget {
  const VxAboutPage({super.key});

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/vxshare5');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible de lancer $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.5),
            radius: 1.0,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text("VXKIT", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 8)),
            const Text("PENTEST SUITE FOR MOBILE", style: TextStyle(color: Colors.grey, letterSpacing: 2, fontSize: 10)),
            const SizedBox(height: 60),
            _buildInfoRow("DEVELOPER", "HX"),
            _buildInfoRow("VERSION", "0.0.2"),
            _buildInfoRow("STATUS", "STABLE"),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _launchTelegram,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A5E4), // Couleur officielle Telegram
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.telegram, size: 28),
                    SizedBox(width: 12),
                    Text("REJOINDRE TELEGRAM", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Clipboard.setData(const ClipboardData(text: "https://t.me/vxshare5")),
              child: const Text("Copier le lien", style: TextStyle(color: Colors.white24, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// --- Données des outils ---
class _ToolsData {
  static const List<PentestTool> tools = [
    PentestTool(
      name: "Nmap",
      category: "Réseau",
      description: "Scanner de ports et services réseau.",
      icon: Icons.radar,
      installCommands: {"Termux": "pkg install nmap", "iSH": "apk add nmap"},
      usages: [
        ToolUsageExample(title: "Scan Standard", command: "nmap target.com", explanation: "Scan des 1000 ports par défaut."),
      ],
    ),
    // Ajoutez vos 32 outils ici sur le même modèle...
  ];
}


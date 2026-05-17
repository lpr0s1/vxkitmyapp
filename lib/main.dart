
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

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
        primaryColor: const Color(0xFF26A5E4),
        fontFamily: 'SF Pro Display',
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
    const TerminalSimPage(), // Remplacement par le Simulateur de Terminal
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
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF26A5E4),
          unselectedItemColor: Colors.white24,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
          unselectedLabelStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_sharp), label: 'BINAIRES'),
            BottomNavigationBarItem(icon: Icon(Icons.terminal_sharp), label: 'SHELL'),
            BottomNavigationBarItem(icon: Icon(Icons.update_sharp), label: 'LOGS'),
            BottomNavigationBarItem(icon: Icon(Icons.shield_sharp), label: 'SYS'),
          ],
        ),
      ),
    );
  }
}

// --- Page 1: Grille des outils (Design Industriel / Noir & Blanc / Bleu) ---
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Réseau", "icon": Icons.lan_sharp, "count": 5},
    {"name": "Web", "icon": Icons.public_sharp, "count": 3},
    {"name": "Passwords", "icon": Icons.key_sharp, "count": 2},
    {"name": "...", "icon": Icons.wifi_sharp, "count": 0},
    {"name": "Reversing", "icon": Icons.memory_sharp, "count": 1},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "VXKIT",
            style: TextStyle(letterSpacing: 8, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Outils de pentest",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF26A5E4), letterSpacing: 2),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
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
          icon: const Icon(Icons.arrow_back_ios_new_sharp, size: 18),
          onPressed: () => setState(() => _selectedCategory = null),
        ),
        title: Text(_selectedCategory!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 16)),
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat["icon"], size: 32, color: Colors.white70),
            const SizedBox(height: 16),
            Text(cat["name"].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
            const SizedBox(height: 4),
            Text("${cat["count"]} Outils", style: const TextStyle(color: Color(0xFF26A5E4), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTile(PentestTool tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF111111), 
            border: Border.all(color: Colors.white.withOpacity(0.05))
          ),
          child: Icon(tool.icon, color: Colors.white, size: 20),
        ),
        title: Text(tool.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(tool.description, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4, fontFamily: 'monospace')),
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

// --- Feuille de détails des outils ---
class _ToolDetailSheet extends StatelessWidget {
  final PentestTool tool;
  const _ToolDetailSheet({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 2, color: Colors.white24),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(tool.icon, color: const Color(0xFF26A5E4), size: 28),
                const SizedBox(width: 16),
                Text(tool.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Color(0xFF26A5E4),
                    indicatorWeight: 2,
                    labelStyle: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11),
                    tabs: [Tab(text: "DÉPLOIEMENT"), Tab(text: "EXÉCUTION")],
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
            Text(u.title.toUpperCase(), style: const TextStyle(color: Color(0xFF26A5E4), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(u.explanation, style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace')),
            _buildCodeSection(context, "", u.command, showLabel: false),
            const SizedBox(height: 24),
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
          child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 2)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(code, style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF00FF41), fontSize: 12)),
              ),
              IconButton(
                icon: const Icon(Icons.copy_sharp, size: 16, color: Colors.white30),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("PAYLOAD COPIÉ", style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    backgroundColor: Color(0xFF26A5E4),
                    duration: Duration(seconds: 1),
                  ));
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

// --- Page 2: Simulateur de Terminal (Nouveau) ---
class TerminalSimPage extends StatefulWidget {
  const TerminalSimPage({super.key});

  @override
  State<TerminalSimPage> createState() => _TerminalSimPageState();
}

class _TerminalSimPageState extends State<TerminalSimPage> {
  final TextEditingController _cmdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  final List<Map<String, String>> _history = [
    {"text": "VXKIT OS v1.0.0-STABLE READY.", "type": "sys"},
    {"text": "Tapez 'help' pour voir les commandes disponibles.", "type": "sys"},
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleCommand(String input) async {
    final cmd = input.trim();
    if (cmd.isEmpty) return;

    setState(() {
      _history.add({"text": "root@vxkit:~# $cmd", "type": "input"});
      _cmdController.clear();
    });
    _scrollToBottom();
    _focusNode.requestFocus(); // Garde le clavier ouvert

    // Délai pour simuler le traitement
    await Future.delayed(const Duration(milliseconds: 300));

    String response;
    String type = "output";

    switch (cmd.toLowerCase()) {
      case 'help':
        response = "Commandes actives:\n  ls       - Liste les répertoires\n  clear    - Nettoie le terminal\n  whoami   - Affiche l'utilisateur\n  nmap     - Simule un scan réseau\n  exploit  - Simule une attaque";
        type = "sys";
        break;
      case 'ls':
        response = "bin/  etc/  tools/  payloads/  logs/  vx_scripts/";
        type = "sys";
        break;
      case 'clear':
        setState(() {
          _history.clear();
        });
        return;
      case 'whoami':
        response = "root (vxkit)";
        type = "sys";
        break;
      case 'nmap':
        response = "Starting Nmap 7.93...\nScanning 127.0.0.1...\n[+] Port 22/tcp Open (ssh)\n[+] Port 80/tcp Open (http)\n[+] Port 443/tcp Open (https)\nNmap done: 1 IP address scanned in 1.42 seconds.";
        type = "success";
        break;
      case 'set rhost'
        response = "rhost = 192.168.1.10 (la cible)"
        type = "success";
        break;
      case 'set rport'
        response = "rport = 80 ou bien 4444 (port de la cible)";
        type = "success";
        break;
      case 'set lhost'
        response = "lhost = 192.168.1.5 (votre ip pour un reverse shell)";
        type = "success";
        break;
      case 'exploit':
        response = "[*] Started reverse TCP handler on 0.0.0.0:4444\n[*] Sending stage (175174 bytes) to 192.168.1.45\n[+] Meterpreter session 1 opened (192.168.1.45)\n\nmeterpreter > getuid\nServer username: NT AUTHORITY\\SYSTEM";
        type = "danger";
        break;
      default:
        response = "bash: $cmd: command not found";
        type = "danger";
        break;
    }

    setState(() {
      _history.add({"text": response, "type": type});
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Terminal | Comportement des tools", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 11)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white10, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final line = _history[index];
                Color textColor;
                switch (line["type"]) {
                  case "input": textColor = Colors.white; break;
                  case "sys": textColor = Colors.white54; break;
                  case "success": textColor = const Color(0xFF00FF41); break;
                  case "danger": textColor = const Color(0xFFFF003C); break;
                  default: textColor = Colors.white70;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    line["text"]!,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: textColor),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0A0A0A),
            child: Row(
              children: [
                const Text("root@vxkit:~# ", style: TextStyle(fontFamily: 'monospace', color: Color(0xFF00FF41), fontSize: 12, fontWeight: FontWeight.bold)),
                Expanded(
                  child: TextField(
                    controller: _cmdController,
                    focusNode: _focusNode,
                    style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12),
                    cursorColor: const Color(0xFF26A5E4),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: _handleCommand,
                  ),
                ),
              ],
            ),
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
      version: "v0.0.3",
      date: "17 Mai 2026",
      changes: [
        "Nouveau design.",
        "Ajout d'un simulateur de Terminal interactif.",
      ],
    ),
    UpdateRelease(
      version: "v0.0.2",
      date: "17 Mai 2026",
      changes: [
        "Mise à jour des scripts de compilation de contournement iOS.",
        "Refonte du système de catégories.",
      ],
    ),
    UpdateRelease(
      version: "v0.0.1",
      date: "16 Mai 2026",
      changes: ["Lancement initial de VxKit.", "Bypass xcode team development."],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SYSTEM_LOGS", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 16))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: updates.length,
        itemBuilder: (context, i) {
          final up = updates[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(up.version, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF26A5E4), fontFamily: 'monospace')),
                    Text(up.date.toUpperCase(), style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                ...up.changes.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("> ", style: TextStyle(color: Colors.white24, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                      Expanded(child: Text(c, style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'))),
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

// --- Page 4: About & Telegram ---
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text("VXKIT", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 8)),
          const SizedBox(height: 60),
          _buildInfoRow("Developpeur", "HX"),
          _buildInfoRow("Version", "v0.0.3"),
          _buildInfoRow("Satus", "En developpement..."),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: _launchTelegram,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A5E4),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Bordures brutes
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.telegram, size: 24),
                  SizedBox(width: 12),
                  Text("Rejoindre sur telegram", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Clipboard.setData(const ClipboardData(text: "https://t.me/vxshare5")),
            child: const Text("[ Copier le lien ]", style: TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace', color: Colors.white70)),
        ],
      ),
    );
  }
}

// --- Base de Données des Outils ---
class _ToolsData {
  static const List<PentestTool> tools = [
    // --- RESEAU ---
    PentestTool(
      name: "Nmap",
      category: "Réseau",
      description: "Scanner de ports et cartographie réseau incontournable.",
      icon: Icons.radar,
      installCommands: {"Termux": "pkg install nmap", "iSH": "apk add nmap"},
      usages: [
        ToolUsageExample(title: "Scan Rapide", command: "nmap target.com", explanation: "Analyse les 1000 ports les plus communs."),
        ToolUsageExample(title: "Détection d'OS", command: "nmap -O target.com", explanation: "Tente de déterminer le système d'exploitation."),
        ToolUsageExample(title: "Scan Furtif", command: "nmap -sS -T4 target.com", explanation: "Scan SYN pour éviter la détection par les pare-feu."),
      ],
    ),
    PentestTool(
      name: "Metasploit",
      category: "Réseau",
      description: "Framework d'exploitation et de post-exploitation.",
      icon: Icons.bug_report_sharp,
      installCommands: {"Termux": "pkg install unstable-repo && pkg install metasploit"},
      usages: [
        ToolUsageExample(title: "Lancer la console", command: "msfconsole -q", explanation: "Ouvre Metasploit en mode silencieux."),
        ToolUsageExample(title: "Recherche d'exploit", command: "search type:exploit platform:windows", explanation: "Cherche des failles pour Windows."),
        ToolUsageExample(title: "Handler (Reverse Shell)", command: "use exploit/multi/handler\nset PAYLOAD windows/meterpreter/reverse_tcp\nexploit", explanation: "Ouvre un port local pour écouter une connexion entrante."),
      ],
    ),
    PentestTool(
      name: "Bettercap",
      category: "Réseau",
      description: "Couteau suisse pour les attaques MITM, WiFi et réseau local.",
      icon: Icons.security_sharp,
      installCommands: {"Termux": "pkg install bettercap"},
      usages: [
        ToolUsageExample(title: "Écoute réseau", command: "bettercap -iface wlan0", explanation: "Lance l'interface sur la carte wifi principale."),
        ToolUsageExample(title: "Détection d'hôtes", command: "net.probe on", explanation: "Découvre activement les appareils sur le LAN."),
        ToolUsageExample(title: "Spoofing ARP", command: "set arp.spoof.targets IP; arp.spoof on", explanation: "Détourne le trafic d'une cible vers votre machine."),
      ],
    ),
    PentestTool(
      name: "Netcat",
      category: "Réseau",
      description: "Lecture et écriture brute de données via TCP/UDP.",
      icon: Icons.settings_ethernet_sharp,
      installCommands: {"Termux": "pkg install netcat", "iSH": "apk add netcat-openbsd"},
      usages: [
        ToolUsageExample(title: "Écoute locale", command: "nc -lvnp 4444", explanation: "Ouvre le port 4444 pour réceptionner un reverse shell."),
        ToolUsageExample(title: "Transfert de fichier", command: "nc -lvnp 9000 > recu.txt", explanation: "Ouvre un port et sauvegarde tout le texte reçu."),
      ],
    ),
    PentestTool(
      name: "Impacket",
      category: "Réseau",
      description: "Collection de scripts Python pour protocoles de bas niveau (SMB, WMI).",
      icon: Icons.layers_sharp,
      installCommands: {"Termux": "pkg install python python-cryptography && pip install impacket"},
      usages: [
        ToolUsageExample(title: "Exécution WMI", command: "wmiexec.py admin@192.168.1.10", explanation: "Ouvre un shell furtif Windows via WMI sans créer de service."),
        ToolUsageExample(title: "Dump de hashs SAM", command: "secretsdump.py local -sam sam.save -system sys.save", explanation: "Extrait les mots de passe Windows locaux."),
      ],
    ),
    
    // --- WEB ---
    PentestTool(
      name: "Sqlmap",
      category: "Web",
      description: "Outil d'automatisation d'injections SQL et de prise de contrôle de BDD.",
      icon: Icons.storage_sharp,
      installCommands: {"Termux": "pkg install python && git clone https://github.com/sqlmapproject/sqlmap.git"},
      usages: [
        ToolUsageExample(title: "Détection d'injection", command: "python sqlmap.py -u 'http://target.com/page.php?id=1'", explanation: "Vérifie si le paramètre ID est vulnérable."),
        ToolUsageExample(title: "Extraction de base", command: "python sqlmap.py -u 'URL' --dbs", explanation: "Liste toutes les bases de données du serveur."),
        ToolUsageExample(title: "Dump de table", command: "python sqlmap.py -u 'URL' -D mabase -T users --dump", explanation: "Aspire le contenu de la table utilisateurs."),
      ],
    ),
    PentestTool(
      name: "Gobuster",
      category: "Web",
      description: "Fuzzing de répertoires, sous-domaines et vhosts en Go.",
      icon: Icons.travel_explore_sharp,
      installCommands: {"Termux": "pkg install gobuster", "iSH": "apk add go && go install github.com/OJ/gobuster/v3@latest"},
      usages: [
        ToolUsageExample(title: "Brute-force de dossiers", command: "gobuster dir -u http://target.com -w wordlist.txt", explanation: "Recherche les répertoires cachés d'un site web."),
        ToolUsageExample(title: "Fuzzing agressif", command: "gobuster dir -u http://target.com -w wordlist.txt -t 50", explanation: "Accélère la recherche avec 50 threads simultanés."),
      ],
    ),
    PentestTool(
      name: "Nuclei",
      category: "Web",
      description: "Scanner de vulnérabilités très rapide basé sur des templates YAML.",
      icon: Icons.flash_on_sharp,
      installCommands: {"Termux": "pkg install nuclei"},
      usages: [
        ToolUsageExample(title: "Scan par défaut", command: "nuclei -u http://target.com", explanation: "Exécute la base de templates de sécurité sur la cible."),
        ToolUsageExample(title: "Scan ciblé CVE", command: "nuclei -u http://target.com -t cves/", explanation: "Vérifie uniquement les vulnérabilités publiques (CVE)."),
      ],
    ),

    // --- PASSWORDS ---
    PentestTool(
      name: "John The Ripper",
      category: "Passwords",
      description: "Casseur de mots de passe hors-ligne historique et robuste.",
      icon: Icons.key_sharp,
      installCommands: {"Termux": "pkg install john"},
      usages: [
        ToolUsageExample(title: "Attaque par dictionnaire", command: "john --wordlist=rockyou.txt hashes.txt", explanation: "Craque les hashs avec une wordlist."),
        ToolUsageExample(title: "Afficher les résultats", command: "john --show hashes.txt", explanation: "Affiche les mots de passe déchiffrés stockés en cache."),
      ],
    ),
    PentestTool(
      name: "Hydra",
      category: "Passwords",
      description: "Outil de brute-force de login réseau ultra-rapide.",
      icon: Icons.password_sharp,
      installCommands: {"Termux": "pkg install hydra", "iSH": "apk add hydra"},
      usages: [
        ToolUsageExample(title: "Brute-force SSH", command: "hydra -l root -P pass.txt ssh://192.168.1.10", explanation: "Tente de craquer le compte root du serveur SSH."),
        ToolUsageExample(title: "Brute-force FTP", command: "hydra -L users.txt -P pass.txt ftp://192.168.1.50", explanation: "Teste des combos nom/mot de passe sur un FTP."),
      ],
    ),

    // --- REVERSING ---
    PentestTool(
      name: "Radare2",
      category: "Reversing",
      description: "Framework CLI complet d'ingénierie inverse et de patching.",
      icon: Icons.memory_sharp,
      installCommands: {"Termux": "pkg install radare2", "iSH": "apk add radare2"},
      usages: [
        ToolUsageExample(title: "Analyse automatique", command: "r2 -A ./binaire", explanation: "Ouvre et dissèque automatiquement un exécutable."),
        ToolUsageExample(title: "Lire une fonction", command: "pdf @main", explanation: "Affiche le code assembleur de la fonction principale."),
      ],
    ),
  ];
}



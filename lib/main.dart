
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
      ),
      home: const MainNavigation(),
    );
  }
}

// --- Modele de donnees pour les outils ---
class PentestTool {
  final String name;
  final String description;
  final IconData icon;
  final Map<String, String> commands;

  PentestTool({
    required this.name, 
    required this.description, 
    required this.icon, 
    required this.commands
  });
}

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
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[700],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.terminal), label: 'Outils'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Quick'),
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Vx'),
          ],
        ),
      ),
    );
  }
}

// --- Page 1: Liste des outils ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  static final List<PentestTool> tools = [
    PentestTool(
      name: "Nmap",
      description: "Scanner de ports et decouverte de reseau.",
      icon: Icons.radar,
      commands: {
        "iSH": "apk add nmap && nmap -sV target.com",
        "Termux": "pkg install nmap && nmap -A target.com",
        "Windows": "nmap.exe -T4 -A target.com",
      }
    ),
    PentestTool(
      name: "Metasploit",
      description: "Framework d'exploitation de vulnerabilites.",
      icon: Icons.bug_report_outlined,
      commands: {
        "iSH": "Non recommande (trop lourd)",
        "Termux": "pkg install metasploit && msfconsole",
        "Windows": "msfconsole.bat",
      }
    ),
    PentestTool(
      name: "Sqlmap",
      description: "Injection SQL automatique.",
      icon: Icons.storage,
      commands: {
        "iSH": "apk add python3 && git clone... && python3 sqlmap.py -u URL",
        "Termux": "pkg install python && python sqlmap -u URL",
        "Windows": "python sqlmap.py -u URL",
      }
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120.0,
            backgroundColor: Colors.black,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "TOOLS", 
                style: TextStyle(
                  letterSpacing: 4, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.white,
                )
              ),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tool = tools[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () => _showToolDetails(context, tool),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(tool.icon, size: 30, color: Colors.white),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tool.name, 
                                  style: const TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.white,
                                  )
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tool.description, 
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500])
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: tools.length,
            ),
          ),
        ],
      ),
    );
  }

  void _showToolDetails(BuildContext context, PentestTool tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50, 
                height: 5, 
                decoration: BoxDecoration(
                  color: Colors.white24, 
                  borderRadius: BorderRadius.circular(10),
                )
              )
            ),
            const SizedBox(height: 30),
            Text(
              tool.name.toUpperCase(), 
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 2,
                color: Colors.white,
              )
            ),
            const SizedBox(height: 10),
            Text(tool.description, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 30),
            const Text(
              "COMMANDS BY OS", 
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: tool.commands.entries.map((entry) => _buildCodeBox(context, entry.key, entry.value)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBox(BuildContext context, String platform, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
          child: Text(
            platform, 
            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13),
                    children: _highlightSyntax(code),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18, color: Colors.white38),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copie dans le presse-papiers'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.white24,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  List<TextSpan> _highlightSyntax(String code) {
    List<TextSpan> spans = [];
    final parts = code.split(' ');
    for (int i = 0; i < parts.length; i++) {
      Color color = Colors.white;
      if (i == 0) {
        color = Colors.greenAccent;
      } else if (parts[i].startsWith('-')) {
        color = Colors.yellowAccent;
      }
      
      spans.add(TextSpan(text: "${parts[i]} ", style: TextStyle(color: color)));
    }
    return spans;
  }
}

// --- Page 2: Commandes Rapides (Quick) ---
class CommandsQuickPage extends StatelessWidget {
  const CommandsQuickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: const Text(
          "QUICK CMDS", 
          style: TextStyle(letterSpacing: 2, color: Colors.white)
        )
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildQuickTile(context, "Nettoyage Log", "rm -rf /var/log/*.log"),
          _buildQuickTile(context, "IP Publique", "curl ifconfig.me"),
          _buildQuickTile(context, "Processus Actifs", "ps aux | grep root"),
          _buildQuickTile(context, "Ecoute Ports", "netstat -tuln"),
        ],
      ),
    );
  }

  Widget _buildQuickTile(BuildContext context, String title, String cmd) {
    return Container(
      margin: const EdgeInsets.bottom(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  cmd, 
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.content_copy, size: 16, color: Colors.white24),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: cmd));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copie dans le presse-papiers'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.white24,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

// --- Page 3: About Vx ---
class VxAboutPage extends StatelessWidget {
  const VxAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Vx", 
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, letterSpacing: -5, color: Colors.white)
                ),
                const Divider(color: Colors.white10),
                const SizedBox(height: 20),
                _infoRow("DEVELOPER", "Hx"),
                _infoRow("VERSION", "0.0.1"),
                _infoRow("STATUS", "STABLE"),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // Copie du lien Telegram
                    Clipboard.setData(const ClipboardData(text: "https://t.me/vxshare5"));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lien Telegram copie !'),
                        backgroundColor: Colors.white24,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("COPY TELEGRAM LINK", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "https://t.me/vxshare5", 
                  style: TextStyle(color: Colors.grey, fontSize: 12)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- Modele de donnees simple ---
class PentestTool {
  final String name;
  final String description;
  final IconData icon;
  final Map<String, String> commands;

  const PentestTool({
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

// --- Page 1: Liste des outils (Version ultra-stable) ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  static const List<PentestTool> tools = [
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
      appBar: AppBar(
        title: const Text(
          "TOOLS", 
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, color: Colors.white)
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(tool.icon, size: 28, color: Colors.white),
              title: Text(
                tool.name, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(tool.description, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white30),
              onTap: () => _showToolDetails(context, tool),
            ),
          );
        },
      ),
    );
  }

  void _showToolDetails(BuildContext context, PentestTool tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, 
                height: 4, 
                decoration: BoxDecoration(
                  color: Colors.white24, 
                  borderRadius: BorderRadius.circular(10),
                )
              )
            ),
            const SizedBox(height: 24),
            Text(
              tool.name.toUpperCase(), 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)
            ),
            const SizedBox(height: 8),
            Text(tool.description, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
            const SizedBox(height: 24),
            const Text(
              "COMMANDS BY OS", 
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: tool.commands.entries.map((entry) => _buildCodeBox(context, entry.key, entry.value)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBox(BuildContext context, String platform, String code) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            platform, 
            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      children: _highlightSyntax(code),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: Colors.white38),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
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
      ),
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
        title: const Text(
          "QUICK CMDS", 
          style: TextStyle(letterSpacing: 2, color: Colors.white)
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 6),
                Text(
                  cmd, 
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vx", 
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, letterSpacing: -4, color: Colors.white)
              ),
              const Divider(color: Colors.white10, height: 32),
              _infoRow("DEVELOPER", "Hx"),
              _infoRow("VERSION", "0.0.1"),
              _infoRow("STATUS", "STABLE"),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: "https://t.me/vxshare5"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lien Telegram copie !'),
                      backgroundColor: Colors.white24,
                    ),
                  );
                },
                icon: const Icon(Icons.send, size: 18),
                label: const Text("COPY TELEGRAM LINK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 16),
              const Text(
                "https://t.me/vxshare5", 
                style: TextStyle(color: Colors.grey, fontSize: 11)
              ),
            ],
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.5)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

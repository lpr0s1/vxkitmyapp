
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

// --- Page 1: Liste des outils (Version ultra-stable avec 32 outils complets) ---
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  static const List<PentestTool> tools = [
    PentestTool(
      name: "Nmap",
      description: "Scanner de ports avancé et découverte de réseau.",
      icon: Icons.radar,
      commands: {
        "iSH": "apk update && apk add nmap\nnmap -sV -p 1-1024 target.com",
        "Termux": "pkg update && pkg install nmap -y\nnmap -sS -A -T4 target.com",
        "Windows": "nmap.exe -sS -sV -O -p- target.com",
      }
    ),
    PentestTool(
      name: "Metasploit",
      description: "Framework complet d'exploitation de vulnérabilités.",
      icon: Icons.bug_report_outlined,
      commands: {
        "iSH": "# Trop lourd pour l'émulation iSH\n# Recommandé d'utiliser un serveur distant via SSH",
        "Termux": "pkg update && pkg install unstable-repo -y\npkg install metasploit -y\nmsfconsole",
        "Windows": "msfconsole.bat (Exécutez l'installeur officiel Rapid7)",
      }
    ),
    PentestTool(
      name: "Sqlmap",
      description: "Injection SQL automatique et prise de contrôle de base de données.",
      icon: Icons.storage,
      commands: {
        "iSH": "apk add python3 git\ngit clone --depth 1 https://github.com/sqlmapproject/sqlmap.git\npython3 sqlmap/sqlmap.py -u \"http://target.com/index.php?id=1\" --dbs",
        "Termux": "pkg install python git -y\ngit clone --depth 1 https://github.com/sqlmapproject/sqlmap.git\npython sqlmap/sqlmap.py -u \"http://target.com/index.php?id=1\" --banner",
        "Windows": "python.exe sqlmap.py -u \"http://target.com/index.php?id=1\" --batch",
      }
    ),
    PentestTool(
      name: "Hydra",
      description: "Outil d'attaque brute-force de protocoles réseau ultra-rapide.",
      icon: Icons.vpn_key,
      commands: {
        "iSH": "apk add hydra\nhydra -l admin -P wordlist.txt target.com ssh",
        "Termux": "pkg install hydra -y\nhydra -L users.txt -P pass.txt ftp://192.168.1.1",
        "Windows": "hydra.exe -l root -P pass.txt ssh://192.168.1.100",
      }
    ),
    PentestTool(
      name: "John the Ripper",
      description: "Déchiffreur de hashs de mots de passe hors-ligne.",
      icon: Icons.lock_open,
      commands: {
        "iSH": "apk add john\njohn --wordlist=pass.txt shadow_hashes",
        "Termux": "pkg install john -y\njohn --format=raw-md5 md5_hashes.txt",
        "Windows": "john.exe --wordlist=rockyou.txt hashes.txt",
      }
    ),
    PentestTool(
      name: "Hashcat",
      description: "Récupérateur de mots de passe basé sur GPU/CPU ultra-rapide.",
      icon: Icons.grid_view,
      commands: {
        "iSH": "# Non supporté (iSH n'a pas accès direct au calcul GPU)",
        "Termux": "pkg install hashcat -y\nhashcat -m 0 md5_hash.txt wordlist.txt",
        "Windows": "hashcat.exe -m 1000 ntlm_hash.txt ?a?a?a?a",
      }
    ),
    PentestTool(
      name: "Nikto",
      description: "Scanner de vulnérabilités de serveurs Web (CGI, configurations).",
      icon: Icons.find_in_page,
      commands: {
        "iSH": "apk add perl git\ngit clone https://github.com/sullo/nikto.git\nperl nikto/program/nikto.pl -h target.com",
        "Termux": "pkg install perl git -y\ngit clone https://github.com/sullo/nikto.git\nperl nikto/program/nikto.pl -h http://192.168.1.1",
        "Windows": "perl.exe nikto.pl -h target.com",
      }
    ),
    PentestTool(
      name: "Dirb",
      description: "Scanner de contenu web par dictionnaire (fichiers/dossiers cachés).",
      icon: Icons.folder,
      commands: {
        "iSH": "apk add curl git make build-base\n# Compilation manuelle requise",
        "Termux": "pkg install dirb -y\ndirb http://target.com/ wordlist.txt",
        "Windows": "dirb.exe http://target.com/ wordlist.txt",
      }
    ),
    PentestTool(
      name: "Gobuster",
      description: "Brute-forceur de répertoires, sous-domaines et vhosts écrit en Go.",
      icon: Icons.travel_explore,
      commands: {
        "iSH": "apk add go\ngo install github.com/OJ/gobuster/v3@latest\n~/go/bin/gobuster dir -u http://target.com -w wordlist.txt",
        "Termux": "pkg install gobuster -y\ngobuster dir -u http://target.com -w wordlist.txt",
        "Windows": "gobuster.exe dir -u http://target.com -w wordlist.txt",
      }
    ),
    PentestTool(
      name: "WPScan",
      description: "Scanner de sécurité WordPress pour lister plugins vulnérables.",
      icon: Icons.web,
      commands: {
        "iSH": "apk add ruby ruby-dev build-base libxml2-dev libxslt-dev\ngem install wpscan\nwpscan --url http://target-wp.com",
        "Termux": "pkg install ruby libxml2 libxslt -y\ngem install wpscan\nwpscan --url http://target-wp.com --enumerate vp",
        "Windows": "gem install wpscan\nwpscan.bat --url http://target-wp.com",
      }
    ),
    PentestTool(
      name: "Netcat (nc)",
      description: "Couteau suisse réseau pour lecture, écriture et écoute TCP/UDP.",
      icon: Icons.settings_ethernet,
      commands: {
        "iSH": "apk add netcat-openbsd\nnc -lvnp 4444",
        "Termux": "pkg install netcat -y\nnc -lvnp 4444",
        "Windows": "nc.exe -lvnp 4444 -e cmd.exe",
      }
    ),
    PentestTool(
      name: "Tshark (Wireshark)",
      description: "Version CLI de l'analyseur de protocoles réseau Wireshark.",
      icon: Icons.analytics,
      commands: {
        "iSH": "apk add tshark\ntshark -i eth0 -f \"tcp port 80\"",
        "Termux": "# Requiert l'accès root sur le téléphone Android\ntshark -i wlan0 -c 100",
        "Windows": "tshark.exe -i 1 -w capture.pcap",
      }
    ),
    PentestTool(
      name: "Searchsploit",
      description: "Outil de recherche locale d'exploits de la base Exploit-DB.",
      icon: Icons.manage_search,
      commands: {
        "iSH": "apk add git python3\ngit clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb\nln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit\nsearchsploit eternalblue",
        "Termux": "pkg install exploitdb -y\nsearchsploit windows smb",
        "Windows": "python.exe searchsploit.py apache 2.4",
      }
    ),
    PentestTool(
      name: "Radare2",
      description: "Framework d'ingénierie inverse et d'analyse de binaires.",
      icon: Icons.developer_board,
      commands: {
        "iSH": "apk add radare2\nr2 -A ./binary_name",
        "Termux": "pkg install radare2 -y\nr2 -A ./binary_name",
        "Windows": "radare2.exe -A application.exe",
      }
    ),
    PentestTool(
      name: "Airgeddon",
      description: "Script d'audit multi-usage pour réseaux sans fil (WPA/WPS).",
      icon: Icons.wifi,
      commands: {
        "iSH": "# iSH ne gère pas le mode moniteur sans fil matériel",
        "Termux": "# Requiert une carte wifi externe OTG et un noyau patché",
        "Windows": "# Non supporté nativement (utilisez une VM Kali Linux)",
      }
    ),
    PentestTool(
      name: "Commix",
      description: "Exploitation automatisée d'injections de commandes système.",
      icon: Icons.code,
      commands: {
        "iSH": "apk add python3 git\ngit clone https://github.com/commixproject/commix.git\npython3 commix/commix.py --url=\"http://target.com/exec.php?addr=127.0.0.1\"",
        "Termux": "pkg install python git -y\ngit clone https://github.com/commixproject/commix.git\npython commix/commix.py --url=\"http://target.com/exec.php?addr=INJECT\"",
        "Windows": "python.exe commix.py --url=\"http://target.com/page.asp?id=1\"",
      }
    ),
    PentestTool(
      name: "Responder",
      description: "Empoisonneur LLMNR, NBT-NS et MDNS pour récolter des hashs Windows.",
      icon: Icons.settings_input_antenna,
      commands: {
        "iSH": "apk add python3 git\ngit clone https://github.com/lgandx/Responder.git\npython3 Responder/Responder.py -I eth0 -w -d",
        "Termux": "# Nécessite les privilèges root sous Android",
        "Windows": "# Non supporté (exécutez sous WSL2 ou Kali Linux)",
      }
    ),
    PentestTool(
      name: "Impacket",
      description: "Bibliothèque de protocoles réseau bas niveau (psexec, wmiexec).",
      icon: Icons.layers,
      commands: {
        "iSH": "apk add python3 python3-dev build-base libffi-dev openssl-dev\npip3 install impacket\npsexec.py administrator@192.168.1.50",
        "Termux": "pkg install python python-cryptography -y\npip install impacket\nwmiexec.py Administrator@192.168.1.100",
        "Windows": "pip install impacket\npython.exe psexec.py administrator@192.168.1.10",
      }
    ),
    PentestTool(
      name: "CrackMapExec",
      description: "Outil d'audit post-exploitation d'environnements Active Directory.",
      icon: Icons.dns,
      commands: {
        "iSH": "# Dépendances trop complexes pour iSH",
        "Termux": "pip install crackmapexec\ncme smb 192.168.1.0/24 -u User -p Password",
        "Windows": "pip install crackmapexec\ncme.exe smb 192.168.1.100 --shares",
      }
    ),
    PentestTool(
      name: "Bettercap",
      description: "Framework d'analyse réseau complet pour les attaques MITM.",
      icon: Icons.security,
      commands: {
        "iSH": "# Problème d'accès aux sockets bas niveau sous iSH",
        "Termux": "pkg install bettercap -y\nbettercap -iface wlan0",
        "Windows": "bettercap.exe -iface Ethernet",
      }
    ),
    PentestTool(
      name: "Socat",
      description: "Outil de transfert de données bidirectionnel (canaux logiques).",
      icon: Icons.swap_horiz,
      commands: {
        "iSH": "apk add socat\nsocat TCP-LISTEN:4444,reuseaddr FILE:`tty`,raw,echo=0",
        "Termux": "pkg install socat -y\nsocat TCP4-LISTEN:8080,fork TCP4:192.168.1.100:80",
        "Windows": "socat.exe TCP4-LISTEN:4444,fork EXEC:cmd.exe",
      }
    ),
    PentestTool(
      name: "Nuclei",
      description: "Scanner de vulnérabilités très rapide basé sur des modèles YAML.",
      icon: Icons.flash_on,
      commands: {
        "iSH": "apk add go\ngo install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest\n~/go/bin/nuclei -u target.com",
        "Termux": "pkg install nuclei -y\nnuclei -u http://target.com",
        "Windows": "nuclei.exe -u http://target.com",
      }
    ),
    PentestTool(
      name: "Amass",
      description: "Cartographie de surface d'attaque externe et découverte DNS.",
      icon: Icons.bubble_chart,
      commands: {
        "iSH": "apk add amass\namass enum -d target.com",
        "Termux": "pkg install amass -y\namass enum -passive -d target.com",
        "Windows": "amass.exe enum -d target.com",
      }
    ),
    PentestTool(
      name: "Subfinder",
      description: "Énumération passive ultra-rapide de sous-domaines web.",
      icon: Icons.pageview,
      commands: {
        "iSH": "apk add go\ngo install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest\n~/go/bin/subfinder -d target.com",
        "Termux": "pkg install subfinder -y\nsubfinder -d target.com -o subdomains.txt",
        "Windows": "subfinder.exe -d target.com",
      }
    ),
    PentestTool(
      name: "Shodan CLI",
      description: "Recherche sur le moteur Shodan depuis la ligne de commande.",
      icon: Icons.cloud_queue,
      commands: {
        "iSH": "apk add python3 pip3\npip3 install shodan\nshodan init API_KEY\nshodan host 8.8.8.8",
        "Termux": "pkg install python -y\npip install shodan\nshodan search apache",
        "Windows": "pip install shodan\nshodan.exe stats port:22",
      }
    ),
    PentestTool(
      name: "WhatWeb",
      description: "Identification de technologies et CMS de serveurs web.",
      icon: Icons.language,
      commands: {
        "iSH": "apk add ruby curl\ngit clone https://github.com/urbanadventurer/WhatWeb.git\nruby WhatWeb/whatweb target.com",
        "Termux": "pkg install ruby -y\ngit clone https://github.com/urbanadventurer/WhatWeb.git\nruby WhatWeb/whatweb target.com",
        "Windows": "ruby.exe whatweb target.com",
      }
    ),
    PentestTool(
      name: "Ghidra",
      description: "Logiciel de reverse-engineering de la NSA (mode sans GUI).",
      icon: Icons.psychology,
      commands: {
        "iSH": "# Incompatible (JVM trop lourde pour iSH)",
        "Termux": "pkg install openjdk-17 -y\n# support/analyzeHeadless pour exécuter",
        "Windows": "support\\analyzeHeadless.bat . ProjectName -import target_file.exe",
      }
    ),
    PentestTool(
      name: "DNSRecon",
      description: "Énumération DNS avancée (transferts de zone, reverse lookups).",
      icon: Icons.explore,
      commands: {
        "iSH": "apk add python3 pip3\npip3 install dnsrecon\ndnsrecon -d target.com",
        "Termux": "pkg install python -y\npip install dnsrecon\ndnsrecon -d target.com -t std",
        "Windows": "pip install dnsrecon\ndnsrecon.py -d target.com -a",
      }
    ),
    PentestTool(
      name: "Routersploit",
      description: "Framework d'exploitation ciblant les routeurs et objets connectés.",
      icon: Icons.router,
      commands: {
        "iSH": "apk add python3 python3-dev build-base git\ngit clone https://github.com/threat9/routersploit.git\npip3 install -r routersploit/requirements.txt\npython3 routersploit/rsf.py",
        "Termux": "pkg install python git -y\ngit clone https://github.com/threat9/routersploit.git\npip install -r routersploit/requirements.txt\npython routersploit/rsf.py",
        "Windows": "python.exe rsf.py",
      }
    ),
    PentestTool(
      name: "Wfuzz",
      description: "Framework de fuzzing web pour l'injection de paramètres.",
      icon: Icons.pattern,
      commands: {
        "iSH": "apk add python3 pip3 python3-dev build-base curl-dev\npip3 install wfuzz\nwfuzz -c -z file,wordlist.txt --hc 404 http://target.com/FUZZ",
        "Termux": "pkg install python -y\npip install wfuzz\nwfuzz -w wordlist.txt http://target.com/FUZZ",
        "Windows": "pip install wfuzz\nwfuzz.exe -w wordlist.txt -u http://target.com/FUZZ",
      }
    ),
    PentestTool(
      name: "Tcpdump",
      description: "Analyseur de paquets réseau ligne de commande léger et robuste.",
      icon: Icons.line_weight,
      commands: {
        "iSH": "apk add tcpdump\ntcpdump -i eth0 -n -c 50",
        "Termux": "# Requiert l'accès root sur Android\ntcpdump -i wlan0 -vvv",
        "Windows": "# Exécutez WinDump.exe avec WinPcap installé",
      }
    ),
    PentestTool(
      name: "Gobuster DNS",
      description: "Fuzzing de sous-domaines DNS ultra-rapide par dictionnaire.",
      icon: Icons.dns_outlined,
      commands: {
        "iSH": "apk add go\ngo install github.com/OJ/gobuster/v3@latest\n~/go/bin/gobuster dns -d target.com -w wordlist.txt",
        "Termux": "pkg install gobuster -y\ngobuster dns -d target.com -w wordlist.txt",
        "Windows": "gobuster.exe dns -d target.com -w wordlist.txt",
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
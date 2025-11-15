import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

void main() {
  runApp(const ProgrammingJokesApp());
}

class ProgrammingJokesApp extends StatelessWidget {
  const ProgrammingJokesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Jokes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String setup = "";
  String punchline = "";
  bool isLoading = false;
  List<String> favorites = [];

  // Offline fallback jokes
  final List<Map<String, String>> offlineJokes = [
    {
      "setup": "Why do programmers prefer dark mode?",
      "punchline": "Because light attracts bugs."
    },
    {
      "setup": "What’s a programmer’s favorite hangout place?",
      "punchline": "The Foo Bar."
    },
    {
      "setup": "Why did the developer go broke?",
      "punchline": "Because he used up all his cache."
    },
  ];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    fetchJoke();
  }

  Future<void> fetchJoke() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://official-joke-api.appspot.com/jokes/programming/random');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          setup = data[0]['setup'];
          punchline = data[0]['punchline'];
          isLoading = false;
        });
      } else {
        showOfflineJoke();
      }
    } catch (e) {
      showOfflineJoke();
    }
  }

  void showOfflineJoke() {
    final random = (offlineJokes..shuffle()).first;
    setState(() {
      setup = random['setup']!;
      punchline = random['punchline']!;
      isLoading = false;
    });
  }

  void shareJoke() {
    if (setup.isNotEmpty && punchline.isNotEmpty) {
      Share.share('$setup\n\n$punchline\n😂 #ProgrammingJokes');
    }
  }

  void toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final joke = "$setup\n$punchline";

    setState(() {
      if (favorites.contains(joke)) {
        favorites.remove(joke);
      } else {
        favorites.add(joke);
      }
    });

    prefs.setStringList('favorites', favorites);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void showFavorites() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => favorites.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text("No favorite jokes yet 😅",
                    style: TextStyle(fontSize: 18)),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final joke = favorites[index].split('\n');
                return ListTile(
                  title: Text(joke[0],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(joke.length > 1 ? joke[1] : ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      setState(() {
                        favorites.removeAt(index);
                      });
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setStringList('favorites', favorites);
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "💻 Programming Jokes",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: showFavorites,
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      tooltip: 'View Favorites',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    setup,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    punchline,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: fetchJoke,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text("Next"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: shareJoke,
                                        icon: const Icon(Icons.share),
                                        label: const Text("Share"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pinkAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          favorites.contains(
                                                  "$setup\n$punchline")
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                                        onPressed: toggleFavorite,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

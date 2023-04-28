import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

var selectedIndex = 0;
Map<String, List<Color>> pokemonType = {
  'Grass': [Colors.greenAccent.shade700, Colors.black],
  'Water': [Colors.lightBlueAccent.shade700, Colors.black],
  'Fire': [Colors.orange.shade900, Colors.black],
  'Electric': [Colors.yellowAccent.shade700, Colors.black],
  'Psychic': [Colors.pink.shade500, Colors.black],
  'Ice': [Colors.blue.shade200, Colors.black],
  'Dragon': [Colors.deepPurpleAccent.shade400, Colors.white],
  'Dark': [Colors.grey.shade900, Colors.white],
  'Fairy': [Colors.pink.shade200, Colors.black],
  'Steel': [Colors.blueGrey.shade300, Colors.black],
  'Ghost': [Colors.deepPurple.shade200, Colors.black],
  'Bug': [Colors.lime.shade700, Colors.black],
  'Rock': [Colors.brown.shade600, Colors.white],
  'Ground': [Colors.amber.shade200, Colors.black],
  'Poison': [Colors.purple.shade200, Colors.white],
  'Flying': [Colors.indigo.shade100, Colors.black],
  'Fighting': [Colors.deepOrange.shade900, Colors.white],
  'Normal': [Colors.brown.shade100, Colors.black],
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Home(title: 'Portfolio'),
      debugShowCheckedModeBanner: false,

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

int currentBottomAppBarIndex = 0;

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<About> futureAbout;
  late Future<Word> futureWord;

  @override
  void initState() {
    super.initState();

    futureAbout = fetchData();
    futureWord = fetchWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
          builder: (BuildContext builder, BoxConstraints constraints) {
        if (constraints.maxWidth <= 400) {
          return _mobileLayout(futureAbout, futureWord);
        } else {
          // ignore: avoid_print
          // print(constraints.maxWidth);
          // return _wideLayout();
          return _mobileLayout(futureAbout, futureWord);
        }
      }),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentBottomAppBarIndex = index;
            });
          },
          selectedIndex: currentBottomAppBarIndex,
          destinations: const <Widget>[
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.account_circle), label: 'About'),
            NavigationDestination(icon: Icon(Icons.home), label: 'Random Word'),
          ]),
    );
  }

// Future<Word> futureWord
  Widget _mobileLayout(Future<About> futureAbout, Future<Word> futureWord) {
    return <Widget>[
      Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Image.asset('images/2.png'),
            // child: const Placeholder(fallbackHeight: 200, fallbackWidth: 200),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FittedBox(
              child: Text('John Christian Buenaflor',
                  style: TextStyle(fontSize: 50)),
            ),
          ),
          const Center(
            child: Text('An aspiring developer.'),
          )
        ],
      ),
      (Center(
        child: FutureBuilder<About>(
          future: futureAbout,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return const Text('Its working');
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.person),
                        ),
                        Text('Name: ${snapshot.data!.name}'),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.school),
                        ),
                        Text('Name: ${snapshot.data!.age}'),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.school),
                        ),
                        Text('Name: ${snapshot.data!.university}'),
                      ],
                    ),
                  ),
                ],
              ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      )),
      Column(
        children: [
          Center(
            child: FutureBuilder<Word>(
              future: futureWord,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.word);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      // Column(
      //   children: const [
      //     Center(
      //       child: Text('Free space'),
      //     )
      //   ],
      // ),
    ][currentBottomAppBarIndex];
  }
}

Widget _wideLayout() {
  return Row(
    children: const [
      Center(
        child: Text('Elaina I love you'),
      )
    ],
  );
}

class About {
  final String name;
  final String age;
  final String university;

  About({
    required this.name,
    required this.age,
    required this.university,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      name: json['name'],
      age: json['age'],
      university: json['university'],
    );
  }
}

class Word {
  final String word;
  Word({
    required this.word,
  });

  factory Word.fromJson(String json) {
    return Word(word: json);
  }
}

Future<About> fetchData() async {
  final dio = Dio();

  final response = await dio.get(
      'https://raw.githubusercontent.com/Anyastasia/portfolio/master/files/about.json');
  if (response.statusCode == 200) {
    return About.fromJson(jsonDecode(response.data));
  } else {
    throw Exception('Failed to fetch request');
  }
}

Future<Word> fetchWord() async {
  final dio = Dio();

  final response = await dio.get('https://random-word-api.herokuapp.com/word');

  // final response = await http.get(Uri.parse(
  // 'https://raw.githubusercontent.com/Anyastasia/portfolio/master/files/about.json'));
  if (response.statusCode == 200) {
    return Word.fromJson(jsonDecode(response.data[0]));
  } else {
    throw Exception('Failed to fetch request');
  }
}

// class Home extends StatefulWidget {
//   const Home({super.key, required this.title});

//   final String title;
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final pokemonList = [
//     // const PokemonWidget(image: 'images/001.png', name: 'Bulbasaur'),
//     // const PokemonWidget(image: 'images/002.png', name: 'Ivysaur'),
//     // const PokemonWidget(image: 'images/003.png', name: 'Venusaur'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text(widget.title)),
//         body: GridView.count(
//           crossAxisCount: 3,
//           padding: const EdgeInsets.all(16),
//           mainAxisSpacing: 64,
//           crossAxisSpacing: 48,
//           children: [
//             for (var pokemon in pokemons)
//               PokemonWidget(
//                 image: pokemon['image'],
//                 name: pokemon['name'],
//                 type1: pokemon['type1'],
//                 type2: pokemon['type2'],
//                 description: pokemon['description'],
//               )
//           ],
//           // children: const [
//           //   PokemonWidget(image: 'images/001.png', name: 'Bulbasaur'),
//           //   PokemonWidget(image: 'images/002.png', name: 'Bulbasaur'),
//           //   PokemonWidget(image: 'images/003.png', name: 'Bulbasaur'),
//           // ],
//         ));
//   }
// }

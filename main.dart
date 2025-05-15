import 'package:flutter/material.dart';
import 'note_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Flag App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> subjects = const [
    {
      'name': 'App Development',
      'teacher': 'Sir Nabeel',
      'creditHours': 2,
    },
    {
      'name': 'Database Management',
      'teacher': 'Sir Hamza',
      'creditHours': 3,
    },
    {
      'name': 'Artificial Intelligence',
      'teacher': 'Sir Shehzad',
      'creditHours': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Main Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Notes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoteScreen()),
                );
              },
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://flagcdn.com/w320/pk.png', // ✅ Reliable PNG image
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enrolled Subjects',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.green),
                      title: Text(subject['name']),
                      subtitle: Text('Teacher: ${subject['teacher']}'),
                      trailing: Text('${subject['creditHours']} CH'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlagScreen()),
                );
              },
              icon: const Icon(Icons.flag),
              label: const Text('Show Pakistan Flag'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlagScreen extends StatelessWidget {
  const FlagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> flagUrls = [
      'https://upload.wikimedia.org/wikipedia/commons/3/32/Flag_of_Pakistan.svg',
      'https://flagcdn.com/w320/pk.png',
      'https://cdn.britannica.com/46/3346-004-D3BDE016/flag-symbolism-Pakistan-design-Islamic.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakistan Flag'),
      ),
      body: Center(
        child: FlagImageWithFallback(flagUrls: flagUrls),
      ),
    );
  }
}

class FlagImageWithFallback extends StatefulWidget {
  final List<String> flagUrls;

  const FlagImageWithFallback({Key? key, required this.flagUrls})
      : super(key: key);

  @override
  State<FlagImageWithFallback> createState() => _FlagImageWithFallbackState();
}

class _FlagImageWithFallbackState extends State<FlagImageWithFallback> {
  int currentUrlIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (currentUrlIndex >= widget.flagUrls.length) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF01411C),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 75,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 40),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF01411C),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Using backup flag display'),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          widget.flagUrls[currentUrlIndex],
          width: 300,
          height: 200,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 300,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  currentUrlIndex++;
                });
              }
            });
            return const SizedBox(
              width: 300,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          'Flag of Pakistan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

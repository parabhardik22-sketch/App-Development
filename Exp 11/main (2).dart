import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/wallpaper_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WallpaperViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NatureScape',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const WallpaperScreen(),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WallpaperViewModel>(context, listen: false).loadWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WallpaperViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nature Wallpapers 🌿')),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.loadWallpapers();
        },
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewModel.error != null
            ? ListView(
          children: [
            const SizedBox(height: 200),
            Center(child: Text(viewModel.error!)),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: viewModel.loadWallpapers,
                child: const Text('Retry'),
              ),
            ),
          ],
        )
            : GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: viewModel.wallpapers.length,
          itemBuilder: (context, index) {
            final wallpaper = viewModel.wallpapers[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FullImageScreen(imageUrl: wallpaper.imageUrl),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  wallpaper.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                  progress == null
                      ? child
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorBuilder: (context, error, stack) =>
                  const Icon(Icons.error, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;
  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Full Wallpaper")),
      body: Center(
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}

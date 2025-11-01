import 'package:flutter/material.dart';
import '../models/wallpaper.dart';
import '../repository/wallpaper_repository.dart';

class WallpaperViewModel extends ChangeNotifier {
  final WallpaperRepository repository = WallpaperRepository();

  List<Wallpaper> wallpapers = [];
  bool isLoading = false;
  String? error;

  Future<void> loadWallpapers() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      wallpapers = await repository.getWallpapers();
      if (wallpapers.isEmpty) {
        error = "No wallpapers found.";
      }
    } catch (e) {
      error = "Failed to load wallpapers: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}

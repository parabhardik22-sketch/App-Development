import '../models/wallpaper.dart';
import '../services/api_client.dart';

class WallpaperRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Wallpaper>> getWallpapers() async {
    return await apiClient.fetchWallpapers();
  }
}

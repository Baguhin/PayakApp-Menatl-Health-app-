import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:tangullo/ui/data/musicCatalog.dart';

class CatalogModel extends ChangeNotifier {
  /// Internal, private state of the catalog.
  final List<MusicCatalog> _items = [];

  /// An unmodifiable view of the items in the catalog.
  UnmodifiableListView<MusicCatalog> get items => UnmodifiableListView(_items);

  CatalogModel() {
    _fetchMusicCatalog();
  }

  /// Fetches the music catalog data.
  Future<void> _fetchMusicCatalog() async {
    // Using the music catalog provided by uamp sample.
    const catalogUrl = 'https://storage.googleapis.com/uamp/catalog.json';

    final dio = Dio();

    // Configure caching
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.refreshForceCache, // Change policy as needed
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 7),
    );

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    try {
      final response = await dio.get(
        catalogUrl,
        options: cacheOptions.toOptions(),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, parse the JSON.
        final data = response.data['music'] as List<dynamic>;
        final List<MusicCatalog> result =
            data.map((model) => MusicCatalog.fromJson(model)).toList();
        addAll(result);
      } else {
        throw Exception('Failed to load music catalog');
      }
    } catch (e) {
      debugPrint('Error fetching catalog: $e');
      throw Exception('Error fetching music catalog');
    }
  }

  /// Adds [item] to catalog.
  void add(MusicCatalog item) {
    _items.add(item);
    notifyListeners();
  }

  /// Adds [items] to catalog.
  void addAll(List<MusicCatalog> items) {
    _items.addAll(items);
    notifyListeners();
  }

  /// Removes all items from the catalog.
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'musicCatalog.g.dart';

@JsonSerializable()
class MusicCatalog {
  MusicCatalog({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.genre,
    required this.source,
    required this.image,
    required this.duration,
  });

  @JsonKey(required: true)
  final String id;

  final String title;
  final String album;
  final String artist;
  final String genre;
  final String source;
  final String image;
  final int duration;

  // Using code generation here (just cause).
  factory MusicCatalog.fromJson(Map<String, dynamic> json) =>
      _$MusicCatalogFromJson(json);
}

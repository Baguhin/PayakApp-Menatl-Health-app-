class Volunteer {
  final String id;
  final String name;
  final String profilePictureUrl;
  final String experience;
  final String qualifications; // New field
  final String specialty; // New field

  Volunteer({
    required this.id,
    required this.name,
    required this.profilePictureUrl,
    required this.experience,
    required this.qualifications,
    required this.specialty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'experience': experience,
      'qualifications': qualifications,
      'specialty': specialty,
    };
  }

  static Volunteer fromMap(Map<dynamic, dynamic> map) {
    return Volunteer(
      id: map['id'],
      name: map['name'],
      profilePictureUrl: map['profilePictureUrl'],
      experience: map['experience'],
      qualifications: map['qualifications'],
      specialty: map['specialty'],
    );
  }
}

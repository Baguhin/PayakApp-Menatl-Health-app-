class MentalHealthExpert {
  String id;
  String name;
  String position;
  String experience;
  String contact;
  String profilePictureUrl;

  MentalHealthExpert({
    this.id = '',
    required this.name,
    required this.position,
    required this.experience,
    required this.contact,
    required this.profilePictureUrl,
  });

  // Convert a MentalHealthExpert to a Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'experience': experience,
      'contact': contact,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Create a MentalHealthExpert from a Map.
  factory MentalHealthExpert.fromMap(Map<dynamic, dynamic> map) {
    return MentalHealthExpert(
      name: map['name'],
      position: map['position'],
      experience: map['experience'],
      contact: map['contact'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}

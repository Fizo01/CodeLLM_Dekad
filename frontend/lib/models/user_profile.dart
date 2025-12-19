class UserProfile {
  final ProfileData professional;
  final ProfileData personal;

  UserProfile({
    required this.professional,
    required this.personal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      professional: ProfileData.fromJson(json['professional']),
      personal: ProfileData.fromJson(json['personal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'professional': professional.toJson(),
      'personal': personal.toJson(),
    };
  }
}

class ProfileData {
  final String name;
  final String bio;
  final String role;
  final String? company;
  final List<String> links;
  final String? photoUrl;

  ProfileData({
    required this.name,
    required this.bio,
    required this.role,
    this.company,
    required this.links,
    this.photoUrl,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'],
      bio: json['bio'],
      role: json['role'],
      company: json['company'],
      links: List<String>.from(json['links'] ?? []),
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'role': role,
      'company': company,
      'links': links,
      'photoUrl': photoUrl,
    };
  }
}
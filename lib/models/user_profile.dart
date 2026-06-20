class UserProfile {
  final String uid;
  final String nama;
  final String email;
  final String instagram;
  final String photoUrl;

  UserProfile({
    required this.uid,
    required this.nama,
    required this.email,
    this.instagram = '',
    this.photoUrl = '',
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      instagram: map['instagram'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'instagram': instagram,
      'photoUrl': photoUrl,
    };
  }
}
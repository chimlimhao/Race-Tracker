class ParticipantDTO {
  final String bib;  
  final String name; 
  final String email; 
  
  ParticipantDTO({
    required this.bib,
    required this.name,
    required this.email,
  });

  factory ParticipantDTO.fromJson(Map<String, dynamic> json) {
    return ParticipantDTO(
      bib: json['BIB'],
      name: json['Name'],
      email: json['Email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BIB': bib,
      'Name': name,
      'Email': email,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Portfolio {
  final String id;
  final String briefDetails;
  final String companyName;
  final String companyLogo;
  final String previousProject;
  final int ratings;
  final String feedback;
  final String createdBy;
  final Timestamp? dateTimeCreated;

  Portfolio({
    required this.id,
    required this.briefDetails,
    required this.companyName,
    required this.companyLogo,
    required this.previousProject,
    required this.ratings,
    required this.feedback,
    required this.createdBy,
    this.dateTimeCreated,
  });

  factory Portfolio.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Portfolio(
      id: data!["id"],
      briefDetails: data["briefDetails"],
      companyName: data["companyName"],
      companyLogo: data["companyLogo"],
      previousProject: data["previousProject"],
      ratings: data["ratings"],
      feedback: data["feedback"],
      createdBy: data["createdBy"],
      dateTimeCreated: data["dateTimeCreated"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "briefDetails": briefDetails,
      "companyName": companyName,
      "companyLogo": companyLogo,
      "previousProject": previousProject,
      "ratings": ratings,
      "feedback": feedback,
      "createdBy": createdBy,
      "dateTimeCreated": dateTimeCreated,
    };
  }
}
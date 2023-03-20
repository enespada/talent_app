import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';

class SportsService extends ChangeNotifier {
  List<Sport> sports = [];

  Future<void> getSports() async {
    sports.clear();

    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore.collection('sports').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      sports.add(Sport.fromJson(doc.data()));
    }
  }
}

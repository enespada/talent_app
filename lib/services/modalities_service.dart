import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';

class ModalitiesService extends ChangeNotifier {
  List<Modality> modalities = [];

  Future<void> getModalitiesBySport(Sport sport) async {
    modalities.clear();

    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection('modalities')
        .where("sport", isEqualTo: sport.id)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      modalities.add(Modality.fromJson(doc.data()));
    }
  }
}

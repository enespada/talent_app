import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';

class ModalitiesService extends ChangeNotifier {
  List<Modality> modalities = [];

  Future getSports() async {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;

    final data = await fbFirestore.collection('modalities').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      modalities.add(Modality.fromJson(doc.data()));
    }
  }
}

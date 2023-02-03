import 'package:flutter/material.dart';
import 'package:talent_app/models/models.dart';

class EditProfileProvider extends ChangeNotifier {
  TextEditingController tecFullName = new TextEditingController();
  TextEditingController tecUserName = new TextEditingController();
  TextEditingController tecBio = new TextEditingController();
  TextEditingController tecPhone = new TextEditingController();
  Sport? sport;
  Modality? modality;

  EditProfileProvider() {}

  void takeUserData(
      UserApp userApp, List<Sport> sports, List<Modality> modalities) {
    tecFullName.text = userApp.fullName!;
    tecUserName.text = userApp.userName!;
    tecBio.text = userApp.bio!;
    tecPhone.text = userApp.phone!;

    for (Sport s in sports) {
      if (s.id == userApp.sport) {
        sport = s;
      }
    }

    for (Modality m in modalities) {
      if (m.id == userApp.sport) {
        modality = m;
      }
    }
  }

  bool isValid() {
    return false;
  }
}

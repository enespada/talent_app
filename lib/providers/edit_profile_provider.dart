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

  void initializeData(UserApp userApp) {
    tecFullName.text = userApp.fullName!;
    tecUserName.text = userApp.userName!;
    tecBio.text = userApp.bio!;
    tecPhone.text = userApp.phone!;

    // if (sport != null) this.sport = sport;
    // for (Sport s in sports) {
    //   if (s.id == userApp.sport) {
    //     sport = s;
    //   }
    // }

    // if (modality != null) this.modality = modality;
    // for (Modality m in modalities) {
    //   if (m.id == userApp.sport) {
    //     modality = m;
    //   }
    // }
  }

  bool isValid() {
    if (tecFullName.text.isEmpty) return false;
    if (tecFullName.text.isEmpty) return false;
    if (tecPhone.text.isEmpty) return false;
    if (tecPhone.text.substring(0, 1) != '+') return false;
    return true;
  }
}

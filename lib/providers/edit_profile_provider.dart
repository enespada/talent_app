import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';

class EditProfileProvider extends ChangeNotifier {
  TextEditingController tecFullName = new TextEditingController();
  TextEditingController tecUserName = new TextEditingController();
  TextEditingController tecBio = new TextEditingController();
  TextEditingController tecPhone = new TextEditingController();
  TextEditingController tecbirthdate = new TextEditingController();
  DateTime? birthdate;
  TextEditingController tecCountry = new TextEditingController();
  Sport? sport;
  Modality? modality;
  ImageProvider<Object>? initialProfileImage;

  EditProfileProvider() {}

  void initializeData(UserApp userApp) {
    tecFullName.text = userApp.fullName!;
    tecUserName.text = userApp.userName!;
    tecBio.text = userApp.bio!;
    tecPhone.text = userApp.phone!;
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(userApp.birthdate));
    if (userApp.birthdate != null) {
      birthdate = userApp.birthdate!;
      tecbirthdate.text =
          '${userApp.birthdate!.day}/${userApp.birthdate!.month}/${userApp.birthdate!.year}';
    } else {
      tecbirthdate.text = 'dd/mm/yyyy';
    }
    tecCountry.text = userApp.country!;

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
    if (int.tryParse(tecPhone.text.trim()) == null) {
      return false;
    }
    // if (tecPhone.text.substring(0, 1) != '+') return false;
    if (tecbirthdate.text.isEmpty) return false;
    if (tecCountry.text.isEmpty) return false;
    if (sport == null) return false;
    if (modality == null) return false;
    return true;
  }
}

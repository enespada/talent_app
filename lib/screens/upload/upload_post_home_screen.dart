import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:talent_app/screens/upload/upload_post_description_screen.dart';

import 'package:talent_app/style/styles.dart';
import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';

enum UploadHomeMenu { recent, report }

class UploadPostHomeScreen extends StatelessWidget {
  static const routeName = 'upload_post_home_screen';

  const UploadPostHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Lista de las imagenes (y/o videos?) seleccionadas, que inicialmente esta vacia
    List<AssetEntity> selectedImages = [];

    return UploadGalleryTemplate(
      title: Localization.of(context).string('upload_new_post'),
      selectedImages: selectedImages,
      // type: ButtonType.common,
      action: GestureDetector(
        onTap: () {
          if (selectedImages.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPostDescriptionScreen(
                  selectedImages: selectedImages,
                ),
              ),
            );
          }
        },
        child: const Icon(
          Icons.arrow_forward,
          color: AppColors.brandColor,
        ),
      ),
    );
  }
}

// ignore_for_file: unnecessary_new, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class UploadPostDescriptionScreen extends StatefulWidget {
  //Lista de las imagenes (y/o videos?) seleccionadas
  final List<AssetEntity> selectedImages;

  const UploadPostDescriptionScreen({
    Key? key,
    required this.selectedImages,
  }) : super(key: key);

  @override
  State<UploadPostDescriptionScreen> createState() =>
      _UploadPostDescriptionScreenState();
}

class _UploadPostDescriptionScreenState
    extends State<UploadPostDescriptionScreen> {
  //Controlador del texto de la descripcion
  final TextEditingController tecDescription = new TextEditingController();
  //Lista de ubicaciones incluidas en la publicacion
  final List<Prediction> places = [];
  final List<Chip> _ubications = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadPost(
      UserService userService, PostsService postsService) async {
    Post post = Post(
      description: tecDescription.text,
      // locations: [],
      files: [],
      timestamp: Timestamp.now(),
      sportType: userService.userApp!.sport,
      modality: userService.userApp!.modality,
    );
    post.userId = userService.userApp!.id;
    post.userApp = userService.userApp;

    final Post resultPost =
        await postsService.uploadPost(post, widget.selectedImages);
    userService.userPosts.insert(0, resultPost);
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: UploadTemplate(
        title: Localization.of(context).string('upload_new_post'),
        action: GestureDetector(
          onTap: () async {
            Util.showLoadingDialog(context: context);
            if (userService.userPosts.isEmpty) await userService.getPosts();
            await uploadPost(userService, postsService);
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userApp: userService.userApp!,
                  isLoguedUser: true,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Text(
                Localization.of(context).string('upload_description_publish'),
                style: AppThemes.darkTextTheme.bodyLarge!.copyWith(
                  fontSize: responsive.diagonalPercent(2),
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandColor,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //----------------------Carrusel de imagenes-------------------------
              CarouselImages(
                assetEntities: widget.selectedImages,
                images: null,
              ),

              //---------------------------Widgets---------------------------------
              Container(
                padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                width: responsive.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //-----------------------Descripcion---------------------------
                    TextField(
                      controller: tecDescription,
                      cursorColor: AppColors.greyscale2,
                      style: AppThemes.darkTextTheme.bodyLarge,
                      cursorWidth: 3,
                      decoration: InputDecoration(
                        hintText: Localization.of(context)
                            .string('upload_description_description'),
                        hintStyle: AppThemes.darkTextTheme.bodyLarge,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: responsive.heightPercent(3.5)),
                    const Divider(height: 4, color: AppColors.greyscale3),
                    SizedBox(height: responsive.heightPercent(3.5)),

                    //----------------------Ubicacion-----------------------------
                    // GestureDetector(
                    //   onTap: () {
                    //     _addLocation();
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 10),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           Localization.of(context)
                    //               .string('upload_description_add_ubication'),
                    //           style: AppStyles.darkTextTheme.bodyLarge,
                    //         ),
                    //         const Icon(
                    //           Icons.arrow_forward_ios,
                    //           color: AppColors.mediunLightGrey,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: responsive.heightPercent(1.5)),
                    // Wrap(
                    //   alignment: WrapAlignment.start,
                    //   spacing: 10,
                    //   children: _ubications,
                    // ),
                    // SizedBox(height: responsive.heightPercent(3.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addLocation() async {
    String language = "es";
    if (Localization.of(context).locale ==
        const Locale.fromSubtags(languageCode: "es")) {
      language = "es";
    }

    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: NetworkEndpoints.googleAPIKey,
      onError: (PlacesAutocompleteResponse response) {},
      mode: Mode.fullscreen,
      decoration: InputDecoration(
        hintText: Localization.of(context).string('messages_home_search_hint'),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        // fillColor: AppColors.blueColor,
      ),
      types: ['locality'],
      strictbounds: false,
      language: language,
      components: [Component(Component.country, "es")],
      // components: [Component(Component.country, "es")],
    );

    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: NetworkEndpoints.googleAPIKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      //Incluimos la nueva ubicacion en la lista de ubicaciones
      if (p.description != null) {
        bool repeated = false;
        //Antes de incluir la nueva ubicacion comprobamos si ya esta incluida
        for (Prediction place in places) {
          if (place.placeId == p.placeId) {
            repeated = true;
            return;
          }
        }
        //Si la ubicacion no esta la incluimos
        if (!repeated) {
          //Incluimos el nombre completo de la ubicacion en la lista de nombres de ubicaciones
          places.add(p);
          String chipTitle = (p.description!.contains(','))
              ? p.description!.split(',').first
              : p.description!;
          //Incluimos la ubicacion en los chips
          _ubications.add(Chip(
            label: Text(chipTitle),
            deleteIcon: const Icon(Icons.close),
            backgroundColor: AppColors.greyscale2,
            shadowColor: Colors.transparent,
            onDeleted: () {
              _ubications.removeWhere((element) {
                return element.label.toString().split('\"')[1].trim() ==
                    chipTitle.trim();
              });
              places.removeWhere((place) {
                String compare = (place.description!.contains(','))
                    ? place.description!.split(',').first
                    : place.description!;
                return compare == chipTitle.trim();
              });
              setState(() {});
            },
          ));
        }
      }
      _places.dispose();
    }
  }
}

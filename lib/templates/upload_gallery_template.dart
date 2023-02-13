// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:talent_app/style/styles.dart';
import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';

enum UploadGalleryTemplateMenu { recent, report }

enum TypeFiles { Common, Images, Videos }

class UploadGalleryTemplate extends StatefulWidget {
  //--------------------------------Atributos----------------------------------
  final String title;
  final Widget action;
  final List<AssetEntity> selectedImages;

  //--------------------------------Constructor--------------------------------
  const UploadGalleryTemplate({
    Key? key,
    required this.title,
    required this.action,
    required this.selectedImages,
  }) : super(key: key);

  @override
  State<UploadGalleryTemplate> createState() => _UploadGalleryTemplateState();
}

class _UploadGalleryTemplateState extends State<UploadGalleryTemplate> {
  //--------------------------------Atributos----------------------------------
  //Lista de albumes del dispositivo
  List<AssetPathEntity> albums = [];
  //Indice del album actual en la lista de albumes (?)
  int indexAlbum = 0;
  //Nombre del album a mostrar
  String titleAlbum = "Recent";
  //Variable para controlar si se quieren mostrar imagenes, videos o ambos
  TypeFiles typeFiles = TypeFiles.Common;
  //Lista de todas las imagenes (o videos?) a mostrar
  List<AssetEntity> images = [];
  //Lista de las imagenes (y/o videos?) seleccionadas
  List<AssetEntity> selectedImages = [];
  //Pagina a mostrar del album
  int page = 0;
  //Ultima imagen seleccionada, que debe ser null si no hay ninguna seleccionada
  // Image? currentImage;
  AssetEntityImage? currentImage;

  //----------------------------------Metodos-----------------------------------
  RequestType getRequestType() {
    RequestType requestType = RequestType.common;
    switch (typeFiles) {
      case TypeFiles.Common:
        requestType = RequestType.common;
        break;
      case TypeFiles.Images:
        requestType = RequestType.image;
        break;
      case TypeFiles.Videos:
        requestType = RequestType.video;
        break;
    }
    return requestType;
  }

  //Metodo que recupera los albumes del dispositivo
  Future<void> getAlbums(RequestType type, int indexAlbum, int page) async {
    this.albums = await PhotoManager.getAssetPathList(
      type: type,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      ),
    );

    if (albums.isNotEmpty) {
      images = await albums[indexAlbum].getAssetListPaged(
        page: page,
        size: 20,
      );
      titleAlbum = albums[indexAlbum].name;
    } else {
      images = [];
    }

    setState(() {});
  }

  void listaAlbum() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(ignoreSize: true),
          ),
        ),
      );

      if (albums.isNotEmpty) {
        images = await albums[indexAlbum].getAssetListPaged(
          page: page,
          size: 20,
        );
        titleAlbum = albums[indexAlbum].name;
      } else {
        images = [];
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    listaAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return UploadTemplate(
      title: widget.title,
      action: widget.action,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //-------------------------Foto seleccionada--------------------------
          Container(
            margin: EdgeInsets.only(bottom: responsive.heightPercent(5)),
            height: responsive.heightPercent(45),
            child: (currentImage == null)
                ? Container(color: Colors.grey.withOpacity(0.3))
                : currentImage,
          ),

          //------------------Recientes (albumes) y boton-------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //--------------------Recientes (albumes)-------------------------
              Container(
                margin: EdgeInsets.only(left: responsive.widthPercent(3)),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: responsive.heightPercent(4),
                width: responsive.widthPercent(50),
                decoration: BoxDecoration(
                  color: AppColors.greyscale3,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: PopupMenuButton<UploadGalleryTemplateMenu>(
                  position: PopupMenuPosition.under,
                  color: AppColors.greyscale3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  itemBuilder: (context) => [
                    ...albums.map(
                      (AssetPathEntity album) =>
                          PopupMenuItem<UploadGalleryTemplateMenu>(
                        onTap: () async {
                          final PermissionState ps =
                              await PhotoManager.requestPermissionExtend();
                          if (ps.isAuth) {
                            albums = await PhotoManager.getAssetPathList(
                              type: getRequestType(),
                              filterOption: FilterOptionGroup(
                                imageOption: const FilterOption(
                                  sizeConstraint: SizeConstraint(
                                    ignoreSize: true,
                                  ),
                                ),
                              ),
                            );
                            indexAlbum = albums.indexOf(album);
                            images = await albums[albums.indexOf(album)]
                                .getAssetListPaged(
                              page: page,
                              size: 20,
                            );
                            titleAlbum = album.name;

                            setState(() {});
                          }
                        },
                        value: UploadGalleryTemplateMenu.recent,
                        child: Text(
                          album.name,
                          style: AppStyles.ligthTextTheme.bodyLarge?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          titleAlbum,
                          style: AppStyles.ligthTextTheme.bodyLarge?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),

              //---------------------------Boton-------------------------------
              // Container(
              //   margin: EdgeInsets.only(right: responsive.widthPercent(3)),
              //   child: IconButton(
              //     style: IconButton.styleFrom(
              //       backgroundColor: AppColors.whiteColor,
              //     ),
              //     onPressed: () {
              //       page++;
              //       setState(() {});
              //     },
              //     icon: SvgPicture.asset(
              //       'assets/images/selectMultiply.svg',
              //       height: responsive.heightPercent(3),
              //       color: AppColors.blackColor,
              //     ),
              //   ),
              // ),
            ],
          ),

          //------------------------GridView con fotos---------------------------
          Container(
            margin: EdgeInsets.only(
              bottom: responsive.heightPercent(15),
              top: responsive.heightPercent(4),
              left: responsive.widthPercent(3),
              right: responsive.widthPercent(3),
            ),
            child: GridView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: responsive.widthPercent(2),
                mainAxisSpacing: responsive.widthPercent(2),
              ),
              children: [
                //----------------------------Camara-----------------------------------
                if (typeFiles != TypeFiles.Videos)
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);

                      //Guardamos la imagen tomada con la camara en la galeria
                      if (photo != null) {
                        await GallerySaver.saveImage(photo.path);
                      }
                      //Para que se vuelvan a coger las imagenes que se muestran del album hacemos
                      listaAlbum();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.darkGrey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: responsive.heightPercent(10),
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),

                //------------------------------Fotos-----------------------------------
                ...images.map((AssetEntity image) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: (selectedImages.contains(image))
                          ? Border.all(color: AppColors.yellowColor, width: 2)
                          : Border.all(),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedImages.contains(image)) {
                          selectedImages.remove(image);
                        } else {
                          selectedImages.add(image);
                        }
                        if (typeFiles == TypeFiles.Common ||
                            typeFiles == TypeFiles.Images) {
                          if (selectedImages.isNotEmpty) {
                            currentImage = AssetEntityImage(
                              selectedImages[selectedImages.length - 1],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(800),
                              loadingBuilder:
                                  (context, child, loadingProgress) => child,
                            );
                          } else {
                            currentImage = null;
                          }
                          setState(() {});
                        } else if (typeFiles == TypeFiles.Videos) {
                          if (selectedImages.isNotEmpty) {
                            currentImage = AssetEntityImage(
                              selectedImages[selectedImages.length - 1],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(800),
                              loadingBuilder:
                                  (context, child, loadingProgress) => child,
                            );
                          } else {
                            currentImage = null;
                          }
                          setState(() {});
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AssetEntityImage(
                          image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) =>
                              child,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),

      //------------------------todos, imagenes, videos---------------------------
      bottomNavigatorBar: _CustomButtonNavigator(
        onTapAll: () async {
          typeFiles = TypeFiles.Common;
          final PermissionState ps =
              await PhotoManager.requestPermissionExtend();
          if (ps.isAuth) {
            await getAlbums(RequestType.common, indexAlbum, page);
          }
        },
        onTapImages: () async {
          typeFiles = TypeFiles.Images;
          final PermissionState ps =
              await PhotoManager.requestPermissionExtend();
          if (ps.isAuth) {
            await getAlbums(RequestType.image, indexAlbum, page);
            setState(() {});
          }
        },
        onTapVideos: () async {
          typeFiles = TypeFiles.Videos;
          final PermissionState ps =
              await PhotoManager.requestPermissionExtend();
          if (ps.isAuth) {
            await getAlbums(RequestType.video, indexAlbum, page);
            setState(() {});
          }
        },
        typeFiles: typeFiles,
        albums: albums,
        images: images,
        indexAlbum: 0,
        page: 0,
      ),
    );
  }

  // Future<AssetEntityImage> convertFileToImage(AssetEntity assetEntity) async {
  //   return AssetEntityImage(
  //     assetEntity,
  //     fit: BoxFit.cover,
  //     width: double.infinity,
  //     isOriginal: false,
  //     thumbnailSize: const ThumbnailSize.square(800),
  //     loadingBuilder: (context, child, loadingProgress) => child,
  //   );
  // }
}

class _CustomButtonNavigator extends StatefulWidget {
  TypeFiles typeFiles;
  List<AssetPathEntity>? albums;
  List<AssetEntity>? images;
  int page;
  int indexAlbum;
  final void Function()? onTapAll;
  final void Function()? onTapImages;
  final void Function()? onTapVideos;

  _CustomButtonNavigator({
    Key? key,
    this.typeFiles = TypeFiles.Common,
    required this.albums,
    this.images,
    this.page = 0,
    this.indexAlbum = 0,
    required this.onTapAll,
    required this.onTapImages,
    required this.onTapVideos,
  }) : super(key: key);

  @override
  State<_CustomButtonNavigator> createState() => _CustomButtonNavigatorState();
}

class _CustomButtonNavigatorState extends State<_CustomButtonNavigator> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: responsive.widthPercent(3),
        right: responsive.widthPercent(3),
        top: responsive.heightPercent(2),
        bottom: responsive.heightPercent(5),
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: widget.onTapAll,
            child: Text(
              'todos',
              style: TextStyle(
                color: (widget.typeFiles == TypeFiles.Common)
                    ? AppColors.brandColor
                    : AppColors.coinGrey,
                fontWeight: (widget.typeFiles == TypeFiles.Common)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: responsive.widthPercent(4),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTapImages,
            child: Text(
              'imágenes',
              style: TextStyle(
                color: (widget.typeFiles == TypeFiles.Images)
                    ? AppColors.brandColor
                    : AppColors.coinGrey,
                fontWeight: (widget.typeFiles == TypeFiles.Images)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: responsive.widthPercent(4),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTapVideos,
            child: Text(
              'vídeos',
              style: TextStyle(
                color: (widget.typeFiles == TypeFiles.Videos)
                    ? AppColors.brandColor
                    : AppColors.coinGrey,
                fontWeight: (widget.typeFiles == TypeFiles.Videos)
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: responsive.widthPercent(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

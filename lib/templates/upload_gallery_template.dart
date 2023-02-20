// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:talent_app/style/styles.dart';
import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';

enum UploadGalleryTemplateMenu { recent, report }

class UploadGalleryTemplate extends StatefulWidget {
  //--------------------------------Atributos----------------------------------
  final String title;
  Widget? action;
  final List<AssetEntity> selectedImages;

  //--------------------------------Constructor--------------------------------
  UploadGalleryTemplate({
    Key? key,
    required this.title,
    this.action,
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
  RequestType requestType = RequestType.common;
  //Lista de todas las imagenes (o videos?) a mostrar
  List<AssetEntity> images = [];
  //Lista de las imagenes (y/o videos?) seleccionadas
  List<AssetEntity> selectedImages = [];
  //Pagina a mostrar del album
  int page = 0;
  //Ultima imagen seleccionada, que debe ser null si no hay ninguna seleccionada
  // Image? currentImage;
  AssetEntityImage? currentImage;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  //----------------------------------Metodos-----------------------------------

  // Future<void> getAlbums(RequestType type) async {
  //   //Obtenemos los albumes del dispositivo
  //   this.albums = await PhotoManager.getAssetPathList(
  //     type: type,
  //     filterOption: FilterOptionGroup(
  //       imageOption: const FilterOption(
  //         sizeConstraint: SizeConstraint(ignoreSize: true),
  //       ),
  //     ),
  //   );

  //   if (this.albums.isNotEmpty) {
  //     this.images = await this.albums[indexAlbum].getAssetListPaged(
  //           page: page,
  //           size: 20,
  //         );
  //     this.titleAlbum = this.albums[indexAlbum].name;
  //   } else {
  //     this.images = [];
  //   }
  //   setState(() {});
  // }

  //Metodo que recupera los albumes del dispositivo
  Future<void> bringAlbums() async {
    this.albums.clear();
    this.indexAlbum = 0;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      this.albums = await PhotoManager.getAssetPathList(
        type: requestType,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(ignoreSize: true),
          ),
        ),
      );
      if (this.albums.isNotEmpty) {
        this.titleAlbum = this.albums[this.indexAlbum].name;
      }
      this.images.clear();
      this.page = 0;
      await bringAlbumPageFiles();
      setState(() {});
    }
  }

  //Metodo que guarda en images los archivos del album actual (this.albums[this.indexAlbum])
  //de la pagina page
  Future<void> bringAlbumPageFiles() async {
    if (this.albums.isNotEmpty) {
      this.images += await this.albums[this.indexAlbum].getAssetListPaged(
            page: page,
            size: 20,
          );
      // this.titleAlbum = this.albums[this.indexAlbum].name;
    }
    // else {
    //   this.images = [];
    // }
  }

  @override
  void initState() {
    this.selectedImages = widget.selectedImages;
    bringAlbums();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        fetchPhotos();
      }
    });
    super.initState();
  }

  void fetchPhotos() async {
    if (this.isLoading) return;
    this.isLoading = true;
    setState(() {});
    this.page++;
    print(scrollController.position);
    await bringAlbumPageFiles();
    await Future.delayed(const Duration(seconds: 3));
    this.isLoading = false;
    setState(() {});

    // if (scrollController.position.pixels + 100 <=
    //     scrollController.position.maxScrollExtent) return;
    // scrollController.animateTo(
    //   scrollController.position.pixels + 120,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return UploadTemplate(
      title: widget.title,
      action: widget.action ?? const Text('data'),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //-------------------------Foto seleccionada--------------------------
                Container(
                  margin: EdgeInsets.only(bottom: responsive.heightPercent(5)),
                  height: responsive.heightPercent(40),
                  child: (this.currentImage == null)
                      ? Container(color: Colors.grey.withOpacity(0.3))
                      : this.currentImage,
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        itemBuilder: (context) => [
                          ...albums.map(
                            (AssetPathEntity album) =>
                                PopupMenuItem<UploadGalleryTemplateMenu>(
                              onTap: () async {
                                // final PermissionState ps =
                                //     await PhotoManager.requestPermissionExtend();
                                // if (ps.isAuth) {
                                //   albums = await PhotoManager.getAssetPathList(
                                //     type: requestType,
                                //     filterOption: FilterOptionGroup(
                                //       imageOption: const FilterOption(
                                //         sizeConstraint: SizeConstraint(
                                //           ignoreSize: true,
                                //         ),
                                //       ),
                                //     ),
                                //   );
                                //   this.indexAlbum = this.albums.indexOf(album);
                                //   images = await albums[albums.indexOf(album)]
                                //       .getAssetListPaged(
                                //     page: page,
                                //     size: 20,
                                //   );
                                //   titleAlbum = album.name;

                                //   setState(() {});
                                // }
                                this.indexAlbum = this.albums.indexOf(album);
                                this.titleAlbum =
                                    this.albums[this.indexAlbum].name;
                                this.images.clear();
                                this.page = 0;
                                await bringAlbumPageFiles();
                                setState(() {});
                              },
                              value: UploadGalleryTemplateMenu.recent,
                              child: Text(
                                album.name,
                                style: AppStyles.ligthTextTheme.bodyLarge!
                                    .copyWith(
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
                                this.titleAlbum,
                                style: AppStyles.ligthTextTheme.bodyLarge!
                                    .copyWith(
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
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: responsive.widthPercent(2),
                      mainAxisSpacing: responsive.widthPercent(2),
                    ),
                    children: [
                      //----------------------------Camara-----------------------------------
                      if (requestType != RequestType.video)
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera);

                            //Guardamos la imagen tomada con la camara en la galeria
                            if (photo != null) {
                              await GallerySaver.saveImage(photo.path);
                            }
                            //Para que se vuelvan a coger las imagenes que se muestran del album hacemos
                            // bringAlbums();
                            this.page = 0;
                            await bringAlbumPageFiles();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.greyscale5,
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
                                ? Border.all(
                                    color: AppColors.yellowColor, width: 2)
                                : Border.all(),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              if (this.selectedImages.contains(image)) {
                                this.selectedImages.remove(image);
                              } else {
                                this.selectedImages.add(image);
                              }
                              if (this.requestType == RequestType.common ||
                                  this.requestType == RequestType.image) {
                                if (this.selectedImages.isNotEmpty) {
                                  this.currentImage = AssetEntityImage(
                                    selectedImages[selectedImages.length - 1],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    isOriginal: false,
                                    thumbnailSize:
                                        const ThumbnailSize.square(800),
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            child,
                                  );
                                } else {
                                  this.currentImage = null;
                                }
                                setState(() {});
                              } else if (requestType == RequestType.video) {
                                if (this.selectedImages.isNotEmpty) {
                                  this.currentImage = AssetEntityImage(
                                    this.selectedImages[
                                        this.selectedImages.length - 1],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    isOriginal: false,
                                    thumbnailSize:
                                        const ThumbnailSize.square(800),
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            child,
                                  );
                                } else {
                                  this.currentImage = null;
                                }
                                setState(() {});
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AssetEntityImage(
                                image,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) => child,
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
          ),
          if (this.isLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                ),
              ),
            ),
        ],
      ),

      //------------------------todos, imagenes, videos---------------------------
      bottomNavigatorBar: _AllImagesVideosSelector(
        onTapAll: () async {
          this.requestType = RequestType.common;
          // final PermissionState ps =
          //     await PhotoManager.requestPermissionExtend();
          // if (ps.isAuth) {
          //   await getAlbums(RequestType.common);
          // }
          await bringAlbums();
        },
        onTapImages: () async {
          this.requestType = RequestType.image;
          // final PermissionState ps =
          //     await PhotoManager.requestPermissionExtend();
          // if (ps.isAuth) {
          //   await getAlbums(RequestType.image);
          //   setState(() {});
          // }
          await bringAlbums();
        },
        onTapVideos: () async {
          this.requestType = RequestType.video;
          // final PermissionState ps =
          //     await PhotoManager.requestPermissionExtend();
          // if (ps.isAuth) {
          //   await getAlbums(RequestType.video);
          //   setState(() {});
          // }
          await bringAlbums();
        },
        requestType: this.requestType,
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

class _AllImagesVideosSelector extends StatefulWidget {
  RequestType requestType;
  final void Function()? onTapAll;
  final void Function()? onTapImages;
  final void Function()? onTapVideos;

  _AllImagesVideosSelector({
    Key? key,
    this.requestType = RequestType.common,
    required this.onTapAll,
    required this.onTapImages,
    required this.onTapVideos,
  }) : super(key: key);

  @override
  State<_AllImagesVideosSelector> createState() =>
      _AllImagesVideosSelectorState();
}

class _AllImagesVideosSelectorState extends State<_AllImagesVideosSelector> {
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
        color: AppColors.greyscale5,
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
              style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2),
                fontWeight: (widget.requestType == RequestType.common)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (widget.requestType == RequestType.common)
                    ? AppColors.blueColor
                    : AppColors.greyscale1,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTapImages,
            child: Text(
              'imágenes',
              style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2),
                fontWeight: (widget.requestType == RequestType.image)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (widget.requestType == RequestType.image)
                    ? AppColors.blueColor
                    : AppColors.greyscale1,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTapVideos,
            child: Text(
              'vídeos',
              style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2),
                fontWeight: (widget.requestType == RequestType.video)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (widget.requestType == RequestType.video)
                    ? AppColors.blueColor
                    : AppColors.greyscale1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

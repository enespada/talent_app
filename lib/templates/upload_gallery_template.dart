// // ignore_for_file: unnecessary_this

// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:talent_app/style/app_colors.dart';
// import 'package:talent_app/utils/responsive.dart';

// enum UploadGalleryTemplateMenu { recent, report }

// class UploadGalleryTemplate extends StatefulWidget {
//   //--------------------------------Atributos----------------------------------
//   final String title;
//   final Widget action;
//   final List<AssetEntity> selectedImages;

//   //--------------------------------Constructor--------------------------------
//   const UploadGalleryTemplate({
//     Key? key,
//     required this.title,
//     required this.action,
//     required this.selectedImages,
//   }) : super(key: key);

//   @override
//   State<UploadGalleryTemplate> createState() => _UploadGalleryTemplateState();
// }

// class _UploadGalleryTemplateState extends State<UploadGalleryTemplate> {
//   //--------------------------------Atributos----------------------------------
//   //Variable para controlar si se quieren mostrar imagenes, videos o ambos
//   String selectedType = "todos";
//   //Lista de todas las imagenes (o videos?) a mostrar
//   List<AssetEntity> images = [];
//   //Lista de las imagenes (y/o videos?) seleccionadas
//   List<AssetEntity> selectedImages = [];
//   //Lista de albumes
//   List<AssetPathEntity> albums = [];
//   int indexAlbum = 0;
//   //Nombre del album a mostrar
//   String titleAlbum = "Recent";
//   //Pagina a mostrar del album
//   int page = 0;
//   //Ultima imagen seleccionada, que debe ser null si no hay ninguna seleccionada
//   // Image? currentImage;
//   AssetEntityImage? currentImage;

//   //----------------------------------Metodos-----------------------------------
//   RequestType getRequestType() {
//     RequestType requestType = RequestType.common;
//     switch (selectedType) {
//       case 'todos':
//         requestType = RequestType.common;
//         break;
//       case 'imágenes':
//         requestType = RequestType.image;
//         break;
//       case 'vídeos':
//         requestType = RequestType.video;
//         break;
//     }
//     return requestType;
//   }

//   //Metodo que recupera los albumes del dispositivo
//   Future<void> getAlbums(RequestType type, int indexAlbum, int page) async {
//     this.albums = await PhotoManager.getAssetPathList(
//       type: type,
//       filterOption: FilterOptionGroup(
//         imageOption: const FilterOption(
//           sizeConstraint: SizeConstraint(ignoreSize: true),
//         ),
//       ),
//     );

//     if (albums.isNotEmpty) {
//       images = await albums[indexAlbum].getAssetListPaged(
//         page: page,
//         size: 20,
//       );
//       titleAlbum = albums[indexAlbum].name;
//     } else {
//       images = [];
//     }

//     setState(() {});
//   }

//   void listaAlbum() async {
//     final PermissionState ps = await PhotoManager.requestPermissionExtend();
//     if (ps.isAuth) {
//       albums = await PhotoManager.getAssetPathList(
//         type: RequestType.common,
//         filterOption: FilterOptionGroup(
//           imageOption: const FilterOption(
//             sizeConstraint: SizeConstraint(ignoreSize: true),
//           ),
//         ),
//       );
//       if (albums.isNotEmpty) {
//         images = await albums[indexAlbum].getAssetListPaged(
//           page: page,
//           size: 20,
//         );

//         titleAlbum = albums[indexAlbum].name;
//       } else {
//         images = [];
//       }
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     listaAlbum();
//     super.initState();
//   }

//   // Future<AssetEntityImage> convertFileToImage(AssetEntity assetEntity) async {
//   //   return AssetEntityImage(
//   //     assetEntity,
//   //     fit: BoxFit.cover,
//   //     width: double.infinity,
//   //     isOriginal: false,
//   //     thumbnailSize: const ThumbnailSize.square(800),
//   //     loadingBuilder: (context, child, loadingProgress) => child,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);

//     return UploadTemplate(
//       title: widget.title,
//       action: widget.action,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //-------------------------Foto seleccionada--------------------------
//           Container(
//             margin: EdgeInsets.only(bottom: responsive.heightPercent(5)),
//             height: responsive.heightPercent(45),
//             child: (currentImage == null)
//                 ? Container(color: Colors.grey.withOpacity(0.3))
//                 : currentImage,
//           ),

//           //------------------Recientes (albumes) y boton-------------------------
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               //--------------------Recientes (albumes)-------------------------
//               Container(
//                 margin: EdgeInsets.only(left: responsive.widthPercent(3)),
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 height: responsive.heightPercent(4),
//                 width: responsive.widthPercent(50),
//                 decoration: BoxDecoration(
//                   color: AppColors.darkGrey,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: PopupMenuButton<UploadGalleryTemplateMenu>(
//                   position: PopupMenuPosition.under,
//                   color: AppColors.darkGrey,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(15),
//                     ),
//                   ),
//                   itemBuilder: (context) => [
//                     ...albums.map(
//                       (AssetPathEntity album) =>
//                           PopupMenuItem<UploadGalleryTemplateMenu>(
//                         onTap: () async {
//                           final PermissionState ps =
//                               await PhotoManager.requestPermissionExtend();
//                           if (ps.isAuth) {
//                             albums = await PhotoManager.getAssetPathList(
//                               type: getRequestType(),
//                               filterOption: FilterOptionGroup(
//                                 imageOption: const FilterOption(
//                                   sizeConstraint:
//                                       SizeConstraint(ignoreSize: true),
//                                 ),
//                               ),
//                             );
//                             indexAlbum = albums.indexOf(album);
//                             images = await albums[albums.indexOf(album)]
//                                 .getAssetListPaged(
//                               page: page,
//                               size: 20,
//                             );
//                             titleAlbum = album.name;

//                             setState(() {});
//                           }
//                         },
//                         value: UploadGalleryTemplateMenu.recent,
//                         child: Text(
//                           album.name,
//                           // style: AppStyles.ligthTextTheme.bodyLarge?.copyWith(
//                           //   color: AppColors.whiteColor,
//                           // ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           titleAlbum,
//                           // style: AppStyles.ligthTextTheme.bodyLarge?.copyWith(
//                           //   color: AppColors.whiteColor,
//                           // ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         color: AppColors.whiteColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               //---------------------------Boton-------------------------------
//               // Container(
//               //   margin: EdgeInsets.only(right: responsive.widthPercent(3)),
//               //   child: IconButton(
//               //     style: IconButton.styleFrom(
//               //       backgroundColor: AppColors.whiteColor,
//               //     ),
//               //     onPressed: () {
//               //       page++;
//               //       setState(() {});
//               //     },
//               //     icon: SvgPicture.asset(
//               //       'assets/images/selectMultiply.svg',
//               //       height: responsive.heightPercent(3),
//               //       color: AppColors.blackColor,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),

//           //------------------------GridView con fotos---------------------------
//           Container(
//             margin: EdgeInsets.only(
//               bottom: responsive.heightPercent(15),
//               top: responsive.heightPercent(4),
//               left: responsive.widthPercent(3),
//               right: responsive.widthPercent(3),
//             ),
//             child: UploadAllPhotos(
//               images: images,
//               selectedImages: selectedImages,
//               devuelveImagenes: () async {
//                 if (selectedImages.isNotEmpty) {
//                   // File? file =
//                   //     await selectedImages[selectedImages.length - 1].file;
//                   // currentImage = await convertFileToImage(file!);
//                   // currentImage = await convertFileToImage(selectedImages[selectedImages.length - 1]);
//                   currentImage = AssetEntityImage(
//                     selectedImages[selectedImages.length - 1],
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     isOriginal: false,
//                     thumbnailSize: const ThumbnailSize.square(800),
//                     loadingBuilder: (context, child, loadingProgress) => child,
//                   );
//                 } else {
//                   currentImage = null;
//                 }
//                 widget.selectedImages.clear();
//                 widget.selectedImages.addAll(selectedImages);
//                 setState(() {});
//               },
//               setStatePadre: () {
//                 setState(() {
//                   //Para que se vuelvan a coger las imagenes que se muestran del album hacemos
//                   listaAlbum();
//                 });
//               },
//               selectedType: selectedType,
//             ),
//           ),
//         ],
//       ),

//       //------------------------todos, imagenes, videos---------------------------
//       bottomNavigatorBar: CustomButtonNavigator(
//         onTapAll: () async {
//           selectedType = 'todos';
//           final PermissionState ps =
//               await PhotoManager.requestPermissionExtend();
//           if (ps.isAuth) {
//             await getAlbums(RequestType.common, indexAlbum, page);
//           }
//         },
//         onTapImages: () async {
//           selectedType = 'imágenes';
//           final PermissionState ps =
//               await PhotoManager.requestPermissionExtend();
//           if (ps.isAuth) {
//             await getAlbums(RequestType.image, indexAlbum, page);
//             setState(() {});
//           }
//         },
//         onTapVideos: () async {
//           selectedType = 'vídeos';
//           final PermissionState ps =
//               await PhotoManager.requestPermissionExtend();
//           if (ps.isAuth) {
//             await getAlbums(RequestType.video, indexAlbum, page);
//             setState(() {});
//           }
//         },
//         selectedType: selectedType,
//         albums: albums,
//         images: images,
//         indexAlbum: 0,
//         page: 0,
//       ),
//     );
//   }
// }

// class UploadTemplate extends StatefulWidget {
//   final String title;
//   final Widget action;
//   final Widget body;
//   final Widget? bottomNavigatorBar;

//   const UploadTemplate({
//     Key? key,
//     required this.title,
//     required this.action,
//     required this.body,
//     this.bottomNavigatorBar,
//   }) : super(key: key);

//   @override
//   State<UploadTemplate> createState() => _UploadTemplateState();
// }

// class _UploadTemplateState extends State<UploadTemplate> {
//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.blackColor,
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: AppColors.brandColor,
//           ),
//         ),
//         title: Text(
//           widget.title,
//           style: TextStyle(
//             color: AppColors.whiteColor,
//             fontWeight: FontWeight.bold,
//             fontSize: responsive.widthPercent(6),
//           ),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.only(right: responsive.widthPercent(3)),
//             child: widget.action,
//           )
//         ],
//       ),

//       //--------------------------------body----------------------------------
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               color: AppColors.blackColor,
//             ),
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: widget.body,
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: widget.bottomNavigatorBar ?? Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomButtonNavigator extends StatefulWidget {
//   CustomButtonNavigator({
//     Key? key,
//     this.selectedType = 'todos',
//     required this.albums,
//     this.images,
//     this.page = 0,
//     this.indexAlbum = 0,
//     required this.onTapAll,
//     required this.onTapImages,
//     required this.onTapVideos,
//   }) : super(key: key);

//   String selectedType;
//   List<AssetPathEntity>? albums;
//   List<AssetEntity>? images;
//   int page;
//   int indexAlbum;
//   final void Function()? onTapAll;
//   final void Function()? onTapImages;
//   final void Function()? onTapVideos;

//   @override
//   State<CustomButtonNavigator> createState() => _CustomButtonNavigatorState();
// }

// class _CustomButtonNavigatorState extends State<CustomButtonNavigator> {
//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);

//     return Container(
//       padding: EdgeInsets.only(
//           left: responsive.widthPercent(3),
//           right: responsive.widthPercent(3),
//           top: responsive.heightPercent(2),
//           bottom: responsive.heightPercent(5)),
//       decoration: const BoxDecoration(
//           color: AppColors.darkGrey,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           GestureDetector(
//             onTap: widget.onTapAll,
//             child: Text(
//               'todos',
//               style: TextStyle(
//                   color: (widget.selectedType == 'todos')
//                       ? AppColors.brandColor
//                       : AppColors.coinGrey,
//                   fontWeight: (widget.selectedType == 'todos')
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                   fontSize: responsive.widthPercent(4)),
//             ),
//           ),
//           GestureDetector(
//             onTap: widget.onTapImages,
//             child: Text(
//               'imágenes',
//               style: TextStyle(
//                   color: (widget.selectedType == 'imágenes')
//                       ? AppColors.brandColor
//                       : AppColors.coinGrey,
//                   fontWeight: (widget.selectedType == 'imágenes')
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                   fontSize: responsive.widthPercent(4)),
//             ),
//           ),
//           GestureDetector(
//               onTap: widget.onTapVideos,
//               child: Text(
//                 'vídeos',
//                 style: TextStyle(
//                     color: (widget.selectedType == 'vídeos')
//                         ? AppColors.brandColor
//                         : AppColors.coinGrey,
//                     fontWeight: (widget.selectedType == 'vídeos')
//                         ? FontWeight.bold
//                         : FontWeight.normal,
//                     fontSize: responsive.widthPercent(4)),
//               )),
//         ],
//       ),
//     );
//   }
// }

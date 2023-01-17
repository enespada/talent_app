// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:flutter_mvvm/view/common/resources/app_colors.dart';
// import 'package:talent_app/app_colors.dart';
// import '../../model/user.dart';
// import '../base/resource_state.dart';
// import '../di/app_modules.dart';
// import '../viewmodel/viewmodels.dart';
// import 'edit_picture_button.dart';
// import 'error/error_overlay.dart';
// import 'loading/loading_overlay.dart';

// class Avatar extends StatefulWidget {
//   final double size;
//   final UserApp? user;

//   const Avatar({
//     Key? key,
//     required this.size,
//     this.user,
//   }) : super(key: key);

//   @override
//   State<Avatar> createState() => _AvatarState();
// }

// class _AvatarState extends State<Avatar> {
//   final _viewModel = inject<AuthViewModel>();
//   XFile? _file;

//   @override
//   void initState() {
//     super.initState();
//     _viewModel.uploadImgState.stream.listen((state) {
//       switch (state.status) {
//         case Status.LOADING:
//           LoadingOverlay.of(context).show();
//           break;
//         case Status.COMPLETED:
//           LoadingOverlay.of(context).hide();
//           widget.user?.imgSrc = "profile.png";
//           _viewModel.registerUser(widget.user!);
//           break;
//         case Status.ERROR:
//           LoadingOverlay.of(context).hide();
//           ErrorOverlay.of(context).show(state.error);
//           break;
//         default:
//           LoadingOverlay.of(context).hide();
//           break;
//       }
//     });
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     // Pick an image
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _file = image;
//     });
//   }

//   Future<String> urlImag(String id) async {
//     try {
//       final storageRef = await FirebaseStorage.instance
//           .refFromURL("gs://talentapp-dev-c0fad.appspot.com/$id/profile.png")
//           .getDownloadURL();
//       return storageRef.toString();
//     } catch (e) {
//       final storageRef = await FirebaseStorage.instance
//           .refFromURL(
//               "gs://talentapp-dev-c0fad.appspot.com/default_images/profile.png")
//           .getDownloadURL();
//       return storageRef.toString();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.size,
//       width: widget.size,
//       // color: Colors.red,
//       child: Stack(
//         children: [
//           //------------------------------Foto--------------------------------
//           Center(
//             child: Container(
//               height: widget.size - widget.size * 0.25,
//               width: widget.size - widget.size * 0.25,
//               margin: const EdgeInsets.all(20),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: (_file == null)
//                     ? FutureBuilder(
//                         future: urlImag(widget.user?.id ?? ""),
//                         builder: (_, AsyncSnapshot<String> snapshot) {
//                           if (snapshot.hasData) {
//                             return Image(
//                               image: CachedNetworkImageProvider(snapshot.data!),
//                               fit: BoxFit.cover,
//                             );
//                           } else {
//                             return const Image(
//                               image: AssetImage('assets/images/profile.png'),
//                               fit: BoxFit.cover,
//                             );
//                           }
//                         })
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.file(
//                           File(_file!.path),
//                           height: 200,
//                           width: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//             ),
//           ),

//           //-----------------------Boton de editar foto-------------------------
//           Positioned(
//             right: -widget.size * 0.05,
//             bottom: -widget.size * 0.05,
//             child: EditPictureButton(
//               size: widget.size * 0.25,
//               onPressed: () async {
//                 await _pickImage();
//                 _viewModel.uploadImageProfile(_file!.path, widget.user!.id!);
//               },
//               child: Icon(
//                 Icons.edit_outlined,
//                 color: AppColors.greyscale5,
//                 size: widget.size * 0.15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

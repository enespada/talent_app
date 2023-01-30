import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:talent_app/widgets/widgets.dart';

import '../models/models.dart';
import '../style/app_colors.dart';

class CircleEditableAvatar extends StatefulWidget {
  final double size;
  // final UserApp? user;
  final ImageProvider<Object> image;

  const CircleEditableAvatar({
    Key? key,
    required this.size,
    // this.user,
    required this.image,
  }) : super(key: key);

  @override
  State<CircleEditableAvatar> createState() => _CircleEditableAvatarState();
}

class _CircleEditableAvatarState extends State<CircleEditableAvatar> {
  // final _viewModel = inject<AuthViewModel>();

  //XFile con la nueva imagen seleccionada si la hubiera
  XFile? _file;

  @override
  void initState() {
    super.initState();
    // _viewModel.uploadImgState.stream.listen((state) {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       widget.user?.imgSrc = "profile.png";
    //       _viewModel.registerUser(widget.user!);
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });
  }

  //Metodo para seleccionar una imagen de la galeria
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    _file = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Stack(
        children: [
          //------------------------------Foto--------------------------------
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              height: widget.size - widget.size * 0.25,
              width: widget.size - widget.size * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.size),
                child: (_file == null)
                    ? Image(
                        image: widget.image,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_file!.path),
                        height: widget.size,
                        width: widget.size,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          //-----------------------Boton de editar foto-------------------------
          Positioned(
            right: -widget.size * 0.05,
            bottom: -widget.size * 0.05,
            child: EditPictureButton(
              size: widget.size * 0.25,
              onPressed: () async {
                await _pickImage();
                //TODO: guardar imagen en firebase
                // _viewModel.uploadImageProfile(_file!.path, widget.user!.id!);
              },
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.greyscale5,
                size: widget.size * 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

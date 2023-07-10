// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:talent_app/presentation/widgets/widgets.dart';

class CircleEditableAvatar extends StatefulWidget {
  final double size;
  // ImageProvider<Object> image;
  Image? image;
  File? file;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  CircleEditableAvatar({
    Key? key,
    required this.size,
    required this.image,
    required this.file,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  @override
  State<CircleEditableAvatar> createState() => _CircleEditableAvatarState();
}

class _CircleEditableAvatarState extends State<CircleEditableAvatar> {
  //XFile con la nueva imagen seleccionada si la hubiera
  XFile? _xFile;

  @override
  void initState() {
    super.initState();
  }

  //Metodo para seleccionar una imagen de la galeria
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    _xFile = await picker.pickImage(source: ImageSource.gallery);
    if (_xFile != null) {
      widget.file = File(_xFile!.path);
    }
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
              // color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.size),
                child: (widget.file == null)
                    // ? Image(
                    //     image: widget.image,
                    //     fit: BoxFit.cover,
                    //   )
                    // : Image.file(
                    //     File(_xFile!.path),
                    //     height: widget.size,
                    //     width: widget.size,
                    //     fit: BoxFit.cover,
                    //   ),
                    ? widget.image
                    : Image.file(
                        widget.file!,
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
              color: (widget.iconBackgroundColor != null)
                  ? widget.iconBackgroundColor
                  : const Color(0xFFDDF247),
              onPressed: () async {
                final PermissionState ps =
                    await PhotoManager.requestPermissionExtend();
                if (ps.isAuth) {
                  await _pickImage();
                  //TODO: guardar imagen en firebase
                  // _viewModel.uploadImageProfile(_file!.path, widget.user!.id!);
                }
              },
              child: Icon(
                Icons.edit_outlined,
                color: (widget.iconColor != null)
                    ? widget.iconColor
                    : Colors.black,
                size: widget.size * 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

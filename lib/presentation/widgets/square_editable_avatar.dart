import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

class SquareEditableAvatar extends StatefulWidget {
  final double size;
  final ImageProvider<Object> image;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const SquareEditableAvatar({
    Key? key,
    required this.size,
    this.iconColor,
    this.iconBackgroundColor,
    required this.image,
  }) : super(key: key);

  @override
  State<SquareEditableAvatar> createState() => _SquareEditableAvatarState();
}

class _SquareEditableAvatarState extends State<SquareEditableAvatar> {
  XFile? _xFile;

  @override
  void initState() {
    super.initState();
  }

  //Metodo para seleccionar una imagen de la galeria
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    _xFile = await picker.pickImage(source: ImageSource.gallery);
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
              height: widget.size - widget.size * 0.25,
              width: widget.size - widget.size * 0.25,
              margin: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: (_xFile == null)
                    ? Image(
                        image: widget.image,
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_xFile!.path),
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
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
                await _pickImage();
                //TODO: guardar imagen en firebase
                // _viewModel.uploadImageProfile(_file!.path, widget.user!.id!);
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

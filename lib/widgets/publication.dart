// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/carousel_images.dart';

class Publication extends StatefulWidget {
  final List<Image> images;

  const Publication({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<Publication> createState() => _PublicationState();
}

class _PublicationState extends State<Publication>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    this.controller = TabController(length: widget.images.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HeaderPublication(
        //   responsive: responsive,
        //   onPopupSelected: (item) {},
        // ),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: responsive.heightPercent(40),
          width: responsive.width,
          child: Stack(
            children: [
              // DefaultTabController(
              //   length: widget.images.length,
              //   child: Column(
              //     children: [
              //       Expanded(
              //         child: PageView.builder(
              //           itemCount: widget.images.length,
              //           physics: const BouncingScrollPhysics(),
              //           scrollDirection: Axis.horizontal,
              //           pageSnapping: true,
              //           onPageChanged: (index) {
              //             DefaultTabController.of(context)?.index = index;
              //             setState(() {
              //               controller?.index = index;
              //             });
              //           },
              //           itemBuilder: (_, index) => SizedBox(
              //             width: responsive.width,
              //             height: responsive.heightPercent(30),
              //             child: widget.images[index],
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: responsive.heightPercent(2)),
              //       TabPageSelector(
              //         controller: controller,
              //         color: AppColors.whiteColor,
              //         selectedColor: AppColors.brandColor,
              //         indicatorSize: responsive.widthPercent(2),
              //       ),
              //       SizedBox(height: responsive.heightPercent(1))
              //     ],
              //   ),
              // ),
              CarouselImages(
                assetEntities: null,
                images: widget.images,
              ),
              Positioned(
                bottom: 7,
                left: responsive.widthPercent(5),
                child: const Icon(
                  Icons.send,
                  color: AppColors.greyscale5,
                ),
              ),
              Positioned(
                bottom: 7,
                right: responsive.widthPercent(5),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.greyscale5,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'lana_smith  ',
                      style: TextStyle(
                        color: AppColors.greyscale5,
                        fontSize: responsive.widthPercent(4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Día de entrenamiento con mis nuevos compañeros ',
                      style: TextStyle(
                        color: AppColors.greyscale5,
                        fontSize: responsive.widthPercent(3),
                      ),
                    ),
                    TextSpan(
                      text: '#futbol #deporte #reto',
                      style: TextStyle(
                        color: AppColors.blueColor,
                        fontSize: responsive.widthPercent(3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '? Debería hacer más?',
                      style: TextStyle(
                        color: AppColors.greyscale5,
                        fontSize: responsive.widthPercent(3),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              Text(
                'Hoy 14:20',
                style: TextStyle(
                  color: AppColors.greyscale2,
                  fontSize: responsive.widthPercent(3),
                ),
              ),
              SizedBox(height: responsive.heightPercent(2)),
            ],
          ),
        ),
      ],
    );
  }
}

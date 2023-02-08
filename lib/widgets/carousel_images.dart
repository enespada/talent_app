import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:talent_app/style/app_colors.dart';

import 'package:talent_app/utils/utils.dart';

class CarouselImages extends StatefulWidget {
  final List<AssetEntity>? assetEntities;
  final List<ImageProvider<Object>>? images;

  const CarouselImages({
    Key? key,
    required this.assetEntities,
    required this.images,
  }) : super(key: key);

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    if (widget.assetEntities != null) {
      controller = TabController(
        length: widget.assetEntities!.length,
        vsync: this,
      );
    }
    if (widget.images != null) {
      controller = TabController(
        length: widget.images!.length,
        vsync: this,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    if (widget.assetEntities != null && widget.images != null) {
      return Container(
        child: Text('Una de las dos listas debe ser null'),
      );
    }
    if (widget.assetEntities == null && widget.images == null) {
      return Container(
        child: Text('Las dos listas no pueden ser null'),
      );
    }
    if (widget.assetEntities != null && widget.images == null) {
      return SizedBox(
        height: responsive.heightPercent(40),
        width: responsive.width,
        child: DefaultTabController(
          length: widget.assetEntities!.length,
          child: Column(
            children: [
              //--------------------------Fotos---------------------------------
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (selectedPage) {
                    DefaultTabController.of(context)?.index = selectedPage;
                    controller?.index = selectedPage;
                    setState(() {});
                  },
                  pageSnapping: true,
                  itemCount: widget.assetEntities!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: responsive.heightPercent(7),
                      width: responsive.width,
                      color: AppColors.greyscale5,
                      child: AssetEntityImage(
                        widget.assetEntities![index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize.square(800),
                        loadingBuilder: (context, child, loadingProgress) =>
                            child,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: responsive.heightPercent(2)),

              //-----------------------Selectores---------------------------------
              if (widget.images!.length > 1)
                TabPageSelector(
                  controller: controller,
                  borderStyle: BorderStyle.solid,
                  color: AppColors.greyscale0,
                  selectedColor: AppColors.blueColor,
                  indicatorSize: 7,
                ),
              SizedBox(height: responsive.heightPercent(2)),
            ],
          ),
        ),
      );
    }

    if (widget.assetEntities == null && widget.images != null) {
      return SizedBox(
        height: responsive.heightPercent(45),
        width: responsive.width,
        child: DefaultTabController(
          length: widget.images!.length,
          child: Column(
            children: [
              //--------------------------Fotos---------------------------------
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (selectedPage) {
                    DefaultTabController.of(context)?.index = selectedPage;
                    controller?.index = selectedPage;
                    setState(() {});
                  },
                  itemCount: widget.images!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: responsive.heightPercent(7),
                      width: responsive.width,
                      color: AppColors.greyscale5,
                      child: Image(
                        image: widget.images![index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: responsive.heightPercent(2)),

              //-----------------------Selectores---------------------------------
              // if (widget.images!.length > 1)
              TabPageSelector(
                controller: controller,
                borderStyle: BorderStyle.solid,
                color: AppColors.greyscale0,
                selectedColor: AppColors.blueColor,
                indicatorSize: 7,
              ),
              // if (widget.images!.length == 1)
              //   SizedBox(height: responsive.heightPercent(2)),
              SizedBox(height: responsive.heightPercent(2)),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}

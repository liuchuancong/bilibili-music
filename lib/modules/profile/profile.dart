import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/play/bottom_music_control.dart';
import 'package:bilibilimusic/modules/profile/profile_controll.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  buildMasterpieceListItems() {
    return Obx(
      () => controller.masterpiece.value.total == 0
          ? Container()
          : SizedBox(
              height: 270,
              width: double.infinity,
              child: Obx(() => Column(
                    children: [
                      SectionTitle(title: controller.masterpiece.value.name),
                      Expanded(
                        child: Scrollbar(
                          controller: controller.masterpieceController,
                          child: ListView(
                              controller: controller.masterpieceController,
                              scrollDirection: Axis.horizontal,
                              children: controller.masterpiece.value.liveMediaInfoList
                                  .map((e) => SimpleVideoCard(
                                        mediaInfo: e,
                                        onTap: () {},
                                      ))
                                  .toList()),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }

  // allVideosController

  buildAllvideosListItems() {
    return Obx(
      () => controller.allVideos.value.total == 0
          ? Container()
          : SizedBox(
              height: 500,
              width: double.infinity,
              child: Obx(() => Column(
                    children: [
                      SectionTitle(title: controller.allVideos.value.name),
                      Expanded(
                        child: Scrollbar(
                            controller: controller.allVideosController,
                            child: MasonryGridView.count(
                                scrollDirection: Axis.horizontal,
                                controller: controller.allVideosController,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                itemCount: controller.allVideos.value.liveMediaInfoList.length,
                                itemBuilder: (context, index) {
                                  return SimpleVideoCard(
                                    mediaInfo: controller.allVideos.value.liveMediaInfoList[index],
                                    onTap: () {},
                                  );
                                })),
                      )
                    ],
                  )),
            ),
    );
  }

  Widget buildSeasonsSeriesListItem(SeriesLiveMedia series) {
    final seasonsSeriesController = ScrollController();
    return series.total == 0
        ? Container()
        : SizedBox(
            height: series.total <= 5 ? 270 : 500,
            width: double.infinity,
            child: Column(
              children: [
                SectionTitle(title: series.name),
                Expanded(
                  child: Scrollbar(
                    controller: seasonsSeriesController,
                    child: MasonryGridView.count(
                      scrollDirection: Axis.horizontal,
                      controller: seasonsSeriesController,
                      crossAxisCount: series.total <= 5 ? 1 : 2,
                      crossAxisSpacing: 10,
                      itemCount: series.total,
                      itemBuilder: (context, index) {
                        return SimpleVideoCard(
                          mediaInfo: series.liveMediaInfoList[index],
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
  }

  buildSeasonsSeriesListItems() {
    return Obx(() => Column(
          children: controller.seasonsSeries.value.map((e) => buildSeasonsSeriesListItem(e)).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.upUserInfo.name),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: controller.innerController,
        child: Column(
          children: [
            buildMasterpieceListItems(),
            buildAllvideosListItems(),
            buildSeasonsSeriesListItems(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMusicControl(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.toggleFollow();
          },
          child: Obx(() => !controller.followed.value
              ? const Icon(
                  Icons.favorite,
                )
              : const Icon(Icons.favorite_border))),
    );
  }
}

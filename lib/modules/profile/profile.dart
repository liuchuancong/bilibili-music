import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/play/bottom_music_control.dart';
import 'package:bilibilimusic/modules/profile/profile_controll.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  buildListItems() {
    return Obx(() => Column(
          children: [
            Obx(() => SectionTitle(title: controller.masterpiece.value.name)),
            ...controller.masterpiece.value.liveMediaInfoList.map((e) => SimpleVideoCard(
                  mediaInfo: e,
                  onTap: () {},
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.upUserInfo.name),
      ),
      body: ListView(
        children: [
          buildListItems(),
        ],
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

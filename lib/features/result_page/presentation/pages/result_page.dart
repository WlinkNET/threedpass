import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threedpass/features/compare_page.dart/presentation/pages/compare_page.dart';
import 'package:threedpass/features/hashes_list/domain/entities/hashes_model.dart';
import 'package:threedpass/features/result_page/presentation/widgets/3d_scene.dart';
import 'package:threedpass/features/result_page/presentation/widgets/delete_object_button.dart';
import 'package:threedpass/features/result_page/presentation/widgets/hash_properties.dart';
import 'package:threedpass/features/result_page/presentation/widgets/maches_found.dart';
import 'package:threedpass/features/result_page/presentation/widgets/more_info.dart';
import 'package:threedpass/features/result_page/presentation/widgets/save_object_button.dart';
import 'package:threedpass/features/settings_page/presentation/pages/settings_page.dart';

class ResultPage extends StatelessWidget {
  final HashesModel hashesModel;

  const ResultPage({
    required this.hashesModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Get a new one"),
            IconButton(
              icon: Icon(Icons.share, color: Colors.grey),
              alignment: Alignment.centerRight,
              onPressed: () {
                Share.share(hashesModel.shareText);
              },
            )
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: MatchesFound(
                  currentModel: hashesModel,
                ),
              ),
              ObjectPreview(
                hashesModel: hashesModel,
              ),
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: HashProperties(),
              ),
              SaveObjectButton(
                hashesModel: hashesModel,
              ),
              DeleteObjectButton(
                hashesModel: hashesModel,
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              MoreInfo(
                hashesModel: hashesModel,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info, color: Colors.grey),
              onPressed: null,
              //title: Container(), //Text("Add"),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(),
                  ),
                );
              },
              //title: Container(), //Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:calc/calc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:threedpass/common/button_styles.dart';
import 'package:threedpass/common/logger.dart';
import 'package:threedpass/features/hashes_list/domain/entities/hashes_model.dart';
import 'package:threedpass/features/hashes_list/presentation/bloc/hashes_list_bloc.dart';
import 'package:threedpass/features/home_page/presentation/widgets/get_object_from_file_button.dart';
import 'package:threedpass/features/home_page/presentation/widgets/hash_card.dart';
import 'package:threedpass/features/result_page/presentation/pages/result_page.dart';
import 'package:threedpass/features/settings_page/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //Text(widget.title),
            Text("3DPass  "),
            Text(
              "recognize your objects",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 5),
              child: Column(
                children: <Widget>[
                  Text(
                      "Add your object's 3D model from file or scan it by camera and get a unique Hash ID."),
                  Text(
                      "In order to recognize your object add a new one object's 3D model or scan it again."),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    GetObjectFromFileButton(),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: ElevatedButton.icon(
                        style: AppButtonStyles.primaryButton,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Scan by camera'),
                        onPressed: () async {
                          log('on scan pressed');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: new Container(
                padding: new EdgeInsets.all(1.0),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          'Use \'Generate from file\' if you\'ve got already a 3D model of your object'),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, top: 0, right: 0, bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.help_center,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            MarkdownBody(
                              data: "### [How to use 3DPass](http://habr.com)",
                              onTapLink:
                                  (String text, String? href, String title) {
                                print("tapped: text=$text href=$href");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<HashesListBloc, HashesListState>(
              builder: (context, state) {
                if (state is HashesListLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.hashes.length,
                    itemBuilder: (context, index) => HashCard(
                      hashesModel: state.hashes[index],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ],
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
            ),
          ],
        ),
      ),
    );
  }
}
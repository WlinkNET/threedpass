import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:threedpass/features/hashes_list/domain/entities/hash_object.dart';
import 'package:threedpass/features/hashes_list/domain/entities/snapshot.dart';
import 'package:threedpass/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchesFound extends StatelessWidget {
  const MatchesFound({
    Key? key,
    required this.snapshot,
    required this.hashObject,
  }) : super(key: key);

  final Snapshot snapshot;
  final HashObject? hashObject;

  @override
  Widget build(BuildContext context) {
    if (hashObject != null && hashObject!.snapshots.length > 1) {
      return _ClickableText(
        // if object is saved then substract 1 cause it is counted in snapshots.length
        mainText: (hashObject!.snapshots.length - 1).toString() + ' matches ',
        clickable: 'found',
        onTap: () {
          context.router.push(
            CompareRouteWrapper(
              origObj: snapshot,
              hashObject: hashObject!,
            ),
          );
        },
      );
    } else {
      return _ClickableText(
        clickable: 'Why?',
        mainText: 'No matches found ',
        onTap: () {
          launch('https://3dpass.org/features.html#3D_object_recognition');
        },
      );
    }
  }
}

class _ClickableText extends StatelessWidget {
  const _ClickableText({
    required this.clickable,
    required this.mainText,
    required this.onTap,
  });

  final String clickable;
  final String mainText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = const TextStyle(color: Colors.black);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: mainText),
          TextSpan(
            text: clickable,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
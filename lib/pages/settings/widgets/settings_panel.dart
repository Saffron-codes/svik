import 'package:chatapp/config/pallete.dart';
import 'package:chatapp/pages/settings/models/settings_panel_model.dart';
import 'package:flutter/cupertino.dart';




class SettingsPanel extends StatefulWidget {
  final PanelModel items;
  const SettingsPanel({Key? key, required this.items}) : super(key: key);

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    final  _items = widget.items;
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _items.title,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18,
                color: Palette.kToLight.shade900,
              ),
            ),
            for (var topic in _items.topics)
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topic,
                      style: TextStyle(color: Palette.kToLight.shade500),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 20,
                      color: Palette.kToLight.shade900,
                    )
                  ],
                ),
                onPressed: () {},
              )
          ],
        ),
      ),
    );
  }
}

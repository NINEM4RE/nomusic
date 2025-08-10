import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no_music/pages/settings_subpages/equalizer.dart';
import 'package:no_music/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(preferredSize: Size(20, 20), child: Text('')),
      forceMaterialTransparency: false,
      foregroundColor: Colors.black,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      surfaceTintColor: const Color.fromARGB(255, 0, 0, 0),
      titleSpacing: 24,
      title: Text('Settings', style: TextStyle(fontFamily: 'NType82Regular', color: Colors.white, fontSize: 42),),
    ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 8, 16, 12),
                    child: Text('Audio settings', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 80, 80, 80)), ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      SubpageRedirectTile(borderRadiusTop: 20, borderRadiusBottom: 6, title: 'Equalizer settings', subtitle: 'Access the equalizer settings and tune the sound your way.', route: EqualizerPage()),
                      SliderTileWidget(
                        borderRadiusTop: 6,
                        borderRadiusBottom: 20,
                        title: 'App volume',
                        subtitle: 'Adjust the app volume independently of your system volume. Gives you finer control over the volume.',
                        settingsKey: 'appVolume',
                      ),
                  // New Audio additions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 24, 16, 12),
                    child: Text('Playback settings', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 80, 80, 80))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      SwitchTileLogicWidget(borderRadiusTop: 20, borderRadiusBottom: 20, settingsKey: 'gaplessPlayback', title: 'Gapless playback', subtitle: 'Eliminate pauses between tracks.'),
                    
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 24, 16, 12),
                    child: Text('Library & downloads', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 80, 80, 80))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 24, 16, 12),
                    child: Text('Look & feel', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 80, 80, 80)), ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      SwitchTileLogicWidget(borderRadiusTop: 20, borderRadiusBottom: 6, settingsKey: 'progressiveBlur', title: 'Progressive blur effects', subtitle: "This adds iOS-like progressive blur effects to the app. The effects are performance intensive, keep this turned off if your device can't handle it.",),
                      SwitchTileLogicWidget(borderRadiusTop: 6, borderRadiusBottom: 6, settingsKey: 'showLyrics', title: 'Show lyrics', subtitle: 'Display lyrics when available.'),
                      SwitchTileLogicWidget(borderRadiusTop: 6, borderRadiusBottom: 20, settingsKey: 'hapticFeedback', title: 'Haptic feedback', subtitle: 'Vibration on key interactions.'),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 16))
                    ]
                  ),
                ],
      ),
    ));
  }
}

class SubpageRedirectTile extends StatelessWidget {
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final String title;
  final Widget route;
  final String? subtitle;
  

  const SubpageRedirectTile({
    super.key,
	required this.borderRadiusTop,
	required this.borderRadiusBottom,
	required this.title,
	required this.route,
	this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
    	shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(borderRadiusTop), bottom: Radius.circular(borderRadiusBottom))),
    	onTap: () {  Navigator.push(context, CupertinoPageRoute(builder: (context) => route),); },
    	contentPadding: EdgeInsets.fromLTRB(24, 0, 16, 0),
    	title: Padding(
    		padding: const EdgeInsets.only(top: 12.0),
    		child: Text(title),
    	),
    	subtitle: Padding(
			padding: EdgeInsets.only(bottom: 12.0),
			child: subtitle == (null) ? null : Text(subtitle!, style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
		),
    	trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}


class SliderTileWidget extends StatefulWidget {
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final String settingsKey;
  final String title;
  final String? subtitle;
  final int? divisions;
  final String? enabledByBoolKey; // NEW
  SliderTileWidget({
    super.key,
	required this.borderRadiusTop,
	required this.borderRadiusBottom,
	required this.settingsKey,
	required this.title,
	this.subtitle,
	this.divisions,
    this.enabledByBoolKey,
  });
  

  @override
  State<SliderTileWidget> createState() => _SliderTileWidgetState();
}

class _SliderTileWidgetState extends State<SliderTileWidget> {
  late double _value;

  @override
  void initState() {
	super.initState();
	_value = SettingsService().getDouble(widget.settingsKey) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabledByBoolKey == null
        ? true
        : (SettingsService().getBool(widget.enabledByBoolKey!) ?? false);
    return ListTile(
	  contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
	  //subtitle: widget.subtitle == (null) ? null : Text(widget.subtitle!, style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
	  title: Padding(
		padding: const EdgeInsets.only(left: 24.0, top: 12),
		child: Text(widget.title),
	  ),
	  subtitle: 
		Padding(
				  padding: const EdgeInsets.only(bottom: 12.0),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
						children: [
					Padding(
						padding: const EdgeInsets.only(left: 24.0, right: 24),
						child: widget.subtitle == (null) ? null : Text(widget.subtitle!, style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
					),
					  Padding(
						  padding: const EdgeInsets.only(top: 8.0, left: 24),
						  child: Row(
							children: [
								SizedBox(width: 40,child: Text('${(_value * 100).round()}%', style: TextStyle(fontSize: 16),)),
							Expanded(
							  child: Slider(
								divisions: widget.divisions,
								value: _value,
								min: 0.0,
								max: 1.0,
								onChanged: enabled
                                  ? (newValue) {
                                      setState(() {
                                        _value = newValue;
                                      });
                                    }
                                  : null,
								onChangeEnd: enabled
                                  ? (newValue) {
                                      SettingsService().setDouble(widget.settingsKey, newValue);
                                    }
                                  : null,
							  ),
							),
							
							],
						  ),
						),
					],
				  ),
				),
	  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(widget.borderRadiusTop), bottom: Radius.circular(widget.borderRadiusBottom))),
	);
  }
}

// NEW: Dropdown tile widget
class DropdownTileWidget extends StatefulWidget {
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final String settingsKey;
  final String title;
  final String? subtitle;
  final Map<String, String> options;
  const DropdownTileWidget({
    super.key,
    required this.borderRadiusTop,
    required this.borderRadiusBottom,
    required this.settingsKey,
    required this.title,
    required this.options,
    this.subtitle,
  });

  @override
  State<DropdownTileWidget> createState() => _DropdownTileWidgetState();
}

class _DropdownTileWidgetState extends State<DropdownTileWidget> {
  late String _value;
  late StreamSubscription<String> _sub;

  @override
  void initState() {
    super.initState();
    _value = SettingsService().getString(widget.settingsKey) ?? widget.options.keys.first;
    _sub = SettingsService().onChanged.listen((k) {
      if (k == widget.settingsKey) {
        setState(() {
          _value = SettingsService().getString(widget.settingsKey) ?? _value;
        });
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(
          top: Radius.circular(widget.borderRadiusTop),
          bottom: Radius.circular(widget.borderRadiusBottom),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 16, 0),
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(widget.title),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.subtitle != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(widget.subtitle!, style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1))),
              ),
            DropdownButton<String>(
              isExpanded: true,
              value: _value,
              underline: SizedBox.shrink(),
              items: widget.options.entries
                  .map((e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _value = v;
                });
                SettingsService().setString(widget.settingsKey, v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchTileLogicWidget extends StatefulWidget {
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final String settingsKey;
  final String title;
  final String? subtitle;
  
  const SwitchTileLogicWidget({
	super.key,
	required this.borderRadiusTop,
	required this.borderRadiusBottom,
	required this.settingsKey,
	required this.title,
	this.subtitle,
  });

  @override
  State<SwitchTileLogicWidget> createState() => _SwitchTileLogicWidgetState();
}

class _SwitchTileLogicWidgetState extends State<SwitchTileLogicWidget> {
  late bool _value;

  @override
  void initState() {
	super.initState();
	_value = SettingsService().getBool(widget.settingsKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
	return SwitchListTile(
	  contentPadding: EdgeInsets.fromLTRB(24, 0, 16, 0),
	  subtitle: Padding(
			padding: const EdgeInsets.only(bottom: 12.0),
			child: widget.subtitle == (null) ? null : Text(widget.subtitle!, style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
		  ),
	  title: Padding(
			padding: const EdgeInsets.only(top: 12.0),
			child: Text(widget.title),
		  ),
	  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(widget.borderRadiusTop), bottom: Radius.circular(widget.borderRadiusBottom))),
	  value: _value,
	  onChanged: (bool value) {
		setState(() {
		  _value = value;
		  SettingsService().setBool(widget.settingsKey, value);
		});
	  },
	);
  }
}
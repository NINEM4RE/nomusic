import 'package:flutter/material.dart';
import 'package:no_music/pages/settings.dart';

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({super.key});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,),),
              bottom: PreferredSize(preferredSize: Size(20, 20), child: Text(''),),
              forceMaterialTransparency: false,
              foregroundColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              surfaceTintColor: const Color.fromARGB(255, 0, 0, 0),
              titleSpacing: 0,
              title: Text('Equalizer', style: TextStyle(fontFamily: 'NType82Regular', color: Colors.white, fontSize: 42),),
            ),
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            children: [
              Column(
	  				crossAxisAlignment: CrossAxisAlignment.stretch,
	  				spacing: 6,
	  			    children: [
	  			      SwitchTileLogicWidget(borderRadiusTop: 20, borderRadiusBottom: 6, settingsKey: 'equalizerToggle', title: 'Toggle equalizer', subtitle: 'Turn the equalizer on or off.',),
	  			    ],
	  			  ),
            ],
          ),
        )),
      ),
    );
  }
}
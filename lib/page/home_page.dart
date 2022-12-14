import 'package:flutter/material.dart';
import 'package:gen_tool/constants.dart';

import 'json_to_models_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var j2m in jsonToModels)
            _buildShortcut(
                label: 'JSON to Model (${j2m.shortName})',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JsonToModelsPage(j2m),
                    ),
                  );
                }),
        ],
      ),
    ));
  }

  Widget _buildShortcut({required String label, void Function()? onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

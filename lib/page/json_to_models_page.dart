import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_tool/converter/json_to_models_converter.dart';
import 'package:json_editor/json_editor.dart';

class JsonToModelsPage extends StatefulWidget {
  const JsonToModelsPage({Key? key}) : super(key: key);

  @override
  State<JsonToModelsPage> createState() => _JsonToModelsPageState();
}

class _JsonToModelsPageState extends State<JsonToModelsPage> {
  final _nameTec = TextEditingController();
  String _json = '';
  String _model = '';
  bool _showIconCopy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model to JSON')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('Root class name: ', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameTec,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DottedBorder(
                      color: Colors.grey[700]!,
                      strokeWidth: 3,
                      dashPattern: const [10, 6],
                      radius: const Radius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: JsonEditor.string(
                          jsonString: _json,
                          onValueChanged: (value) {
                            _json = JsonElement.fromJson(value.toJson()).toString();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onConvert,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 1),
                    child: Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onDoubleTap: () {
                        Clipboard.setData(ClipboardData(text: _model));
                        setState(() {
                          _showIconCopy = true;
                        });
                        Future.delayed(const Duration(seconds: 1)).then((_) => setState(() {
                              _showIconCopy = false;
                            }));
                      },
                      child: Stack(children: [
                        DottedBorder(
                          color: Colors.grey[700]!,
                          strokeWidth: 3,
                          dashPattern: const [10, 6],
                          radius: const Radius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SingleChildScrollView(
                              child: Text(
                                _model,
                                style: const TextStyle(fontSize: 16),
                                maxLines: null,
                              ),
                            ),
                          ),
                        ),
                        if (_showIconCopy)
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[500],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Icon(
                                  Icons.copy,
                                  size: 100,
                                  color: Colors.grey[200]!,
                                ),
                              ),
                            ),
                          )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onConvert() {
    setState(() {
      _model = JsonToModelsConverter.convert(_json, _nameTec.text);
    });
  }
}

import 'package:gen_tool/converter/json_to_models/bnpl_algo.dart';
import 'package:gen_tool/converter/json_to_models/go24_algo.dart';
import 'package:gen_tool/converter/json_to_models/lt_algo.dart';
import 'package:gen_tool/converter/json_to_models/tbem_algo.dart';
import 'package:gen_tool/models/j2m.dart';

List<J2M> jsonToModels = [
  J2M(
    key: 'bnpl',
    name: 'TIKI - Buy Now Pay Later',
    shortName: 'BNPL',
    converter: BNPLJsonToModelsConverter(),
  ),
  J2M(
    key: 'go24',
    name: 'Go24',
    shortName: 'Go24',
    converter: Go24JsonToModelsConverter(),
  ),
  J2M(
    key: 'lt',
    name: 'LetTutor',
    shortName: 'LetTutor',
    converter: LTJsonToModelsConverter(),
  ),
  J2M(
    key: 'tbem',
    name: 'TIKI - TicketBox Event Manager',
    shortName: 'TBEM',
    converter: TBEMJsonToModelsConverter(),
  ),
];

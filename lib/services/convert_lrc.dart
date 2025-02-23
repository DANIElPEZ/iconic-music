import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchAndParseLRC(String url)async{
  try{
    final response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      return parseLRC(response.body);
    }else{
      throw Exception('Error al obtener el archivo ${response.statusCode}');
    }
  }catch(e){
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> parseLRC(String lrcText) async {
  List<Map<String, dynamic>> lyrics = [];
  RegExp regExp = RegExp(r"\[(\d+):(\d+\.\d+)\](.*)");

  for (var line in lrcText.split("\n")) {
    var match = regExp.firstMatch(line);
    if (match != null) {
      double time = int.parse(match.group(1)!) * 60 + double.parse(match.group(2)!);
      String text = match.group(3)!.trim();
      lyrics.add({"time": time, "text": text});
    }
  }
  return lyrics;
}

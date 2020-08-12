import 'package:kushi/user/model/address.client.model.dart';

class ListAddressClient {
  bool error;
  int status;
  List<AddressClient> listAdrress;

  ListAddressClient({this.error,this.status, this.listAdrress});

  factory ListAddressClient.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<AddressClient> mapList = list.map((i) => AddressClient.formJson(i)).toList();
    return ListAddressClient(error:parsedJson['error'], status: parsedJson['status'], listAdrress: mapList);
  }
}
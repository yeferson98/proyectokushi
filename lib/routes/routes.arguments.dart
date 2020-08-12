class RouteArgumentProd {
  dynamic id;
  List<dynamic> argumentsList;

  RouteArgumentProd({this.id, this.argumentsList});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsList.toString()}}';
  }
}

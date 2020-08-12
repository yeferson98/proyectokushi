import 'package:flutter/cupertino.dart';

 class CupertinoProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:Center(child: Image(image: AssetImage('assets/img/gifproducts.gif',), height: 70,),),
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            //имеет в себе заголовок
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                children: [
                  Text(
                    "Navigation",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 34.0,
                        fontFamily: "Redressed"),
                  ),
                  SizedBox(
                    height: 80,
                    child: SvgPicture.asset("assets/images/LoneWolf.svg"),
                  )
                ],
              )),
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).accentColor,),
            title: Text("Home", style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor,)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/list_events')),
          ),
          ListTile(
            //и остальное тело элементов, использовать листтайл, т.к обернуты в обычный список
            leading: Icon(Icons.wysiwyg, color: Theme.of(context).accentColor,),
            title: Text("To list", style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor,)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/list_events', ModalRoute.withName('/list_events')),
          ),
          ListTile(
            leading: Icon(Icons.add, color: Theme.of(context).accentColor,),
            title: Text("Add event", style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor,)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/add', ModalRoute.withName('/list_events')),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Theme.of(context).accentColor,),
            title: Text("Favorite", style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor,)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/favorite', ModalRoute.withName('/list_events')),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Theme.of(context).accentColor,),
            title: Text("About app", style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor,)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/about', ModalRoute.withName('/list_events')),
          ),
        ],
      ),
    );
  }
}

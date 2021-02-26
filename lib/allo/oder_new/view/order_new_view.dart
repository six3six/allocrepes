import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_repository/models/place.dart';

class OrderNewView extends StatelessWidget {
  const OrderNewView({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes commandes"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Batiment : ",
                  style: theme.textTheme.caption,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: DropdownButton<Place>(
                    value: Place(name: "Ampère A"),
                    onChanged: (Place value) {},
                    items: [
                      Place(name: "Ampère A"),
                      Place(name: "Ampère B"),
                      Place(name: "Ampère C"),
                      Place(name: "Arago")
                    ].map<DropdownMenuItem<Place>>((Place place) {
                      return DropdownMenuItem<Place>(
                        value: place,
                        child: Text(place.name),
                      );
                    }).toList(),
                  ),
                ),
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Appart n°',
                    helperText: '',
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _OrderNewCategory(),
              _OrderNewCategory(),
              _OrderNewCategory(),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              height: 50,
              child: RaisedButton(
                color: theme.primaryColor,
                onPressed: () {},
                child: Text("Commander"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderNewCategory extends StatelessWidget {
  final title = "Crepes";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20)
              .add(EdgeInsets.only(top: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headline5,
              ),
              Column(
                children: [
                  _OrderNewItem(),
                  _OrderNewItem(),
                  _OrderNewItem(),
                ],
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _OrderNewItem extends StatelessWidget {
  final image =
      "https://www.hervecuisine.com/wp-content/uploads/2010/11/recette-crepes.jpg";
  final title = "Crepes aux sucres";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 7,
            child: Text(title, style: textTheme.headline5),
          ),
          DropdownButton<int>(
            value: 0,
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int newValue) {},
            items: <int>[0, 1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(" " + value.toString() + " "),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

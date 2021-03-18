import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final image;
  final title;

  const NewsCard({Key? key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ));
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 600.0,
      ),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: Image.network(
                  image,
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              ListTile(
                title: Container(
                  padding: EdgeInsets.only(right: 20, bottom: 20, top: 10),
                  child: Text(
                    title,
                    style: headStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

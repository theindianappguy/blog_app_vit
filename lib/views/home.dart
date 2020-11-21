import 'package:blog_app_firebase/services/crud.dart';
import 'package:blog_app_firebase/views/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CrudMethods crudMethods = CrudMethods();

  QuerySnapshot blogSnapshot;

  @override
  void initState() {
    crudMethods.getData().then((result) {
      blogSnapshot = result;
      setState(() {});
    });

    super.initState();
  }

  Widget blogsList() {
    return Container(
        child: ListView.builder(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      itemCount: blogSnapshot.docs.length,
      itemBuilder: (context, index) {
        return BlogTile(
          title: blogSnapshot.docs[index].get('title'),
          author: blogSnapshot.docs[index].get('author'),
          desc: blogSnapshot.docs[index].get('desc'),
          imgUrl: blogSnapshot.docs[index].get('imgUrl'),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: blogSnapshot != null
          ? blogsList()
          : Container(
              child: Center(
              child: CircularProgressIndicator(),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateBlog()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String author, title, desc, imgUrl;

  BlogTile({this.author, this.title, this.desc, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                ),
              )),
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "$desc",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          Container(alignment: Alignment.centerRight, child: Text(author)),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

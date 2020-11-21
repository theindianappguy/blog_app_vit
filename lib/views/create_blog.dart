import 'dart:io';
import 'package:blog_app_firebase/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  File selectedImage;
  final picker = ImagePicker();

  bool isLoading = false;

  CrudMethods crudMethods = new CrudMethods();

  TextEditingController authorTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descTextEditingController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      // upload image to firebase storage
      Reference blogImageStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(10)}.jpg");

      final UploadTask task = blogImageStorageRef.putFile(selectedImage);
      // get download url

      var imgUrl;
      await task.whenComplete(() async {
        try {
          imgUrl = await blogImageStorageRef.getDownloadURL();
        } catch (e) {
          print(e);
        }
      });

      print(imgUrl);
      // upload all to firestore

      Map<String, String> blogData = {
        "author": authorTextEditingController.text,
        "title": titleTextEditingController.text,
        "desc": descTextEditingController.text,
        "imgUrl": imgUrl
      };

      crudMethods.addData(blogData).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Blog"),
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
              // print(authorTextEditingController.text);
              // print(titleTextEditingController.text);
              // print(descTextEditingController.text);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  children: [
                    selectedImage != null
                        ? Container(
                            margin: EdgeInsets.only(top: 24),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 24),
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                    SizedBox(height: 24),
                    TextField(
                      controller: authorTextEditingController,
                      decoration: InputDecoration(hintText: "author"),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: titleTextEditingController,
                      decoration: InputDecoration(hintText: "title"),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: descTextEditingController,
                      decoration: InputDecoration(hintText: "desc"),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }
}

// condition  true : false

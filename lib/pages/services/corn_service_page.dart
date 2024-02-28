import 'dart:convert';
import 'dart:io';
import 'package:agriplant/data/services.dart';
import 'package:agriplant/models/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import 'corn_info_page.dart';


class CornService extends StatefulWidget {
  final Service service;
  const CornService({Key? key, required this.service}) : super(key: key);

  @override
  _CornServiceState createState() => _CornServiceState();
}

class _CornServiceState extends State<CornService> {

  late final Service service;

  @override
  void initState() {
    super.initState();
    service = widget.service;
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();
  late String prediction = '';
  bool isLoading = false;


  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text(
              'Please choose an image',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child:  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            color: Colors.white,
                            Icons.image),
                        SizedBox(width: 12),
                        Text(
                          'From Gallery',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            color: Colors.white,
                            Icons.camera),
                        SizedBox(width: 12),
                        Text(
                            'From Camera',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:  Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
          child: Text(
            service.name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 22
            ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                myAlert();
              },
              child: const Text(
                  'Scan your plant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  )
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image, you type like this.
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: 300,
                  height: 300,
                ),
              ),
            )
                : const Text(
              "",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(121,5, 0, 30),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      uploadImageToServer(image!).then((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                      backgroundColor: Colors.grey,
                    )
                        : const Text(
                      'Identify',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                ),
              ],
            ),
            Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(122,0, 0, 2),
                    child: prediction == ''
                        ? const Center()
                        : Visibility(
                      visible: prediction != null,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              prediction,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 40),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CornDiseaseInfoScreen(prediction)),
                              );
                            },
                            child: const Text(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                )
                                ,'Learn More'
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }




    Future<void> uploadImageToServer(XFile imageFile) async {
    try {
      if (kDebugMode) {
        print("attempting to connect to server......");
      }
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      if (kDebugMode) {
        print(length);
      }

      var uri = Uri.parse("http://192.168.1.9:5000/corn");

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = await http.MultipartFile.fromPath('file', imageFile.path);

      request.files.add(multipartFile);
      var response = await request.send();

      // Check the response status code
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Image uploaded successfully!');
        }

        // Decode the response body to get prediction result
        var responseBody = await response.stream.bytesToString();
        var result = jsonDecode(responseBody);

        setState(() {
          prediction = result['predicted_disease'] as String;
        });
      } else {
        if (kDebugMode) {
          print('Image upload failed with status code ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
    }
  }


}
import 'dart:io';
import 'package:bloodnepal/helper/manage_permission.dart' as mp;
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class ProfileImage extends StatefulWidget {
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {


  bool isLoading = false;
  bool isVisible = false;
  File image;
  String filename;
  String imgURL;
  final _imagePicker = ImagePicker();

  ///-----Check Permission-------//
  void checkPermission() async{
    bool status = await mp.ManagePermission.isCameraPermissionGranted();
    if(status){
      getImage();
    }else{
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Storage permission required to update photo'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }
  ///----for choosing the image from the device--//
  Future<void> getImage() async {
    final selectedImage = await _imagePicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 400,
        imageQuality: 40);

    setState(() {
      image = File(selectedImage.path);
      filename = path.basename(image.path);
    });
    setState(() {
      isVisible = true;
    });

    // print(filename);
  }

///-----for setting and uploading image---///
  Future<void> upAndsetimage() async {
    setState(() {
      isVisible = false;
    });
    setState(() {
      isLoading = true;
    });
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child("Users_profile/$filename");
     firebase_storage.UploadTask uploadTask = ref.putFile(image);
     var upload = await uploadTask.whenComplete(() {
       setState(() {
         isLoading = false;
       });
       return showDialog(
           context: context,
           builder: (ctx) {
             return AlertDialog(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15),
               ),
               title: Text("Your Profile picture has been updated"),
               actions: <Widget>[
                 FlatButton(
                     child: Text("OK"),
                     onPressed: () {
                       Navigator.pop(context);
                     })
               ],
             );
           });
     }
     );
    var downUrl = await upload.ref.getDownloadURL();
    imgURL = downUrl.toString();
   Provider.of<AuthProvider>(context, listen: false).updateUserphoto(imgURL);
  }


  @override
  Widget build(BuildContext context) {
    var user =Provider.of<AuthProvider>(context,listen: false).getCurrentUser();
    print(user.firstName);
    return Stack(
      children: [
        isLoading
            ? CircularProgressIndicator(strokeWidth: 2.0,)
            : ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 130,
            width: 130,
            child: image == null
                ? Image.network(
            user.imageUrl
            ,fit: BoxFit.cover,
            )
                : Image.file(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Positioned(
            top: 85,
            left: 85,
            child: MaterialButton(
              // elevation: 1,
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed:checkPermission,
              minWidth: 30,
              height: 30,
              child: Icon(
                Icons.add_a_photo,
                size: 18,
                color: style.CustomTheme.themeColor,
              ),
            )),
        isVisible
            ? Positioned(
            top: 88,
            left: 5,
            child: MaterialButton(
              // elevation: 1,
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                image = null;
                setState(() {
                  isVisible = false;
                });
              },
              minWidth: 30,
              height: 30,
              child: Icon(
                Icons.cancel,
                size: 18,
                color: Colors.red,
              ),
            ))
            : Positioned(top: 91, left: 45, child: SizedBox()),
        isVisible
            ? Positioned(
            top: 91,
            left: 45,
            child: MaterialButton(
              // elevation: 1,
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                upAndsetimage();
              },
              minWidth: 30,
              height: 30,
              child: Icon(
                Icons.check_box,
                size: 18,
                color: Colors.green,
              ),
            ))
            : Positioned(top: 91, left: 45, child: SizedBox()),
      ],
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';


class ProfilePage extends StatefulWidget {

  ProfilePage({Key? key,}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _ageController = TextEditingController();


  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Reference? task2;

  String? imageUrlDownload;

  ImagePicker _picker = ImagePicker();
  XFile? image;

  File? imageFile;

  void _remove() {
    setState(() {
      imageFile = null;
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final user = FirebaseAuth.instance.currentUser;

    _userNameController.text = userProvider.userModel.name!;
    _emailController.text = userProvider.userModel.email!;
    _phoneNoController.text = userProvider.userModel.phoneNo!;
    _addressController.text = userProvider.userModel.country!;
    _ageController.text = userProvider.userModel.age!;

    // it provide us total height and width
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small devices
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Palette.primaryColor.withOpacity(0.40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        // the height of this container is 80% of our width
                        height: size.width * 0.8,

                        child: Container(
                          height: size.width * 0.9,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),

                          child:
                          imageFile == null ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Theme.of(context).primaryColor),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(

                                    userProvider.userModel.imageUrl!,


                                  ),
                                )
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                decoration:  BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Palette.secondary,
                                        Color(0x19000000),
                                      ],
                                      begin: FractionalOffset(0.0, 1.5),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),),),

                          ) :
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Theme.of(context).primaryColor),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    imageFile!,
                                  ),
                                )
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                decoration:  BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Palette.secondary,
                                        Color(0x19000000),
                                      ],
                                      begin: FractionalOffset(0.0, 1.5),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),),),

                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 5,
                          right: 0,
                          child: RawMaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Palette.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0),
                                      ),
                                      title: Text('Choose Option', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                selectCameraImage();
                                              },
                                              // splashColor: Palette.facebookColor,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.camera,color: Theme.of(context).accentColor.withOpacity(.90),),
                                                  ),
                                                  Text('Camera', style: TextStyle(fontSize: 18, color: Palette.primary,fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                selectGalleryImage();
                                              },
                                              // splashColor: Palette.facebookColor,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.image, color: Theme.of(context).accentColor.withOpacity(.90)),
                                                  ),
                                                  Text('Gallery', style: TextStyle(fontSize: 18, color: Palette.primary,fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _remove();
                                              },
                                              // splashColor: Palette.facebookColor,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.remove_circle,color: Theme.of(context).accentColor.withOpacity(.90)),
                                                  ),
                                                  Text('Remove', style: TextStyle(fontSize: 18, color: Palette.primary,fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            elevation: 5,
                            fillColor:  Palette.primary.withOpacity(0.60),
                            child: Icon(Icons.add_a_photo, color: Colors.white,),
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                          ))
                    ],
                  ),
                ),

                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Palette.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ToggleSwitch(
                                    minWidth: 90.0,
                                    initialLabelIndex: userProvider.userModel.showUser == 'public' ? 0 : 1,
                                    cornerRadius: 20.0,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.white,
                                    inactiveFgColor: Colors.black87,
                                    totalSwitches: 2,
                                    labels: ['Public', 'Private'],
                                    icons: [Icons.visibility_outlined, Icons.visibility_off_outlined],
                                    activeBgColors: [[Colors.green],[Colors.red]],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                      if(index == 0){
                                        userProvider.userModel.showUser = 'public';
                                      }
                                      else{
                                        userProvider.userModel.showUser = 'private';
                                      }
                                    },
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    controller: _userNameController,
                                    decoration: InputDecoration(

                                      labelText: 'User Name',
                                      labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Palette.deepBlue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),

                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Palette.deepBlue, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),

                                      errorStyle:
                                      TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter UserName';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Palette.deepBlue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),

                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Palette.deepBlue, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),

                                      errorStyle:
                                      TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _phoneNoController,
                                    decoration: InputDecoration(

                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Palette.deepBlue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),

                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Palette.deepBlue, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),

                                      errorStyle:
                                      TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Phone No.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _addressController,
                                    decoration: InputDecoration(

                                      labelText: 'Address',
                                      labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Palette.deepBlue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),

                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Palette.deepBlue, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),

                                      errorStyle:
                                      TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _ageController,
                                    decoration: InputDecoration(

                                      labelText: 'Age',
                                      labelStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Palette.deepBlue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),

                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Palette.deepBlue, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderSide:  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(20),

                                      ),

                                      errorStyle:
                                      TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Age';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: () async {

                                    if(imageFile != null)
                                    {
                                      await uploadImage();
                                    }

                                    setState(()  {
                                      print('$imageUrlDownload image URL');
                                    });

                                    users.doc(user!.uid)
                                        .update({'name': _userNameController.text.trim(),'email': _emailController.text.trim(),'phoneNo': _phoneNoController.text.trim(),'country': _addressController.text.trim(), 'imageUrl': imageUrlDownload == null ? userProvider.userModel.imageUrl : imageUrlDownload, 'age': _ageController.text.trim(),'showUser': userProvider.userModel.showUser,})
                                        .then((value) => print("Admin Updated"))
                                        .catchError((error) => print("Failed to update admin: $error"));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [Palette.deepBlue.withOpacity(0.50), Palette.deepBlue],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Palette.deepBlue.withOpacity(.3),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(0, 1))
                                        ]),
                                    child: Center(child: Text("Update Profile", style: TextStyle(color: Colors.white, fontSize: 16),)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: 20),
        icon: Icon(Icons.arrow_back,color: Colors.black,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // centerTitle: false,
      // title: Text(
      //   'Back'.toUpperCase(),
      //   style: Theme.of(context).textTheme.bodyText2,
      // ),
    );
  }

  void selectCameraImage() async {
    image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.pop(context);
  }

  void selectGalleryImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.pop(context);
  }

  Future uploadImage() async {
    final destination = 'users/images/$imageFile';

    task2 = FirebaseStorage.instance.ref(destination);

    if(imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please Upload your Picture")));
    }

    await task2!.putFile(File(imageFile!.path));

    imageUrlDownload = await task2!.getDownloadURL();

    print('Download-link: $imageUrlDownload');


  }
}
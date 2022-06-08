import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:dating_app_flutter/Model/UserModel.dart';
import 'package:dating_app_flutter/Provider/AllUsersProvider.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/login_page.dart';
import 'package:dating_app_flutter/Screens/widgets/header_widget.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:dating_app_flutter/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class RegistrationPage extends StatefulWidget {

  const RegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  double _headerHeight = 200;
  final formkey = GlobalKey<FormState>();

  bool checkedValue = false;
  bool checkboxValue = false;

  String _selectedGender = 'Male';

  Object _value = 1;

  String countryName = 'Select Country';

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController phoneTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController ageTextEditingController =
      new TextEditingController();

  DateTime _selectedDate = DateTime.now();

  bool circular = false;

  void signMeUp() async {
    setState(() {
      circular = true;
    });

      final userProvider =  Provider.of<UserProvider>(context, listen: false);
      final allUsersProvider =  Provider.of<AllUsersProvider>(context, listen: false);

      print("this data is new");

      await uploadImage();

      setState(()  {

        print('$imageUrlDownload image URL');

      });
      await userProvider.signUp(
          userModel: UserModel(
            age: ageTextEditingController.text.trim(),
            country: countryName,
            email: emailTextEditingController.text.trim(),
            gender: _selectedGender,
            imageUrl: imageUrlDownload,
            name: userNameTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim(),
            phoneNo: phoneTextEditingController.text.trim(),
            showUser: 'public'
          ),
          onSuccess: () async {
            await allUsersProvider.changeGender(context);
            await allUsersProvider.getAllUsers(context);
            setState(() {
              circular = false;
            });

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => AuthWrapper()),
                    (route) => false);
          }, onFail: (e) {
        setState(() {
          circular = false;
        });
        final snackbar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      );

  }


  _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != _selectedDate)
      setState(() {
        _selectedDate = selected;
      });
  }

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

    final imageName = imageFile != null ? imageFile : 'No Image Selected';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 100, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [


                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 71
                                ,
                                backgroundColor: Palette.primary.withOpacity(0.85),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white.withOpacity(.85),

                                  backgroundImage: imageFile == null ? null : FileImage(imageFile!),
                                  child: imageFile == null ? Icon(Icons.person, size: 100, color: Palette.primary,) : null
                                ),
                              ),
                            ),
                            Positioned(
                                top: 110,
                                left: 95,
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
                                            title: Text('Choose Option', style: TextStyle(fontWeight: FontWeight.w600,),),
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
                                                          child: Icon(Icons.camera,),
                                                        ),
                                                        Text('Camera', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
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
                                                          child: Icon(Icons.image, ),
                                                        ),
                                                        Text('Gallery', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
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
                                                          child: Icon(Icons.remove_circle, ),
                                                        ),
                                                        Text('Remove', style: TextStyle(fontSize: 18, color: Colors.red,fontWeight: FontWeight.bold),)
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
                                  fillColor:  Palette.secondary.withOpacity(0.60),
                                  child: Icon(Icons.add_a_photo, color: Colors.white,),
                                  padding: EdgeInsets.all(10),
                                  shape: CircleBorder(),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          child: TextFormField(
                            controller: userNameTextEditingController,
                            decoration: ThemeHelper().textInputDecoration(
                                'User Name', 'Enter your user name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: emailTextEditingController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: phoneTextEditingController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: passwordTextEditingController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (index) {
                                        setState(() {
                                          _value = index!;
                                          _selectedGender = 'Male';
                                          print(_selectedGender);
                                        });
                                      }),
                                  Expanded(
                                    child: Text('Male'),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 2,
                                      groupValue: _value,
                                      onChanged: (index) {
                                        setState(() {
                                          _value = index!;
                                          _selectedGender = 'Female';
                                          print(_selectedGender);
                                        });
                                      }),
                                  Expanded(child: Text('Female'))
                                ],
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                                bottomSheetHeight: 500,
                                // Optional. Country list modal height
                                //Optional. Sets the border radius for the bottomsheet.
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                //Optional. Styles the search field.
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              onSelect: (Country country) {
                                setState(() {
                                  countryName = country.name ;
                                });
                              },
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(countryName),
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100.0),
                              )),
                        ),
                        // SizedBox(height: 20,),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: ageTextEditingController,
                            keyboardType: TextInputType.number,
                            decoration: ThemeHelper().textInputDecoration(
                                'Age', 'Enter your age'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: circular
                                  ? CircularProgressIndicator(
                                  valueColor:AlwaysStoppedAnimation<Color>(Palette.deepBlue))
                                  :  Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: ()  {

                              signMeUp();

                            },
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(text: "Already have an account? "),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(builder: (context) => LoginPage()),
                                                  (Route<dynamic> route) => false);
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      setState(() {
        circular = false;
      });
    }

    await task2!.putFile(File(imageFile!.path));

    imageUrlDownload = await task2!.getDownloadURL();

    print('Download-link: $imageUrlDownload');


  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
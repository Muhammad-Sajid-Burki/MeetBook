import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/show_conversation_image.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:dating_app_flutter/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final String imageUrl;
  const ConversationScreen({ Key? key, required this.chatRoomId, required this.userName, required this.imageUrl}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethod databaseMethod = new DatabaseMethod();
  TextEditingController messagecontroller = new TextEditingController();

  ScrollController _scrollController = ScrollController();


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot>? chatMessageStream;


  Widget chatMessageList(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
            return MessageTile(message :snapshot.data!.docs[index]["message"],
             isSendByMe: snapshot.data!.docs[index]["sendby"]== userProvider.userModel.name.toString(),
              isImage: snapshot.data!.docs[index]["type"] == 'img',
            
            );
          } 
          
          ):Container();
      });
  }
  sendMessage(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    if(messagecontroller.text.isNotEmpty){
    Map<String,dynamic> messageMap={
      "message": messagecontroller.text,
      "type": "text",
      "sendby": userProvider.userModel.name.toString(),
      "time": DateTime.now().microsecondsSinceEpoch
    };
    databaseMethod.addConversationMessage(widget.chatRoomId, messageMap);
    messagecontroller.text = "";
    }
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

  sendImage(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    if(imageUrlDownload!.isNotEmpty){
      Map<String,dynamic> messageMap={
        "message": imageUrlDownload,
        "type": "img",
        "sendby": userProvider.userModel.name.toString(),
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethod.addConversationMessage(widget.chatRoomId, messageMap);
      imageUrlDownload = "";
    }
  }

  @override
  void initState() {
    databaseMethod.getConversationMessage(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // here we set the timer to call the event
    Timer(Duration(milliseconds: 200), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius:BorderRadius.circular(40),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover
                  )
              ),
            ),
            SizedBox(width: 8,),
            Text(widget.userName,style: TextStyle(color: Palette.fullBlue, fontSize: 20, fontWeight: FontWeight.w700))

          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: chatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Color(0x54ffffff),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
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
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          // padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              gradient:
                              LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Palette.fullBlue,
                                    Palette.deepBlue,
                                    Palette.fullBlue,
                                  ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                        ),

                        /*elevation: 5,
                        fillColor:  Colors.black.withOpacity(0.60),
                        child: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                        padding: EdgeInsets.all(5),
                        shape: CircleBorder(),*/
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                        controller: messagecontroller,
                        style: TextStyle(color: Palette.fullBlue),
                        decoration: InputDecoration(
                            hintText: "Message...",
                            hintStyle: TextStyle(color: Palette.deepBlue),
                            border: InputBorder.none,
                        ),
                      ),
                          )),
                      GestureDetector(
                        onTap: () {
                          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                          sendMessage();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              gradient:
                              LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                  colors: [
                                    Palette.fullBlue,
                                    Palette.deepBlue,
                                    Palette.fullBlue,
                              ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Image.asset("assets/images/send.png"),
                        ),
                      )
                    ],
                  ),
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
    await uploadImage();
    await sendImage();
    Navigator.pop(context, false);

  }

  void selectGalleryImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
    await uploadImage();
    await sendImage();

    Navigator.pop(context, false);
  }

  Future uploadImage() async {

    final destination = 'chat/images/$imageFile';

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


class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final bool isImage;
  const MessageTile({ Key? key, required this.message, required this.isSendByMe, required this.isImage }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      isImage ?
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowConversationImage(message: message,)));
        },
        child: Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isSendByMe ? 0 : 24,
              right: isSendByMe ? 24 : 0
          ),
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              height: 250,
              width: 200,
              decoration: BoxDecoration(
                  color: Palette.secondary.withOpacity(.20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Palette.secondary),
                image: DecorationImage(
                  image: NetworkImage(message),
                  fit: BoxFit.contain
                )
              ),
              // child: Image.network(message, fit: BoxFit.contain,)
          ),
        ),
      )  :

    Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
         margin: isSendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: isSendByMe ? [
                Palette.fullBlue,
                Palette.deepBlue
              ]
                  : [
                Colors.grey.shade500,
                Colors.grey.shade600
              ],
            )
        ),
        child: Text(message,style: ThemeHelper().simpleTextStyle(),),
      ),
    );
  }
}
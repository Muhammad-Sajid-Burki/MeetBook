import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/conversationScreen.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:dating_app_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  Stream<QuerySnapshot>? chatRoomStream;

  Widget chatRoomList(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
            return ChatRoomList(userName: snapshot.data!.docs[index]["chatRoomId"]
            .toString().replaceAll("_", "").replaceAll(userProvider.userModel.name.toString(), ""),
            chatRoomId: snapshot.data!.docs[index]["chatRoomId"],
              imageurl: snapshot.data!.docs[index][snapshot.data!.docs[index]["chatRoomId"]
                  .toString().replaceAll("_", "").replaceAll(userProvider.userModel.name.toString(), "")].toString(),
            );
          }):Container();

      }
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }


  getUserInfo()async{
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    databaseMethod.getChatRooms(userProvider.userModel.name!).then((value){
      setState(() {
        chatRoomStream=value;
      });
    });
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: chatRoomList(),
    );
  }
}

class ChatRoomList extends StatelessWidget {
  final String userName;
  final String imageurl;
  final String chatRoomId;
  const ChatRoomList({ Key? key, required this.userName, required this.chatRoomId, required this.imageurl }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId: chatRoomId, userName: userName,imageUrl: imageurl,)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Palette.secondary,

          ),
          padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                    color: Palette.deepBlue,
                    borderRadius:BorderRadius.circular(40),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Palette.deepBlue,
                    borderRadius:BorderRadius.circular(40),
                    image: DecorationImage(
                      image: NetworkImage(imageurl),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(userName,style: TextStyle(color: Palette.fullBlue, fontSize: 20, fontWeight: FontWeight.w700),)

            ],
          ),
        ),
      ),
    );
  }
}
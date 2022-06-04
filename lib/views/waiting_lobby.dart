import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/utils/colors.dart';
import 'package:mp_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;
  late String roomId;

  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(
      text:
          Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'],
    );
    roomId =
        Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'];
  }

  @override
  void dispose() {
    super.dispose();
    roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Waiting for a player to join...",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: roomIdController,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: bgColor,
                  filled: true,
                  hintText: '',
                  icon: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: roomId));
                      showSnackBar(context, 'Copied To Clipboard');
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        SpinKitThreeInOut(color: Colors.white),
      ],
    );
  }
}

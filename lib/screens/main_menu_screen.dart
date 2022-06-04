import 'package:flutter/material.dart';
import 'package:mp_tictactoe/responsive/responsive.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';
import 'package:mp_tictactoe/screens/join_room_screen.dart';
import 'package:mp_tictactoe/widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);

  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Responsive(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo.jpg'),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                onTap: () => createRoom(context),
                text: "Create Room",
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                onTap: () => joinRoom(context),
                text: "Join Room",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

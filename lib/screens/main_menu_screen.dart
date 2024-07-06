import 'package:flutter/material.dart';
import 'package:tictactoe/screens/create_room_screen.dart';
import 'package:tictactoe/screens/join_room_screen.dart';
import 'package:tictactoe/widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
              onTap: () {
                Navigator.pushNamed(context, CreateRoomScreen.routeName);
              },
              text: 'Create Room'),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
              onTap: () {
                Navigator.pushNamed(context, JoinRoomScreen.routeName);
              },
              text: 'Join Room'),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:tictactoe/resources/socket_methods.dart';
import 'package:tictactoe/widgets/custom_button.dart';
import 'package:tictactoe/widgets/custom_text.dart';
import 'package:tictactoe/widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinRoomScreen({super.key});
  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIDController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIDController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _socketMethods.joinRoomSuccessListener(context);
    _socketMethods.errorOccuredListener(context);
    _socketMethods.updatePlayerStateListener(context);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
                shadow: [Shadow(blurRadius: 40, color: Colors.blue)],
                text: 'Join Room',
                fontSize: 70),
            SizedBox(
              height: size.height * 0.08,
            ),
            CustomTextField(
                controller: _nameController, hintText: 'Enter your nickname'),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
                controller: _gameIDController, hintText: 'Enter your Game ID'),
            SizedBox(
              height: size.height * 0.04,
            ),
            CustomButton(onTap: () => _socketMethods.joinRoom(_nameController.text, _gameIDController.text), text: 'Join')
          ],
        ),
      ),
    );
  }
}

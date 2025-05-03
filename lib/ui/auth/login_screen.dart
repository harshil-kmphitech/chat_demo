import 'package:chat_demo/controllers/auth_controller.dart';
import 'package:chat_demo/helpers/all.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => controller.onLoginPress(),
          child: Text('Login'),
        ),
      ),
    );
  }
}

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_nusantara/notifications/notification_controller.dart';
import 'package:e_nusantara/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'sign_up.dart';
import '../api/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title, this.successMessage});

  final String title;
  final String? successMessage;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final FlutterSecureStorage storage;
  bool _isPasswordHidden = true;
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    storage = FlutterSecureStorage();
    super.initState();

    _checkTokenAndNavigate();
    // Set listeners for notifications
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );

    if (widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.successMessage!)),
        );
      });
    }
  }

  // Function to check if token exists and navigate accordingly
  Future<void> _checkTokenAndNavigate() async {
    print("test sesions");
    final storage1 = FlutterSecureStorage();
    String? token = await storage1.read(key: 'refreshToken');
    print(await storage.read(key: 'refreshToken'));
    if (token != null) {
      // If token exists, navigate to Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
      );
    }
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await _authService.login(email, password);
    print(result?['refreshToken']);
    if (result != null &&
        result['accessToken'] != null &&
        result['refreshToken'] != null) {
      // If login is successful, save the access token
      await storage.write(key: 'accessToken', value: result['accessToken']);
      await storage.write(key: 'refreshToken', value: result['refreshToken']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login successful')));

      // Create notification on successful login
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "login_channel",
          title: "Nusa Chan",
          body: "Selamat kamu sudah login >//<",
        ),
      );

      // Navigate to Home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
      );
    } else {
      // If login fails, show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ))),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SignUpPage(title: "sign up")));
                    },
                    child: const Text(
                      'Sign Up',
                      style:
                          TextStyle(color: Color.fromARGB(255, 189, 176, 162)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDDA86B),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
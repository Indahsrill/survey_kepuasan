import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kepuasan_pelanggan/views/uploadpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "...";
  bool onLoading = false;
  bool canContinue = false;

  Future<void> connectionCheck() async {
    Uri uri = Uri.parse("http://213.218.240.102/");
    var request = http.MultipartRequest("GET", uri);

    setState(() {
      onLoading = true;
      message = "Uploading...";
    });
    try {
      var response = await request.send().timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        message = "Connected successfully!";
        canContinue = true;
      } else {
        message = "Connection status: ${response.statusCode}";
        canContinue = false;
      }
    } catch (error) {
      message = error.toString();
      canContinue = false;
    }

    setState(() {
      onLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    connectionCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome!")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Server Connection Status:"),
              onLoading ? const CircularProgressIndicator() : Text(message),
              canContinue
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadPage(),
                          ),
                        );
                      },
                      child: const Text("Continue"),
                    )
                  : ElevatedButton(
                      onPressed: connectionCheck,
                      child: Text("Try Again"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

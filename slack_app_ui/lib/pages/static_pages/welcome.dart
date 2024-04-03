import 'package:flutter/material.dart';
import 'package:slack_app_ui/pages/m_workspace/new.dart';
import 'package:slack_app_ui/pages/sessions/new.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Slack App",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
            ),
            body: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Slack Appからようこそ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50,),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                        ),
                      );
                    }, 
                    child: Text(
                      'Signin',
                      style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(100, 20, 40, 200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const 
                          workspacenew(),
                          ),
                        );
                      }, 
                      child: Text(
                        'Create Workspace',
                        style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(100, 20, 40, 200),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }

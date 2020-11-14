import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// This starts the app with the login screen
void main() async {
  runApp(Login());
}

// This is run by the main() function, opens the login page
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.blue,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: LoginPage(theme: theme),
    );
  }
}

// This page is where the user logs in.
class LoginPage extends StatefulWidget {
  LoginPage({this.theme});
  ThemeData theme;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userIDController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // This connects the app to the Stream SDK API
  final _client = Client('k5wj7jcsdfzb', logLevel: Level.INFO);

  @override
  void dispose() {
    _userIDController.dispose();
    super.dispose();
  }

  @override
  // This is the main body of the login screen
  // It houses the text field that the user types their user ID into
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  )),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text('Enter your User ID',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400))),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  child: TextFormField(
                      controller: _userIDController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD2D9), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD2D9),
                                  width: 1,
                                  style: BorderStyle.solid))))),
              // This is the sign-in button
              // Calls the _loginUser() function when pressed
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  onPressed: () {
                    _loginUser();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF4776e6),
                            Color(0xFF8e54e9),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(80.0))),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child:
                        const Text("Sign In", style: TextStyle(fontSize: 20)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // This function signs in the user
  _loginUser() async {
    final userID = _userIDController.text.trim();

    // Throws warning if login text field is empty
    if (userID.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text('User id is empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    // Connects to locally hosted back-end and verifies user
    var url = "https://ce83e6c04a39.ngrok.io/token";
    Map<String, String> headers = new Map();
    headers['Content-Type'] = 'application/json';
    var body = json.encode({
      "userId": userID,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);

    var userToken = jsonDecode(tokenResponse.body)['token'];

    // Sends user/client info to StreamChat widgets through RunMyApp()
    // Navigates to RunMyApp()
    // Shows error if user validation or server error
    await _client.setUser(User(id: userID), userToken).then((response) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RunMyApp(_client),
        ),
      );
    }).catchError((error) {
      print(error);
      SnackBar snackBar = SnackBar(content: Text('Could not login user'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }
}

// Sends client info to ChannelListPage()
// Sets StreamChat data
class RunMyApp extends StatelessWidget {
  final Client client;

  RunMyApp(this.client);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.green,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: ChannelListPage(),
    );
  }
}

// This page shows active chats with other users
class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Channels", style: TextStyle(color: Colors.black),), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChannelsBloc(
          child: ChannelListView(
            filter: {
              'members': {
                '\$in': [StreamChat.of(context).user.id],
              }
            },
            channelPreviewBuilder: _channelPreviewBuilder,
            sort: [SortOption('last_message_at')],
            pagination: PaginationParams(
              limit: 20,
            ),
            channelWidget: ChannelPage(),
          ),
        ),
      ),
    );
  }
}

// Helps build channel previews (recently sent messages, etc.)
Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
  final lastMessage = channel.state.messages.reversed
      .firstWhere((message) => !message.isDeleted);

  final subtitle = (lastMessage == null ? "nothing yet" : lastMessage.text);
  final opacity = channel.state.unreadCount > .0 ? 1.0 : 0.5;

  return ListTile(
    leading: ChannelImage(
      channel: channel,
    ),
    title: ChannelName(
      channel: channel,
      textStyle: StreamChatTheme.of(context).channelPreviewTheme.title.copyWith(
            color: Colors.black.withOpacity(opacity),
          ),
    ),
    subtitle: Text(subtitle),
    trailing: channel.state.unreadCount > 0
        ? CircleAvatar(
            radius: 10,
            child: Text(channel.state.unreadCount.toString()),
          )
        : SizedBox(),
  );
}

// This page is where the User can message
class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    // This function calls the detect_tone Python Cloud function
    // and returns the emotion in a dialog box
    Future<void> identifyEmotion(String content) async {
      final String apiURL =
          'https://us-central1-derivative-293318.cloudfunctions.net/detect_tone';
      print(apiURL);
      final response = await http.post(
        apiURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'msg': content.toString()}),
      );
      if (response.statusCode == 200) {
        print(response.body);
        String emotionText;
        Color dialogColor;
        Color textColor;
        // This switch-case determines the color and message
        // content of the dialog box depending on the emotion.
        switch (response.body) {
          case "Analytical":
            {
              emotionText =
                  "A person's reasoning and analytical attitude about things";
              dialogColor = Colors.white;
              textColor = Colors.black;
            }
            break;
          case "Anger":
            {
              emotionText =
                  "Evoked due to injustice, conflict, humiliation, negligence or betrayal. If anger is active, the individual attacks the target, verbally or physically. If anger is passive, the person silently sulks and feels tension and hostility.";
              dialogColor = Colors.red.withOpacity(1);
              textColor = Colors.white;
            }
            break;
          case "Confident":
            {
              emotionText = "A person's degree of certainty.";
              dialogColor = Colors.amber;
              textColor = Colors.black;
            }
            break;
          case "Fear":
            {
              emotionText =
                  "A response to impending danger. It is a survival mechanism that is a reaction to some negative stimulus. It may be a mild caution or an extreme phobia.";
              dialogColor = Colors.deepPurpleAccent;
              textColor = Colors.white;
            }
            break;
          case "Tentative":
            {
              emotionText = "A person's degree of inhibition.";
              dialogColor = Colors.white;
              textColor = Colors.black;
            }
            break;
          case "Joy":
            {
              emotionText =
                  "Joy or happiness has shades of enjoyment, satisfaction and pleasure. There is a sense of well-being, inner peace, love, safety and contentment.";
              dialogColor = Colors.yellow;
              textColor = Colors.black;
            }
            break;
          case "Sadness":
            {
              emotionText =
                  "Indicates a feeling of loss and disadvantage. When a person can be observed to be quiet, less energetic and withdrawn, it may be inferred that sadness exists.";
              dialogColor = Colors.blue;
              textColor = Colors.white;
            }
            break;
          default:
            {
              emotionText = "No strong emotions detected.";
              dialogColor = Colors.white;
              textColor = Colors.black;
            }
            break;
        }
        // Shows emotion dialog box
        showDialog(
          context: context,
          child: AlertDialog(
            backgroundColor: dialogColor,
            title: Text("Emotion: ${response.body}",
                style: TextStyle(color: textColor)),
            content: Text(emotionText, style: TextStyle(color: textColor)),
            actions: [
              FlatButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            ],
          ),
        );
        // Shows error box if response fails or text field is empty
      } else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Failed to get results"),
            content: Text("Try again."),
            actions: [
              FlatButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            ],
          ),
        );
        throw Exception('Failed to get results');
      }
    }

    // UI components of chat screen
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              threadBuilder: (_, parentMessage) {
                return ThreadPage(
                  parent: parentMessage,
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              print(controller.text);
              identifyEmotion(controller.text);
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF4776e6),
                      Color(0xFF8e54e9),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(80.0))),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Text("Identify emotions",
                  style: TextStyle(fontSize: 12.5)),
            ),
          ),
          MessageInput(
            textEditingController: controller,
          ),
        ],
      ),
    );
  }
}

// Shows chat threads
class ThreadPage extends StatelessWidget {
  final Message parent;

  ThreadPage({
    Key key,
    this.parent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          MessageInput(
            parentMessage: parent,
          ),
        ],
      ),
    );
  }
}

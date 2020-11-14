# emotion_fchacks

People with autism or schizophrenia sometimes struggle to recognize emotions displayed by other people. Our app aims to help then recognize emotions in text messages. Our app is a chat application that works similar to others with one new feature: it analyzes the tone of received messages and highlights them based on the emotions the text displays, and the strength of those emotions. The app will be a mobile application using dart and the flutter framework. The application consists of three main components: the server backend using node and javascript, the api call cloud function written in python and using google cloud functions, and the frontend using dart and the flutter framework. The frontend of the app makes use of a UI service and library called stream chat flutter. This library greatly simplified the creation of the UI and backend of the chat service, which allowed us to focus more on the text analysis part of the app. The backend server also makes use of the stream chat library, and is written in javascript using node.js. This server communicates with the frontend UI to allow users to chat with each other, and store their messages. Then, when the front end receives a message, it then makes use of the cloud function, which is done through an http request to google cloud functions. The cloud function is written in python and it calls the IBM tone analyzer API, which analyzes the text and sends back information about the tone of the message. We decided to use the IBM tone analyzer API because it works well and we did not have the time or resources to develop an accurate prediction model ourselves. The cloud function then extracts the most prevalent tone and sends that information back to the flutter app, which then colors the message based on the emotion found.

## App Source Code
The app source code is in /lib/main.dart

## Cloud Function/API Calling Code
The cloud function code is in detect_tone.py

## Screenshots

![alt text](https://media.discordapp.net/attachments/767891545159630849/777285888757465128/unknown.png?width=267&height=562)



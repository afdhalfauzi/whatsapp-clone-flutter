import 'dart:io';
import 'package:flutter_application_1/mqtt/mqtt_app_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// main() {
//   MQTTClientWrapper newclient = new MQTTClientWrapper();
//   newclient.prepareMqttClient();
// }

// // connection states for easy identification
// enum MqttCurrentConnectionState {
//   IDLE,
//   CONNECTING,
//   CONNECTED,
//   DISCONNECTED,
//   ERROR_WHEN_CONNECTING
// }

// enum MqttSubscriptionState {
//   IDLE,
//   SUBSCRIBED
// }

// class MQTTClientWrapper {

//   String topic = 'topic/test';
//   late MqttServerClient client;

//   MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
//   MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

//   // using async tasks, so the connection won't hinder the code flow
//   void prepareMqttClient() async {
//     _setupMqttClient();
//     await _connectClient();
//     _subscribeToTopic(topic);
//     _publishMessage('Hello');
//   }

//   // waiting for the connection, if an error occurs, print it and disconnect
//   Future<void> _connectClient() async {
//     try {
//       print('client connecting....');
//       connectionState = MqttCurrentConnectionState.CONNECTING;
//       await client.connect('testing1', 'Abdghkl1');
//     } on Exception catch (e) {
//       print('client exception - $e');
//       connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
//       client.disconnect();
//     }

//     // when connected, print a confirmation, else print an error
//     if (client.connectionStatus?.state == MqttConnectionState.connected) {
//       connectionState = MqttCurrentConnectionState.CONNECTED;
//       print('client connected');
//     } else {
//       print(
//           'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
//       connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
//       client.disconnect();
//     }
//   }

//   void _setupMqttClient() {
//     client = MqttServerClient.withPort('f2edf06efed4438a845edf7d012e4e8b.s1.eu.hivemq.cloud', 'testing1', 8883);
//     // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
//     client.secure = true;
//     client.securityContext = SecurityContext.defaultContext;
//     client.keepAlivePeriod = 20;
//     client.onDisconnected = _onDisconnected;
//     client.onConnected = _onConnected;
//     client.onSubscribed = _onSubscribed;
//   }

//   void _subscribeToTopic(String topicName) {
//     print('Subscribing to the $topicName topic');
//     client.subscribe(topicName, MqttQos.atMostOnce);

//     // print the message when it is received
//     client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
//       var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

//       print('YOU GOT A NEW MESSAGE:');
//       print(message);
//     });
//   }

//   void _publishMessage(String message) {
//     final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//     builder.addString(message);

//     print('Publishing message "$message" to topic $topic');
//     client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
//   }

//   // callbacks for different events
//   void _onSubscribed(String topic) {
//     print('Subscription confirmed for topic $topic');
//     subscriptionState = MqttSubscriptionState.SUBSCRIBED;
//   }

//   void _onDisconnected() {
//     print('OnDisconnected client callback - Client disconnection');
//     connectionState = MqttCurrentConnectionState.DISCONNECTED;
//   }

//   void _onConnected() {
//     connectionState = MqttCurrentConnectionState.CONNECTED;
//     print('OnConnected client callback - Client connection was sucessful');
//     // showToast(context, message, durationms)
//   }

// }

class MQTTManager {
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;

  MQTTManager({required String topic, required MQTTAppState state})
    : _identifier = 'flutter_client',
      _host = 'f2edf06efed4438a845edf7d012e4e8b.s1.eu.hivemq.cloud',
      _topic = topic,
      _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 8883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = true; // if true required username and password
    _client!.securityContext = SecurityContext.defaultContext;
    _client!.logging(on: true); //debug console

    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willTopic')
        .withWillMessage('offline')
        // .startClean()
        .withWillQos(MqttQos.atLeastOnce);
        // .withCleanSession(false);
    print('EXAMPLE::Mousquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> connect() async {
    try {
      print('client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect('testing1', 'Abdghkl1');
    } on Exception catch (e) {
      print('client exception - $e');
      _currentState.setAppConnectionState(
        MQTTAppConnectionState.error_when_connecting,
      );
      _client!.disconnect();
    }
  }

  void disconnect() {
    print('disconnected');
    _client!.disconnect();
  }

  void publish(String topic, String message) {
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      print("Client not connected. Cannot publish.");
      return;
    }
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: true);
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected...');
    _client!.subscribe(_topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt = //turn byte received message into string
      MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );
      _currentState.setReceivedText(pt);
      print(
        'EXAMPLE::Change notifitacion: topic is <${c[0].topic}>, payload is <-- $pt -->',
      );
      print('');
    });
    print(
      'EXAMPLE::OnConnected client callback - Client connection was sucessful',
    );
  }
}

import 'package:flutter_application_1/mqtt/mqtt_app_state.dart';
import 'package:flutter_application_1/mqtt/mqtt_manager.dart';

class MqttConnection {
    late MQTTManager mqttClient;
    late MQTTAppState mqttState;

  void connectMQTT() {
    mqttState = MQTTAppState();
    mqttClient = MQTTManager(
        topic: 'topic/test',
        state: mqttState);
    mqttClient.initializeMQTTClient();
    mqttClient.connect();
  }

  void disconnectMQTT() {
    mqttClient.disconnect();
  }
  MQTTAppConnectionState getConnectionState() {
    return mqttState.getAppConnectionState;
  }

  void publishMessage(String topic, String message) {
    mqttClient.publish( topic, message);
  }

  String getReceivedText() {
    return mqttState.getReceivedText;
  }

  get mqttContext {
    return mqttClient;
  }
}
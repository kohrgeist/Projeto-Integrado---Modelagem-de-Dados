// a config só existe p/ armazenar as credenciais do banco de dados, tanto mysql quato firebase
class ConnectionSettings {
  final String host;
  final int port;
  final String user;
  final String? password;
  final String? db;

  ConnectionSettings({
    required this.host,
    required this.port,
    required this.user,
    this.password,
    this.db,
  });
}

// mysql
final mySqlSettings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '1234',
  db: 'dbpi2025',
);

// firebase
const String firebaseDatabaseUrl =
    'https://prj-sensorenergia-default-rtdb.firebaseio.com/';
const String firebaseDatabaseSecret =
    'O2ubVqK7lBA1RT2RT7IMdpZTl91akJBaIKigNHg6';

//#define BLYNK_TEMPLATE_ID "TMPL2LZCOOmzE"
//#define BLYNK_TEMPLATE_NAME "projeto teste"
//#define BLYNK_AUTH_TOKEN "nLgR1IZL1MeyryCVEwTBgC6Glo9tvsHu"

#include <EmonLib.h>        // Biblioteca para leitura do sensor SCT-013
#include <WiFi.h>           // Inclui a biblioteca para controle de Wi-Fi no ESP32
#include <HTTPClient.h>     // Inclui a biblioteca para fazer requisições HTTP


EnergyMonitor SCT013;       // Instância do monitor de energia...
int pinSCT = 32;            // Pino analógico no ESP32 (pode ser qualquer GPIO ADC1)
float tensao = 220;         // Variável para armazenar a tensão da rede elétrica (110V ou 220V). Definida como 220V inicialmente.
float potencia;             // Variável para armazenar a potência

// Credenciais Wi-Fi
const char* ssid = "REGINALDO";     // SSID para se conectar
const char* password = "12077575";  // Senha da rede
const char* host = "api.thingspeak.com";    // Host da API ThingSpeak
const int httpPort = 80;                    // Porta HTTP padrão

// Sua chave de API do ThingSpeak
const String apiKey = "ILI1AQGNALKH4Y8B"; // Separando a API Key para facilitar a construção da URI

// Led's e botão
#define pinLEDVerde 2
#define pinLEDVermelho 4
#define pinBotao 23

// Variáveis para o controle do botão e LED
int estadoBotaoAnterior = HIGH; // Armazena o estado anterior do botão (HIGH porque INPUT_PULLUP)
bool tensaoAtual127V = false; // true se a tensão for 127V (LED Verde), false se 220V (LED Vermelho)


// Função para configurar a conexão Wi-Fi
void setupWiFi() {
  delay(10);
  Serial.println();
  Serial.print("Conectando-se a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password); // Inicia a conexão Wi-Fi

  while (WiFi.status() != WL_CONNECTED) { // Aguarda a conexão ser estabelecida
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi conectado!");
  Serial.print("Endereço IP: ");
  Serial.println(WiFi.localIP()); // Imprime o endereço IP do ESP32 na rede
}

// Função para enviar corrente e potência para o ThingSpeak
void enviaDadosThingSpeak(float corrente, float potencia) {
  Serial.print("Corrente RMS lida: ");
  Serial.print(corrente, 2); // Imprime com 2 casas decimais
  Serial.println(" A");

  // Constrói a URL completa para a requisição GET, incluindo field1 e field2
  String serverPath = "http://" + String(host) + "/update?api_key=" + apiKey +
                      "&field1=" + String(corrente, 2) +
                      "&field2=" + String(potencia, 2);

  HTTPClient http; // Cria um objeto HTTPClient

  // Inicia a conexão HTTP
  http.begin(serverPath.c_str()); // Converte String para const char*

  // Envia a requisição GET
  int httpResponseCode = http.GET();

  if (httpResponseCode > 0) { // Verifica o código de resposta HTTP
    Serial.print("Código de resposta HTTP: ");
    Serial.println(httpResponseCode);
    String payload = http.getString(); // Pega o corpo da resposta
    Serial.println(payload);
  } else {
    Serial.print("Erro na requisição HTTP: ");
    Serial.println(httpResponseCode);
  }
  http.end(); // Fecha a conexão
}

void setup() {
  SCT013.current(pinSCT, 60.0606); // Configura o pino e a calibração (ajuste conforme necessário)
  Serial.begin(115200);           // Comunicação serial em 115200 bps
  analogSetAttenuation(ADC_11db); // Ajusta a atenuação do ADC para a faixa de 0-3.3V
  setupWiFi(); // Configura a conexão Wi-Fi

  // Leds e Botão
  pinMode(pinLEDVerde, OUTPUT);
  pinMode(pinLEDVermelho, OUTPUT);
  pinMode(pinBotao, INPUT_PULLUP);

  // Define o estado inicial da tensão e dos LEDs
  // Começamos com 220V (LED Vermelho aceso)
  tensao = 220;
  tensaoAtual127V = false; // Indica que não é 127V, logo é 220V
  digitalWrite(pinLEDVermelho, HIGH);
  digitalWrite(pinLEDVerde, LOW);
  Serial.println("Tensão inicial: 220V");
}

void loop() {
  // Leitura do botão
  int estadoBotaoAtual = digitalRead(pinBotao);

  // Verifica se o botão foi pressionado (transição de HIGH para LOW)
  if (estadoBotaoAtual == LOW && estadoBotaoAnterior == HIGH) {
    delay(50); // Pequeno atraso para "debounce" do botão

    // Verifica novamente o estado do botão após o debounce
    estadoBotaoAtual = digitalRead(pinBotao);
    if (estadoBotaoAtual == LOW) { // Se ainda estiver LOW, o botão foi realmente pressionado
      tensaoAtual127V = !tensaoAtual127V; // Inverte o estado da tensão

      if (tensaoAtual127V) { // Se tensaoAtual127V for true, significa 127V
        tensao = 127;
        digitalWrite(pinLEDVerde, HIGH);   // LED Verde aceso
        digitalWrite(pinLEDVermelho, LOW); // LED Vermelho apagado
        Serial.println("Tensão alterada para: 127V");
      } else { // Se tensaoAtual127V for false, significa 220V
        tensao = 220;
        digitalWrite(pinLEDVerde, LOW);    // LED Verde apagado
        digitalWrite(pinLEDVermelho, HIGH); // LED Vermelho aceso
        Serial.println("Tensão alterada para: 220V");
      }
    }
  }
  estadoBotaoAnterior = estadoBotaoAtual;


  double Irms = SCT013.calcIrms(1480); // Calcula o valor da corrente
  potencia = Irms * tensao;             // Calcula o valor da potência instantânea com a tensão atual

  // Exibe os valores no monitor serial
  Serial.print("Tensão configurada: ");
  Serial.print(tensao);
  Serial.println("V");

  Serial.print("Corrente = ");
  Serial.print(Irms, 2);
  Serial.println(" A");

  Serial.print("Potencia = ");
  Serial.print(potencia);
  Serial.println(" W");

  // Envia corrente e potência para o ThingSpeak
  //enviaDadosThingSpeak(Irms, potencia);

  delay(10000); // Atualiza a cada 1 segundo
}
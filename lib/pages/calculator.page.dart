import 'package:flutter/material.dart';
import 'package:flutter_app_calculadora/widgets/button.widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // --- VARIÁVEIS DE ESTADO ---
  String _valorExibido = "0";
  double _primeiroNumero = 0;
  String _operacao = "";
  bool _esperandoSegundoNumero = false;

  // Variável para guardar o histórico (ex: "20 +")
  String _historico = "";

  // --- MÉTODOS DE LÓGICA ---

  void _limpar() {
    setState(() {
      _valorExibido = "0";
      _primeiroNumero = 0;
      _operacao = "";
      _esperandoSegundoNumero = false;
      _historico = ""; // Limpa o histórico também
    });
  }

  void _apagar() {
    setState(() {
      // Se a conta acabou de ser feita, apagar limpa o histórico
      if (_historico.contains("=")) {
        _historico = "";
      }

      if (_valorExibido.length > 1) {
        _valorExibido = _valorExibido.substring(0, _valorExibido.length - 1);
      } else {
        _valorExibido = "0";
      }
    });
  }

  void _inserirNumero(String numero) {
    setState(() {
      // Se acabou de fazer uma conta (tem "=" no histórico), limpa tudo para um novo cálculo
      if (_historico.contains("=")) {
        _historico = "";
        _valorExibido = "0";
      }

      if (_esperandoSegundoNumero) {
        _valorExibido = numero;
        _esperandoSegundoNumero = false;
      } else {
        if (_valorExibido == "0") {
          _valorExibido = numero;
        } else {
          _valorExibido += numero;
        }
      }
    });
  }

  void _inserirVirgula() {
    setState(() {
      if (_historico.contains("=")) {
        _historico = "";
        _valorExibido = "0,";
      } else if (!_valorExibido.contains(",")) {
        _valorExibido += ",";
      }
    });
  }

  void _escolherOperacao(String op) {
    setState(() {
      _primeiroNumero =
          double.tryParse(_valorExibido.replaceAll(',', '.')) ?? 0;
      _operacao = op;
      _esperandoSegundoNumero = true;

      // Atualiza o histórico para mostrar o primeiro número e a operação escolhida
      _historico = "$_valorExibido $op";
    });
  }

  void _calcular() {
    if (_operacao.isEmpty) return;

    double segundoNumero =
        double.tryParse(_valorExibido.replaceAll(',', '.')) ?? 0;
    double resultado = 0;

    switch (_operacao) {
      case "+":
        resultado = _primeiroNumero + segundoNumero;
        break;
      case "-":
        resultado = _primeiroNumero - segundoNumero;
        break;
      case "x":
        resultado = _primeiroNumero * segundoNumero;
        break;
      case "÷":
        if (segundoNumero == 0) {
          setState(() {
            _historico = "$_historico $_valorExibido =";
            _valorExibido = "Erro";
            _operacao = "";
            _esperandoSegundoNumero = true;
          });
          return;
        }
        resultado = _primeiroNumero / segundoNumero;
        break;
    }

    setState(() {
      // Constrói a equação completa no histórico
      _historico = "$_historico $_valorExibido =";

      String resultadoStr = resultado.toString().replaceAll('.', ',');
      if (resultadoStr.endsWith(",0")) {
        resultadoStr = resultadoStr.substring(0, resultadoStr.length - 2);
      }

      _valorExibido = resultadoStr;
      _operacao = "";
      _esperandoSegundoNumero = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora')),
      body: Column(
        children: [
          // TELA DA CALCULADORA
          Container(
            height: 200,
            width: double.maxFinite,
            color: Colors.black12,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // TEXTO DO HISTÓRICO
                Text(
                  _historico,
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                ),
                const SizedBox(height: 8), // Um pequeno espaço entre os textos
                // TEXTO DO NÚMERO ATUAL
                Text(
                  _valorExibido,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // TECLADO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ButtonWidget(
                    text: "C",
                    color: Colors.red,
                    onPressed: _limpar,
                  ),
                  ButtonWidget(
                    text: "\u232b",
                    color: Colors.orange,
                    onPressed: _apagar,
                  ),
                  ButtonWidget(
                    text: "÷",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () => _escolherOperacao("÷"),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(text: "7", onPressed: () => _inserirNumero("7")),
                  ButtonWidget(text: "8", onPressed: () => _inserirNumero("8")),
                  ButtonWidget(text: "9", onPressed: () => _inserirNumero("9")),
                  ButtonWidget(
                    text: "x",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () => _escolherOperacao("x"),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(text: "4", onPressed: () => _inserirNumero("4")),
                  ButtonWidget(text: "5", onPressed: () => _inserirNumero("5")),
                  ButtonWidget(text: "6", onPressed: () => _inserirNumero("6")),
                  ButtonWidget(
                    text: "-",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () => _escolherOperacao("-"),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(text: "1", onPressed: () => _inserirNumero("1")),
                  ButtonWidget(text: "2", onPressed: () => _inserirNumero("2")),
                  ButtonWidget(text: "3", onPressed: () => _inserirNumero("3")),
                  ButtonWidget(
                    text: "+",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () => _escolherOperacao("+"),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(text: "0", onPressed: () => _inserirNumero("0")),
                  ButtonWidget(text: ",", onPressed: _inserirVirgula),
                  ButtonWidget(
                    text: "=",
                    color: Colors.green,
                    onPressed: _calcular,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

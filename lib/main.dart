// Todo: Importação dos pacotes a serem utilizados
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// Todo: Método/função de ponto de partida -> todo app necessita de um
void main() => runApp(PrimeiroApp());

// Todo: Abaixo estão todas as classes criadas contendo seus Widgets
class PrimeiroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gerador de palavras",
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _sugestoes = <WordPair>[];
  final _salvo = <WordPair>{};
  final _fontGrande = const TextStyle(fontSize: 18.0);

  /* Todo: Widget para criar as linhas com palavras aleatórias conforme a
      tela é rolada */
  Widget _criarSugestoes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/2;
        if (index >= _sugestoes.length) {
          _sugestoes.addAll(generateWordPairs().take(10));
        }
        return _criarLinha(_sugestoes[index]);
      });
  }
  
  Widget _criarLinha(WordPair palavra) {
    final jaSalvo = _salvo.contains(palavra);
    return ListTile(
      title: Text(
        palavra.asPascalCase,
        style: _fontGrande,
      ),
      /* Todo: Valida se a palavra ja foi adicionada como favorito e mostra
          o coração em vermelho */
      trailing: Icon(
        jaSalvo ? Icons.favorite : Icons.favorite_border,
        color: jaSalvo ? Colors.red : null,
      ),
      // Todo: Adiciona ou remove dos favoritos de acordo com click no coração
      onTap: () {
        setState(() {
          if (jaSalvo) {
            _salvo.remove(palavra);
          } else {
            _salvo.add(palavra);
          }
        });
      },
    );
  }

  // Todo: Função para listar os favoritos salvos
  void _salvos() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _salvo.map(
            (WordPair palavra) {
              return ListTile(
                title: Text(
                  palavra.asPascalCase,
                  style: _fontGrande,
                ),
              );
            },
          );
          final dividido = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Sugestões Salvas'),
            ),
            body: ListView(children: dividido),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de palavras'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _salvos),
        ],
      ),
      body: _criarSugestoes(),
    );
  }
}

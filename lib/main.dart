// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:list_spanish_words/list_spanish_words.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.yellow
        ),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //list
  final _suggestions_Spanish = <WordPair>[]; //list
  final _biggerFont = TextStyle(fontSize: 18.0);

  final _saved = <WordPair>{}; // set
  bool _switchState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: Column(
        children: <Widget>[
          _buildSwitch(),
          Expanded(child: _buildSuggestions()),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions() {
    if (_switchState == false) return _buildSuggestionsEnglish();
    else return _buildSuggestionsSpanish();
  }

  Widget _buildSuggestionsEnglish() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildSuggestionsSpanish() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions_Spanish.length) {
          int len = list_spanish_words.length;

          for (int x = 0; x < 10; x++) {
            WordPair wp = WordPair(list_spanish_words[Random().nextInt(len)],
                list_spanish_words[Random().nextInt(len)]);
            _suggestions_Spanish.add(wp);
          }
        }

        return _buildRow(_suggestions_Spanish[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved)
              _saved.remove(pair);
            else
              _saved.add(pair);
          });
        });
  }

  Widget _buildSwitch() {
    return Switch(value: _switchState, onChanged: (value) {
      setState(() {
        _switchState = value;
      });
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {

        final tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );

        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }
}

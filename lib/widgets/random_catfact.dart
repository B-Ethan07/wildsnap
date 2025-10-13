import 'dart:core';
import 'package:flutter/material.dart';
import 'package:wildsnap/services/fetchcatfact_service.dart';

class RandomCatfact extends StatefulWidget {
  const RandomCatfact({super.key});

  @override
  State<RandomCatfact> createState() => _RandomCatfactState();
}

class _RandomCatfactState extends State<RandomCatfact> {
  String? _fact;
  bool _isLoading = false;
  String? _error;

  Future<void> _loadRandomFact() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final catFact = await fetchCatFacts();

      if (!mounted) return;
      setState(() {
        _fact = catFact.fact;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRandomFact();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _error != null
            ? Text('Erreur : $_error', style: TextStyle(color: Colors.red))
            : _fact != null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    // plus visible que 0.1
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              )
                  : null,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 4,
                color: Theme
                    .of(context)
                    .brightness == Brightness.dark
                    ? Colors.black
                    : Colors.amber[200],
                child: Container(
                  width: 600,
                  height: 170,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _fact!,
                            style: DefaultTextStyle
                                .of(context)
                                .style
                                .copyWith(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadRandomFact,
                        icon: Icon(Icons.refresh),
                        label: Text('Another fact'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
            : Text('Aucun fait trouvé'),
      ),
    );
  }
}

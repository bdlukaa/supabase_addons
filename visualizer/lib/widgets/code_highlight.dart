import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeSnippetFromImage extends StatefulWidget {
  const CodeSnippetFromImage({
    Key? key,
    required this.imageUrl,
    this.codeToCopy,
  }) : super(key: key);

  final String imageUrl;

  final String? codeToCopy;

  @override
  _CodeSnippetFromImageState createState() => _CodeSnippetFromImageState();
}

class _CodeSnippetFromImageState extends State<CodeSnippetFromImage> {
  bool showCopy = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => showCopy = true),
        onExit: (_) => setState(() => showCopy = false),
        child: Stack(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: kElevationToShadow[6],
            ),
            child: Image.network(widget.imageUrl, scale: 0.8,),
          ),
          if (widget.codeToCopy != null)
            Positioned(
              top: 3,
              right: 3.5,
              child: AnimatedOpacity(
                duration: kThemeAnimationDuration,
                opacity: showCopy ? 1 : 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    icon: Icon(Icons.copy, size: 16.0),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.codeToCopy));
                    },
                    splashRadius: 20.0,
                    tooltip: 'Copy to clipboard',
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

// import 'package:flutter/services.dart';

// import 'package:flutter_syntax_view/src/syntax/index.dart';

// import 'package:flutter_syntax_view/flutter_syntax_view.dart';

// export 'package:flutter_syntax_view/flutter_syntax_view.dart' show Syntax;

// class CodeHighlight extends StatefulWidget {
//   const CodeHighlight({
//     Key? key,
//     required this.code,
//     required this.syntax,
//   }) : super(key: key);

//   final String code;
//   final Syntax syntax;

//   @override
//   _CodeHighlightState createState() => _CodeHighlightState();
// }

// class _CodeHighlightState extends State<CodeHighlight> {

//   SyntaxTheme getSyntaxTheme() {
//     // TODO: work on these colors
//     switch (widget.syntax) {
//       case Syntax.YAML:
//         return SyntaxTheme(
//           keywordStyle: TextStyle(color: Color(0xFF48d985)),
//           commentStyle: TextStyle(color: Color(0xFF579fd2))
//         );
//       case Syntax.DART:
//         return SyntaxTheme(
//           keywordStyle: TextStyle(color: Color(0xFFea5d4f)),
//           commentStyle: TextStyle(color: Color(0xFF579fd2)),
//           classStyle: TextStyle(color: Color(0xFF459ad9)),
//           stringStyle: TextStyle(color: Color(0xFF48d985)),
//         );
//       default:
//         return SyntaxTheme.vscodeDark();
//     } 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6.0),
//         child: Container(
//           width: double.infinity,
//           color: const Color(0xFF1E1E1E),
//           // height: widget.height,
//           child: SyntaxView(
//             code: widget.code,
//             syntax: widget.syntax,
//             syntaxTheme: getSyntaxTheme(),
//             fontSize: 14.0,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // TODO: make a PR to the official repo to add text selection for it

// class SyntaxView extends StatefulWidget {
//   const SyntaxView({
//     required this.code,
//     required this.syntax,
//     this.syntaxTheme,
//     this.fontSize = 12.0,
//     this.copyCode = true,
//   });

//   /// Code text
//   final String code;

//   /// Syntax/Langauge (Dart, C, C++...)
//   final Syntax syntax;

//   /// Theme of syntax view example SyntaxTheme.dracula() (default: SyntaxTheme.dracula())
//   final SyntaxTheme? syntaxTheme;

//   /// Font Size with a default value of 12.0
//   final double fontSize;

//   final bool copyCode;

//   @override
//   State<StatefulWidget> createState() => SyntaxViewState();
// }

// class SyntaxViewState extends State<SyntaxView> {
//   /// For Zooming Controls
//   static const double MAX_FONT_SCALE_FACTOR = 3.0;
//   static const double MIN_FONT_SCALE_FACTOR = 0.5;
//   double _fontScaleFactor = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: <Widget>[
//       Container(
//         padding: const EdgeInsets.all(10),
//         color: widget.syntaxTheme?.backgroundColor,
//         width: double.infinity,
//         child: Scrollbar(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: buildCode(),
//           ),
//         ),
//       ),
//       if (widget.copyCode)
//         Positioned(
//           top: 3,
//           right: 3.5,
//           child: Material(
//             type: MaterialType.transparency,
//             child: IconButton(
//               icon: Icon(Icons.copy, size: 16.0),
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: widget.code));
//               },
//               splashRadius: 20.0,
//               tooltip: 'Copy to clipboard',
//             ),
//           ),
//         ),
//     ]);
//   }

//   Widget buildCode() {
//     return SelectableText.rich(
//       TextSpan(
//         style: TextStyle(fontFamily: 'monospace', fontSize: widget.fontSize),
//         children: <TextSpan>[
//           getSyntax(widget.syntax, widget.syntaxTheme).format(widget.code)
//         ],
//       ),
//       textScaleFactor: _fontScaleFactor,
//     );
//   }
// }

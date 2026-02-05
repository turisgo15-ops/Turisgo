import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';

class PantallaCreadores extends StatefulWidget {
  @override
  _PantallaCreadoresState createState() => _PantallaCreadoresState();
}

class _PantallaCreadoresState extends State<PantallaCreadores> {
  final PageController _controller = PageController(viewportFraction: 0.7);
  int indexActual = 0;
  Timer? _autoPlayTimer;

  final List<String> imagenes = [
    'assets/sena.jpg',
    'assets/vivi.jpeg',
    'assets/.jpg',
    'assets/.jpg',
  ];

  final List<String> titulos = [
    'Destino único',
    'Explora sin límites',
    'Aventuras inolvidables',
    'Tu pasaporte digital',
  ];

  final List<String> descripciones = [
    'Descubre destinos únicos creados para viajeros auténticos.',
    'Explora, sueña y vive cada experiencia al máximo.',
    'Viajar nunca fue tan fácil, seguro y emocionante.',
    'Turis-Go: tu pasaporte a un mundo de aventuras.',
  ];

  late List<bool> _isFlipped;

  @override
  void initState() {
    super.initState();
    _isFlipped = List.generate(imagenes.length, (_) => false);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!mounted) return;
      int next = (indexActual + 1) % imagenes.length;
      _controller.animateToPage(
        next,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  double _safePage() {
    return (_controller.hasClients && _controller.page != null)
        ? _controller.page!
        : indexActual.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== FLECHA DE RETROCESO =====
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 12),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // ===== SECCIÓN SOBRE NOSOTROS =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre nosotros',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'En Turis-Go nos apasiona ofrecer experiencias únicas para viajeros de todo el mundo. '
                      'Nuestro equipo selecciona los mejores destinos, rutas y recomendaciones para que cada aventura sea inolvidable. '
                      'Con nosotros, descubrirás lugares auténticos, recibirás tips locales y disfrutarás de un servicio seguro y confiable.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ===== CARRUSEL =====
              Container(
                height: 320,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: imagenes.length,
                  onPageChanged: (i) => setState(() => indexActual = i),
                  itemBuilder: (context, i) {
                    double page = _safePage();
                    double diff = (page - i).clamp(-1.0, 1.0);
                    double scale = (1 - diff.abs() * 0.2).clamp(0.8, 1.0);
                    double rotY = diff * 0.15;
                    double parallax = diff * 30;

                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isFlipped[i] = !_isFlipped[i]);
                          _startAutoPlay();
                        },
                        child: AnimatedScale(
                          scale: scale,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotY),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double size = min(
                                  constraints.maxWidth * 0.7,
                                  280,
                                );
                                return Container(
                                  width: size,
                                  height: size,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, _) {
                                            return Transform.translate(
                                              offset: Offset(parallax, 0),
                                              child: Image.asset(
                                                imagenes[i],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                        TweenAnimationBuilder<double>(
                                          tween: Tween<double>(
                                            begin: 0,
                                            end: _isFlipped[i] ? 1.0 : 0.0,
                                          ),
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          builder: (context, t, child) {
                                            final angle = t * pi;
                                            final isBack = angle > pi / 2;
                                            return Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..rotateY(angle),
                                              child: isBack
                                                  ? Transform(
                                                      alignment:
                                                          Alignment.center,
                                                      transform:
                                                          Matrix4.identity()
                                                            ..rotateY(pi),
                                                      child: _cardBack(i),
                                                    )
                                                  : _cardFront(i),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 12),

              // Indicadores minimalistas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imagenes.length, (i) {
                  bool active = i == indexActual;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? Colors.deepPurple : Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardFront(int i) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Container()),
        Positioned(
          bottom: 18,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                titulos[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black45,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Text(
                descripciones[i],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardBack(int i) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      padding: EdgeInsets.all(12),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titulos[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '${descripciones[i]} Conoce rutas, tips locales y recomendaciones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Reservar / Ver más'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

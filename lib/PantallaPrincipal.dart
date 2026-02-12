// PantallaPrincipal.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:turisgo/FormularioRegistro.dart';
import 'dart:math';

// Importación de pantallas y archivos externos
import 'FormularioRegistro.dart';
import 'FormularioIniciodesesion.dart';
import 'PantallaCreadores.dart';
import 'Idiomas.dart';
import 'VistaHotel.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _destinationController = TextEditingController();

  String _idioma = "Español";
  bool usuarioLogeado = false;

  Timer? _timerInvitado;
  bool _dialogMostrado = false;

  Map<String, bool> _isFlippedMap = {};
  List<String> _historialBusquedas = [];
  bool _mostrarHistorial = false;

  final List<Map<String, Map<String, String>>> items = [];
  final List<Map<String, Map<String, String>>> _itemsOriginales = [];
  List<Map<String, Map<String, String>>> _itemsFiltrados = [];

  String _seccionActiva = "Todo";
  String _lugarSeleccionado = "";

  @override
  void initState() {
    super.initState();
    _cargarItems();
    _itemsOriginales.addAll(items);
    _itemsFiltrados = List.from(items);

    for (var item in items) {
      _isFlippedMap[item["Español"]!["titulo"]!] = false;
    }

    // 👇 INICIA EL TIMER DEL INVITADO
    _iniciarTemporizadorInvitado();
  }

  @override
  void dispose() {
    _timerInvitado?.cancel(); // 👈 IMPORTANTE
    _scrollController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  // ================= TIMER INVITADO =================
  void _iniciarTemporizadorInvitado() {
    _timerInvitado?.cancel();

    _timerInvitado = Timer(const Duration(seconds: 5), () {
      if (!usuarioLogeado && !_dialogMostrado && mounted) {
        _dialogMostrado = true;
        _mostrarDialogInvitado();
      }
    });
  }

  void _mostrarDialogInvitado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Modo invitado"),
          content: const Text(
            "Has estado navegando por más de 20 minutos.\n\n"
            "¿Deseas continuar como invitado?",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185DDE),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Continuar como invitado",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cargarItems() {
    items.addAll([
      {
        "Español": {
          "titulo": "Cartagena",
          "informacion": "Cartagena es famosa por su arquitectura colonial.",
          "imagen": "assets/cali.jpg",
        },
        "Inglés": {
          "titulo": "Cartagena",
          "informacion": "Cartagena is known for its colonial architecture.",
          "imagen": "assets/cali.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Desierto de la Tatacoa",
          "informacion": "Paisajes únicos y cielos estrellados.",
          "imagen": "assets/desierto.jpg",
        },
        "Inglés": {
          "titulo": "Tatacoa Desert",
          "informacion": "Unique landscapes and starry skies.",
          "imagen": "assets/desierto.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Medellín",
          "informacion": "La ciudad de la eterna primavera.",
          "imagen": "assets/Medellin.jpg",
        },
        "Inglés": {
          "titulo": "Medellín",
          "informacion": "The city of eternal spring.",
          "imagen": "assets/Medellin.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Bogotá",
          "informacion": "Museos, gastronomía y vida nocturna.",
          "imagen": "assets/Bogota.jpg",
        },
        "Inglés": {
          "titulo": "Bogotá",
          "informacion": "Museums, gastronomy and nightlife.",
          "imagen": "assets/Bogota.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Santa Marta",
          "informacion": "Puerta de entrada al Parque Tayrona.",
          "imagen": "assets/Cartagenadeindias.jpg",
        },
        "Inglés": {
          "titulo": "Santa Marta",
          "informacion": "Gateway to Tayrona National Park.",
          "imagen": "assets/Cartagenadeindias.jpg",
        },
      },
      {
        "Español": {
          "titulo": "China",
          "informacion": "Templo.",
          "imagen": "assets/China.jpg",
        },
        "Inglés": {
          "titulo": "China",
          "informacion": "Temple.",
          "imagen": "assets/China.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Canada",
          "informacion": "Laguna.",
          "imagen": "assets/Canada.jpg",
        },
        "Inglés": {
          "titulo": "Canada",
          "informacion": "Lagoon.",
          "imagen": "assets/Canada.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Paris",
          "informacion": "Torre Eiffel.",
          "imagen": "assets/Paris.jpg",
        },
        "Inglés": {
          "titulo": "Paris",
          "informacion": "Eiffel Tower.",
          "imagen": "assets/Paris.jpg",
        },
      },
      {
        "Español": {
          "titulo": "Italia",
          "informacion": "calles principales.",
          "imagen": "assets/Italia.jpg",
        },
        "Inglés": {
          "titulo": "Italy",
          "informacion": "Main streets.",

          "imagen": "assets/Italia.jpg",
        },
      },
    ]);
  }

  void _buscar() {
    final texto = _destinationController.text.toLowerCase().trim();
    setState(() {
      if (texto.isEmpty) {
        _itemsFiltrados = List.from(_itemsOriginales);
        return;
      }

      if (!_historialBusquedas.contains(texto)) {
        _historialBusquedas.insert(0, texto);
      }

      _itemsFiltrados = _itemsOriginales.where((item) {
        final titulo = item[_idioma]!['titulo']!.toLowerCase();
        return titulo.contains(texto);
      }).toList();

      if (_itemsFiltrados.isNotEmpty) {
        _lugarSeleccionado = _itemsFiltrados.first[_idioma]!['titulo']!;
      }

      _mostrarHistorial = false;
    });
  }

  void _devolver() {
    setState(() {
      _destinationController.clear();
      _itemsFiltrados = List.from(_itemsOriginales);
      _seccionActiva = "";
      _lugarSeleccionado = "";
      _mostrarHistorial = false;
      _isFlippedMap.updateAll((key, value) => false);
    });
  }

  void _scroll(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSearchForm() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  onSubmitted: (_) => _buscar(),
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on_outlined),
                    hintText: Idiomas.textos[_idioma]!['a_donde_vas'],
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.close), onPressed: _devolver),
              IconButton(
                icon: Icon(
                  _mostrarHistorial
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
                onPressed: () =>
                    setState(() => _mostrarHistorial = !_mostrarHistorial),
              ),
              ElevatedButton(
                onPressed: _buscar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF185DDE),
                ),
                child: Text(
                  Idiomas.textos[_idioma]!['buscar']!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        if (_mostrarHistorial && _historialBusquedas.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              children: _historialBusquedas.map((e) {
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text(e),
                  onTap: () {
                    _destinationController.text = e;
                    _buscar();
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCard(Map<String, String> item, int index) {
    String titulo = item['titulo']!;
    bool isFlipped = _isFlippedMap[titulo] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlippedMap[titulo] = !isFlipped;
          _lugarSeleccionado = titulo;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(isFlipped ? pi : 0),
          child: isFlipped
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          item['informacion']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item['imagen']!,
                        height: 140,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: Colors.grey,
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _botonSeccion(String texto) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _seccionActiva = texto),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: _seccionActiva == texto
                ? Color(0xFF185DDE)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _seccionActiva == texto ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardHotel() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        height: 220,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGEN
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/hotel.jpg",
                    width: 160,
                    height: 220,
                    fit: BoxFit.cover,
                  ),

                  /// ETIQUETA SUPERIOR
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF185DDE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Recomendado",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// INFORMACIÓN
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NOMBRE
                    const Text(
                      "Hotel Las Islas",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// ESTRELLAS
                    Row(
                      children: const [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star_half, size: 16, color: Colors.amber),
                        SizedBox(width: 6),
                        Text(
                          "4.5",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// UBICACIÓN
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 15, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Barú, Cartagena",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// DESCRIPCIÓN
                    const Text(
                      "Hotel de lujo frente al mar, rodeado de naturaleza y experiencias exclusivas.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    /// PRECIO + BOTÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// PRECIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Desde",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "\$850.000",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF185DDE),
                              ),
                            ),
                            Text(
                              "por noche",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        /// BOTÓN VER MÁS
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VistaHotel(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF185DDE),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            "Ver más",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardRestaurante() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              "assets/restaurante.jpg",
              width: 150,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Restaurante",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "La Cevichería",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Mariscos • Cocina Caribe",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Centro Histórico, Cartagena",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// DESCRIPCIÓN
                  const Text(
                    "Restaurante emblemático conocido por su ceviche fresco y ambiente acogedor en el corazón de Cartagena.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        color: const Color(0xFF185DDE),
                        onPressed: () {
                          // agregar al carrito
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF185DDE),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Ver más",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTransporte() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/kia.jpg",
                  width: 140,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Cancelación gratis",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kia Picanto",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Auto económico o similar",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: const [
                      Text("👤 5 personas"),
                      Text("🧳 2 maletas pequeñas"),
                      Text("❄ Aire acondicionado"),
                      Text("⚙ Manual"),
                      Text("🛣 Ilimitado"),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Precio por día", style: TextStyle(color: Colors.grey)),
                Text(
                  "\$211.016",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00C08B),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    "Elegir fechas",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // RESULTADO
  Widget _cardResultado() {
    if (_seccionActiva.isEmpty) return SizedBox();

    if (_seccionActiva == "Todo") {
      return Column(
        children: [
          _cardHotel(),
          SizedBox(height: 16),
          _cardRestaurante(),
          SizedBox(height: 16),
          _cardTransporte(),
        ],
      );
    }

    switch (_seccionActiva) {
      case "Hoteles":
        return _cardHotel();
      case "Restaurantes":
        return _cardRestaurante();
      case "Transportes":
        return _cardTransporte();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF185DDE),
        elevation: 3,
        toolbarHeight: 70,
        title: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PantallaCreadores()),
          ),
          child: Text(
            "Turis-Go",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _idioma,
              items: [
                "Español",
                "Inglés",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _idioma = v!),
              dropdownColor: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormularioRegistro()),
            ),
            child: Text(
              Idiomas.textos[_idioma]!['registro']!,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormularioIniciodesesion()),
            ),
            child: Text(
              Idiomas.textos[_idioma]!['iniciar']!,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchForm(),
            SizedBox(height: 16),
            Text(
              Idiomas.textos[_idioma]!['lugares']!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _scroll(-300),
                ),
                Expanded(
                  child: SizedBox(
                    height: 220,
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _itemsFiltrados.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = _itemsFiltrados[index][_idioma]!;
                        return _buildCard(item, index);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _scroll(300),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _botonSeccion("Todo"),
                  _botonSeccion("Hoteles"),
                  _botonSeccion("Restaurantes"),
                  _botonSeccion("Transportes"),
                ],
              ),
            ),
            SizedBox(height: 16),
            _cardResultado(),
          ],
        ),
      ),
    );
  }
}

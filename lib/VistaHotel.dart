import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaHotel extends StatefulWidget {
  const VistaHotel({super.key});

  @override
  State<VistaHotel> createState() => _VistaHotelState();
}

class _VistaHotelState extends State<VistaHotel> {
  final PageController _pageController = PageController(viewportFraction: 0.92);

  int paginaActual = 0;
  int habitaciones = 1;
  int personas = 2;
  int precioNoche = 850000;

  int habitacionesDisponibles = 2;
  int capacidadPorHabitacion = 2;

  DateTimeRange? fechas;

  final List<String> imagenes = [
    "assets/hotel.jpg",
    "assets/hotel2.jpg",
    "assets/hotel3.jpg",
  ];

  int get noches => fechas == null ? 1 : fechas!.duration.inDays;

  int get total => noches * precioNoche * habitaciones;

  int get maxPersonas => habitaciones * capacidadPorHabitacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // 💻 MODO ESCRITORIO
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCarousel(),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: _buildReservaCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 4, child: _buildCalendarioDecorado()),
              ],
            );
          } else {
            // 📱 MODO MÓVIL
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildCarousel(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: _buildReservaCard(),
                  ),
                  const SizedBox(height: 30),
                  _buildCalendarioDecorado(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // ======================== CARRUSEL ========================

  Widget _buildCarousel() {
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imagenes.length,
            onPageChanged: (index) => setState(() => paginaActual = index),
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(imagenes[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagenes.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: paginaActual == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: paginaActual == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================== CARD RESERVA ========================

  Widget _buildReservaCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${NumberFormat("#,###").format(precioNoche)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF185DDE),
                    ),
                  ),
                  const Text("por noche", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const Icon(Icons.king_bed, size: 30, color: Color(0xFF185DDE)),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Habitaciones",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          _buildCounter(
            titulo: "Disponibles: $habitacionesDisponibles",
            valor: habitaciones,
            onAdd: () {
              if (habitaciones < habitacionesDisponibles) {
                setState(() => habitaciones++);
              }
            },
            onRemove: () {
              if (habitaciones > 1) {
                setState(() {
                  habitaciones--;
                  if (personas > maxPersonas) {
                    personas = maxPersonas;
                  }
                });
              }
            },
          ),

          const SizedBox(height: 20),

          const Text("Personas", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),

          _buildCounter(
            titulo: "Máx: $maxPersonas",
            valor: personas,
            onAdd: () {
              if (personas < maxPersonas) {
                setState(() => personas++);
              }
            },
            onRemove: () {
              if (personas > 1) {
                setState(() => personas--);
              }
            },
          ),

          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 18)),
              Text(
                "\$${NumberFormat("#,###").format(total)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185DDE),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Reservar ahora",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================== CALENDARIO DECORADO ========================

  Widget _buildCalendarioDecorado() {
    return Center(
      child: Container(
        width: 380,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🌿 Hoja superior
            Positioned(
              top: -10,
              left: -10,
              child: Icon(
                Icons.local_florist,
                size: 50,
                color: Colors.green.withOpacity(0.07),
              ),
            ),

            // 🌸 Hoja inferior
            Positioned(
              bottom: -10,
              right: -10,
              child: Icon(
                Icons.eco,
                size: 60,
                color: Colors.pink.withOpacity(0.07),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selecciona tu fecha",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                // 🔥 FORZAR ESPAÑOL SOLO AQUÍ
                Localizations.override(
                  context: context,
                  locale: const Locale('es'),
                  child: Builder(
                    builder: (context) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF185DDE),
                          ),
                        ),
                        child: SizedBox(
                          height: 300, // 🔥 Más pequeño real
                          child: CalendarDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            onDateChanged: (date) {
                              setState(() {
                                fechas = DateTimeRange(
                                  start: date,
                                  end: date.add(const Duration(days: 1)),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                if (fechas != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF185DDE).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      DateFormat('dd MMMM yyyy', 'es').format(fechas!.start),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter({
    required String titulo,
    required int valor,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo),
        Row(
          children: [
            _circleButton(Icons.remove, onRemove),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "$valor",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _circleButton(Icons.add, onAdd),
          ],
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF185DDE)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF185DDE)),
      ),
    );
  }
}

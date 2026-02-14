import 'package:flutter/material.dart';

class VistaHotel extends StatefulWidget {
  const VistaHotel({super.key});

  @override
  State<VistaHotel> createState() => _VistaHotelState();
}

class _VistaHotelState extends State<VistaHotel> {
  // --- CONFIGURACIÓN Y ESTADO ---
  final double precioNoche = 29.99;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  int numHabitaciones = 1;
  int numPersonas = 1;

  final List<String> misImagenes = [
    'assets/hotel.jpg',
    'assets/hotel2.jpg',
    'assets/hotel3.jpg',
  ];

  // --- LÓGICA DE CÁLCULOS ---

  // Calcula la diferencia de días entre las fechas seleccionadas
  int get cantidadNoches => (fechaInicio != null && fechaFin != null)
      ? fechaFin!.difference(fechaInicio!).inDays
      : 0;

  // CÁLCULO DINÁMICO: Se dispara cada vez que cambia el estado (setState)
  double get totalReserva =>
      cantidadNoches > 0 ? (cantidadNoches * precioNoche * numHabitaciones) : 0;

  void _onDaySelected(DateTime dia) {
    setState(() {
      if (fechaInicio == null || (fechaInicio != null && fechaFin != null)) {
        fechaInicio = dia;
        fechaFin = null;
      } else if (dia.isAfter(fechaInicio!)) {
        fechaFin = dia;
      } else {
        fechaInicio = dia;
        fechaFin = null;
      }
    });
  }

  // --- COMPONENTES DE INTERFAZ ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PARTE IZQUIERDA: Galería e Información
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF00332D), size: 28),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Villa Alhambra",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00332D)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildGaleriaGrid(),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      _TabItem(text: "Descripción general", isActive: true),
                      _TabItem(text: "Detalles"),
                      _TabItem(text: "Opiniones"),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // PARTE DERECHA: Panel de Reserva
            SizedBox(
              width: 380,
              child: _buildPanelReserva(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelReserva() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
          ]),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
                color: Color(0xFFFF7043),
                borderRadius: BorderRadius.vertical(top: Radius.circular(19))),
            child: const Center(
              child: Text("DISPONIBILIDAD",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                _buildCustomCalendar(),
                const Divider(height: 40),

                // Selector de Habitaciones (Afecta al precio total)
                _buildSelector(
                    label: "Habitaciones",
                    valor: numHabitaciones,
                    onChanged: (nuevoValor) {
                      setState(() {
                        numHabitaciones = nuevoValor;
                      });
                    }),
                const SizedBox(height: 15),

                // Selector de Personas
                _buildSelector(
                    label: "Personas",
                    valor: numPersonas,
                    onChanged: (nuevoValor) {
                      setState(() {
                        numPersonas = nuevoValor;
                      });
                    }),
                const SizedBox(height: 25),

                // Mostrar el precio solo si hay noches seleccionadas
                if (cantidadNoches > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Precio Final:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        Text("${totalReserva.toStringAsFixed(2)}€",
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF7043))),
                      ],
                    ),
                  ),

                ElevatedButton(
                    onPressed: cantidadNoches > 0 ? () {} : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7043),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 55)),
                    child: const Text("RESERVAR AHORA",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSelector(
      {required String label,
      required int valor,
      required Function(int) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey)),
        Row(
          children: [
            _btnContador(Icons.remove, () {
              if (valor > 1) onChanged(valor - 1);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("$valor",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _btnContador(Icons.add, () {
              onChanged(valor + 1);
            }),
          ],
        ),
      ],
    );
  }

  Widget _btnContador(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF00332D)),
      ),
    );
  }

  Widget _buildGaleriaGrid() {
    return SizedBox(
      height: 400,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _mostrarVisor(context, 0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(misImagenes[0], fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _mostrarVisor(context, 1),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(misImagenes[1],
                            fit: BoxFit.cover, width: double.infinity)),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _mostrarVisor(context, 2),
                    child: Stack(fit: StackFit.expand, children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:
                              Image.asset(misImagenes[2], fit: BoxFit.cover)),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                          child: Text("+4",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCalendar() {
    return Column(
      children: [
        const Text("FEBRERO 2026",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF00332D),
                fontSize: 16)),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 35,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7),
          itemBuilder: (context, i) {
            int diaNum = i - 5;
            if (diaNum < 1 || diaNum > 28) return const SizedBox();
            DateTime fechaActual = DateTime(2026, 2, diaNum);
            bool esInicio = fechaInicio != null &&
                fechaActual.isAtSameMomentAs(fechaInicio!);
            bool esFin =
                fechaFin != null && fechaActual.isAtSameMomentAs(fechaFin!);
            bool enRango = fechaInicio != null &&
                fechaFin != null &&
                fechaActual.isAfter(fechaInicio!) &&
                fechaActual.isBefore(fechaFin!);

            return GestureDetector(
              onTap: () => _onDaySelected(fechaActual),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: enRango
                      ? const Color(0xFFFFE0B2)
                      : (esInicio || esFin
                          ? const Color(0xFFFF7043)
                          : Colors.transparent),
                  shape:
                      esInicio || esFin ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius:
                      !esInicio && !esFin ? BorderRadius.circular(8) : null,
                ),
                child: Center(
                    child: Text("$diaNum",
                        style: TextStyle(
                            fontWeight: (esInicio || esFin)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: (esInicio || esFin)
                                ? Colors.white
                                : Colors.black))),
              ),
            );
          },
        ),
      ],
    );
  }

  void _mostrarVisor(BuildContext context, int inicial) {
    PageController controller = PageController(initialPage: inicial);
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: misImagenes.length,
                    itemBuilder: (context, index) => InteractiveViewer(
                      child:
                          Image.asset(misImagenes[index], fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                      left: 20,
                      child: _btnNavegacionVisor(
                          Icons.chevron_left,
                          () => controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut))),
                  Positioned(
                      right: 20,
                      child: _btnNavegacionVisor(
                          Icons.chevron_right,
                          () => controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut))),
                  Positioned(
                      top: 40,
                      right: 20,
                      child: IconButton(
                          icon: const Icon(Icons.close, size: 35),
                          onPressed: () => Navigator.pop(context))),
                ],
              ),
            ),
            Container(
              width: 350,
              color: Colors.white,
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Información",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00332D))),
                  const SizedBox(height: 50),
                  const Text("Descripción del lugar:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  const Text(
                      "Detalle de la fotografía seleccionada en el visor.",
                      style: TextStyle(color: Colors.grey, height: 1.6)),
                  const Spacer(),
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          side: const BorderSide(color: Color(0xFF00332D))),
                      child: const Text("Volver al álbum",
                          style: TextStyle(color: Color(0xFF00332D)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnNavegacionVisor(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.5),
        radius: 28,
        child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 32), onPressed: onTap));
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isActive;
  const _TabItem({required this.text, this.isActive = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 25, bottom: 12),
        child: Column(
          children: [
            Text(text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? const Color(0xFF004D40) : Colors.grey)),
            if (isActive)
              Container(
                  height: 2,
                  width: 40,
                  color: const Color(0xFF004D40),
                  margin: const EdgeInsets.only(top: 4)),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';

class PantallaCreadores extends StatelessWidget {
  const PantallaCreadores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Usamos Stack para que la flecha flote sobre todo
        children: [
          // 1. FONDO Y CONTENIDO
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E1E26), Color(0xFF0F0F12)],
              ),
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      automaticallyImplyLeading:
                          false, // Quitamos la flecha automática
                      title: Text("TURIS-GO STORY",
                          style: TextStyle(
                              letterSpacing: 4,
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              color: Colors.white70)),
                    ),

                    // --- ITINERARIO CENTRADO ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            const Text("NUESTRO CAMINO",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: 2)),
                            const SizedBox(height: 40),
                            _buildCentralStep(
                                label: "Inicio",
                                title: "El Nacimiento",
                                desc: "La visión de resaltar Purificación.",
                                isFirst: true),
                            _buildCentralStep(
                                label: "1",
                                title: "Conexión Local",
                                desc: "Mapeo de rutas y tesoros del Tolima."),
                            _buildCentralStep(
                                label: "2",
                                title: "Arquitectura",
                                desc: "Desarrollo del ecosistema digital."),
                            _buildCentralStep(
                                label: "Fin",
                                title: "Impacto Real",
                                desc: "Conectando al mundo con nuestra tierra.",
                                isLast: true),
                          ],
                        ),
                      ),
                    ),

                    // --- SECCIÓN EQUIPO CENTRADA ---
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 30),
                        const Center(
                          child: Text("EQUIPO MAESTRO",
                              style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                  fontSize: 16)),
                        ),
                        const SizedBox(height: 30),
                        _buildCentralCard(
                            nombre: "Sandra Patricia",
                            rol: "FOUNDER & CEO",
                            bio:
                                "Líder visionaria enfocada en el turismo sostenible."),
                        _buildCentralCard(
                            nombre: "Julian Cuellar",
                            rol: "TECH LEAD",
                            bio:
                                "Arquitecto de software y soluciones digitales."),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. LA FLECHA DE REGRESO (FLOTANTE)
          Positioned(
            top: 50, // Ajusta según el notch de tu celular
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.1), // Un fondito sutil para que se vea
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO (CENTRADOS) ---
  Widget _buildCentralStep(
      {required String label,
      required String title,
      required String desc,
      bool isFirst = false,
      bool isLast = false}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (label == "Inicio" || label == "Fin")
                ? Colors.yellow
                : const Color(0xFF1E1E26),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.yellow, width: 2),
          ),
          child: Center(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 10),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 13)),
        if (!isLast)
          Container(
              width: 2,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.yellow.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildCentralCard(
      {required String nombre, required String rol, required String bio}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white10,
              child: Icon(Icons.person, color: Colors.white24)),
          const SizedBox(height: 15),
          Text(rol,
              style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          Text(nombre,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(bio,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
        ],
      ),
    );
  }
}

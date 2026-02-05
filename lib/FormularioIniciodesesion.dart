import 'package:flutter/material.dart';

class FormularioIniciodesesion extends StatefulWidget {
  @override
  State<FormularioIniciodesesion> createState() =>
      _FormularioIniciodesesionState();
}

class _FormularioIniciodesesionState extends State<FormularioIniciodesesion> {
  final _formKey = GlobalKey<FormState>();

  String _errorMensaje = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF3EDF7),

      body: Column(
        children: [
          const SizedBox(height: 40),

          // ------------------ FLECHA ------------------
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // ------------------ TITULO TURISGO ------------------
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "T  U  R  I  S  G  O",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
                color: Color(0xff0099F9),
                shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Color(0xff0099F9),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: screenWidth * 0.5,
                  child: Card(
                    color: const Color.fromARGB(255, 229, 243, 219),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ------------------ INICIAR SESION ------------------
                            Text(
                              "Iniciar Sesión",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 174, 255),
                              ),
                            ),

                            // ------------------ ADVERTENCIA ------------------
                            if (_errorMensaje.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  _errorMensaje,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            SizedBox(height: 16),

                            // ------------------ CORREO ------------------
                            TextFormField(
                              decoration: InputDecoration(
                                iconColor: Colors.red,
                                icon: Icon(Icons.email),
                                labelText: "Correo electrónico",
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ingresa tu correo";
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return "Correo inválido";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            // ------------------ CONTRASEÑA ------------------
                            TextFormField(
                              decoration: InputDecoration(
                                iconColor: Colors.blue,
                                icon: Icon(Icons.key),
                                labelText: "Contraseña",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ingresa tu contraseña";
                                }
                                if (value.length < 6) {
                                  return "Mínimo 6 caracteres";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 24),

                            // ------------------ BOTON ------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_formKey.currentState!.validate()) {
                                        _errorMensaje = "";
                                      } else {
                                        _errorMensaje =
                                            "⚠️ Complete correctamente todos los campos";
                                      }
                                    });
                                  },
                                  child: Text(
                                    "Guardar Datos",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

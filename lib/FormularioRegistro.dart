import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'FormularioIniciodesesion.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({Key? key}) : super(key: key);

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  final nombreUsuarioCtrl = TextEditingController();
  final empresaCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final contrasenaCtrl = TextEditingController();
  final confirmarCtrl = TextEditingController();
  final categoriaCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  bool cargando = false;
  bool verPassword = false;
  bool registroExitoso = false;

  late AnimationController _buttonController;
  late AnimationController _scaleController;

  late Animation<double> _widthAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1,
    )..value = 1;

    _widthAnimation = Tween<double>(begin: 320, end: 70).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> registrar() async {
    _scaleController.reverse();
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();

    setState(() {
      cargando = true;
      registroExitoso = false;
    });

    await _buttonController.forward();

    try {
      final email = correoCtrl.text.trim();
      final password = contrasenaCtrl.text.trim();

      if (password != confirmarCtrl.text.trim()) {
        throw Exception("Las contraseñas no coinciden");
      }

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw Exception("Error al autenticar");

      await supabase.from('usuarios').upsert({
        'id': user.id,
        'correo': email,
        'tipo_usuario': "Empresario",
        'nombre_usuario': nombreUsuarioCtrl.text.trim(),
        'telefono': telefonoCtrl.text.trim(),
        'empresa': empresaCtrl.text.trim(),
        'categoria_servicios': categoriaCtrl.text.trim(),
      });

      setState(() {
        registroExitoso = true;
      });

      await Future.delayed(const Duration(milliseconds: 800));
      mostrarExito();
    } catch (e) {
      await _buttonController.reverse();
    }

    if (mounted) {
      setState(() {
        cargando = false;
      });
    }
  }

  void mostrarExito() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Éxito",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Colors.cyanAccent, Colors.greenAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.flight_takeoff, color: Colors.white, size: 80),
                    SizedBox(height: 20),
                    Text(
                      "¡Listo para viajar!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FormularioIniciodesesion()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.cyanAccent,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Formulario de Registro",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.cyanAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 380,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1B2A),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              _input("Nombre", nombreUsuarioCtrl, Icons.person),
                              _input("Empresa", empresaCtrl, Icons.business),
                              _input("Correo", correoCtrl, Icons.email),
                              _password("Contraseña", contrasenaCtrl),
                              _password("Confirmar", confirmarCtrl),
                              _input(
                                "Categoría",
                                categoriaCtrl,
                                Icons.category,
                              ),
                              _input("Teléfono", telefonoCtrl, Icons.phone),
                              const SizedBox(height: 30),
                              AnimatedBuilder(
                                animation: _buttonController,
                                builder: (context, child) {
                                  return ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      height: 60,
                                      width: _widthAnimation.value,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.cyanAccent,
                                            Colors.pinkAccent,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyanAccent
                                                .withOpacity(0.6),
                                            blurRadius: 20,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(40),
                                        onTap: cargando ? null : registrar,
                                        child: Center(
                                          child: registroExitoso
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 30,
                                                )
                                              : cargando
                                              ? const SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      ),
                                                )
                                              : const Text(
                                                  "REGISTRAR",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "¿Ya tienes cuenta? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormularioIniciodesesion(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Inicia sesión",
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.cyanAccent,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.cyanAccent),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          filled: true,
          fillColor: const Color(0xFF0D1B2A).withOpacity(0.8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _password(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: !verPassword,
        style: const TextStyle(color: Colors.cyanAccent),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          prefixIcon: const Icon(Icons.lock, color: Colors.cyanAccent),
          filled: true,
          fillColor: const Color(0xFF0D1B2A).withOpacity(0.8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              verPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.cyanAccent,
            ),
            onPressed: () {
              setState(() {
                verPassword = !verPassword;
              });
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormularioRegistro extends StatefulWidget {
  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  bool _cargando = false;
  bool _verContrasena = false;

  String? _tipoUsuario;
  String _mensajeError = "";

  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController contrasenaCtrl = TextEditingController();

  // =========================
  // REGISTRO EN SUPABASE
  // =========================
  Future<void> _enviarDatos() async {
    setState(() => _mensajeError = "");

    if (_tipoUsuario == null ||
        nombreCtrl.text.isEmpty ||
        correoCtrl.text.isEmpty ||
        contrasenaCtrl.text.isEmpty) {
      setState(() {
        _mensajeError = "⚠ Complete todos los campos.";
      });
      return;
    }

    setState(() => _cargando = true);

    try {
      final supabase = Supabase.instance.client;

      // 1️⃣ Crear usuario en Auth
      final response = await supabase.auth.signUp(
        email: correoCtrl.text.trim(),
        password: contrasenaCtrl.text,
      );

      final user = response.user;
      if (user == null) throw "No se pudo crear el usuario";

      // 2️⃣ Guardar datos adicionales
      await supabase.from('usuarios').insert({
        'id': user.id,
        'nombre_completo': nombreCtrl.text.trim(),
        'correo': correoCtrl.text.trim(),
        'tipo_usuario': _tipoUsuario,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Registro exitoso")));

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _mensajeError = e.toString();
      });
    }

    setState(() => _cargando = false);
  }

  // =========================
  // RECUPERAR CONTRASEÑA
  // =========================
  void _recuperarContrasena() {
    final correoRecuperacionCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Recuperar contraseña"),
        content: TextField(
          controller: correoRecuperacionCtrl,
          decoration: InputDecoration(labelText: "Correo electrónico"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Supabase.instance.client.auth.resetPasswordForEmail(
                  correoRecuperacionCtrl.text.trim(),
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "📧 Revisa tu correo para cambiar la contraseña",
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Error al enviar correo")),
                );
              }
            },
            child: Text("Enviar"),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3EDF7),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            "T  U  R  I  S  G  O",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: Color(0xff0099F9),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 800,
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Color(0xffDCEFD4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "REGISTRO",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0099F9),
                        ),
                      ),
                      SizedBox(height: 25),

                      DropdownButtonFormField<String>(
                        value: _tipoUsuario,
                        decoration: InputDecoration(
                          labelText: "Tipo de usuario",
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Empresario",
                            child: Text("Empresario"),
                          ),
                          DropdownMenuItem(
                            value: "Particular",
                            child: Text("Particular"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _tipoUsuario = value);
                        },
                      ),

                      SizedBox(height: 25),

                      _campoTexto(Icons.person, "Nombre completo", nombreCtrl),
                      _campoTexto(
                        Icons.email,
                        "Correo electrónico",
                        correoCtrl,
                      ),
                      _campoPassword(),

                      if (_mensajeError.isNotEmpty)
                        Text(
                          _mensajeError,
                          style: TextStyle(color: Colors.red),
                        ),

                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _cargando ? null : _enviarDatos,
                        child: _cargando
                            ? CircularProgressIndicator()
                            : Text("Enviar"),
                      ),

                      SizedBox(height: 10),

                      TextButton(
                        onPressed: _recuperarContrasena,
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(IconData icon, String label, TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(labelText: label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoPassword() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Icon(Icons.lock),

          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: contrasenaCtrl,
              obscureText: !_verContrasena,
              decoration: InputDecoration(
                iconColor: Colors.blue,
                labelText: "Contraseña",
                suffixIcon: IconButton(
                  icon: Icon(
                    _verContrasena ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _verContrasena = !_verContrasena;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

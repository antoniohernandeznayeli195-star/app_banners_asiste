import 'package:app_banners_asiste/domain/models/banner_model.dart';
import 'package:app_banners_asiste/presentation/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerAddPage extends StatefulWidget {
  final String imageUrl;
  const BannerAddPage({super.key, required this.imageUrl});

  @override
  State<BannerAddPage> createState() => _BannerAddPageState();
}

class _BannerAddPageState extends State<BannerAddPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final targetPageController = TextEditingController();
  final createdIdController = TextEditingController();
  bool openExternal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124),
      appBar: AppBar(
        title: const Text("Nuevo Banner", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            
            _buildLabel("Título"),
            _buildTextField(titleController, "Escribe el título..."),
            
            _buildLabel("Cuerpo (Body)"),
            _buildTextField(bodyController, "Descripción corta...", maxLines: 3),

            _buildLabel("URL Destino (Solo lectura)"),
            _buildTextField(TextEditingController(text: widget.imageUrl), "", readOnly: true, maxLines: null),

            _buildLabel("Página Flutter (Target)"),
            _buildTextField(targetPageController, "ej. /details_page"),

            _buildLabel("ID de Creador"),
            _buildTextField(createdIdController, "Nombre o ID"),

            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Abrir Externo", style: TextStyle(color: Colors.white)),
              value: openExternal,
              activeColor: Colors.green,
              onChanged: (v) => setState(() => openExternal = v),
            ),

            
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      final newBanner = BannerModel(
                        title: titleController.text,
                        imageUrl: widget.imageUrl,
                        url: widget.imageUrl,
                        openExternal: openExternal,
                        body: bodyController.text,
                        createdId: createdIdController.text,
                        goToTitle: titleController.text,
                        targetPageFlutter: targetPageController.text,
                      );
                      
                      await context.read<BannerProvider>().confirmAddBanner(newBanner);
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text("Finalizar", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int? maxLines = 1, bool readOnly = false}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
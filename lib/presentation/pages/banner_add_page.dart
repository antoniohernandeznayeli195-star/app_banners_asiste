import 'package:app_banners_asiste/domain/models/banner_model.dart';
import 'package:app_banners_asiste/presentation/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsertPosition { // Clase para meter la posicion de la imagen
  final String label;
  final int index;
  InsertPosition({required this.label, required this.index});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsertPosition &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          index == other.index;

  @override
  int get hashCode => label.hashCode ^ index.hashCode; 
}

class BannerAddPage extends StatefulWidget {
  final String imageUrl;
  final List<BannerModel> existingBanners;

  const BannerAddPage({
    super.key,
    required this.imageUrl,
    required this.existingBanners,
  });

  @override
  State<BannerAddPage> createState() => _BannerAddPageState();
}

class _BannerAddPageState extends State<BannerAddPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final targetPageController = TextEditingController();
  final createdIdController = TextEditingController();
  bool openExternal = false;

  late List<InsertPosition> _options;
  late InsertPosition selectedPosition;

  @override
  void initState() {
    super.initState();

    _options = buildInsertOptions();
    selectedPosition = _options.last;
    /*selectedPosition = InsertPosition(
      label: 'Al final',
      index: widget.existingBanners.length,
    );*/
  }

  List<InsertPosition> buildInsertOptions() {
    final options = <InsertPosition>[];
    options.add(InsertPosition(label: 'Al inicio', index: 0));
    for (int i = 0; i < widget.existingBanners.length; i++) {
      options.add(
        InsertPosition(
          label: 'Posición ${i + 2}: Después de "${widget.existingBanners[i].title}"',
          index: i + 1,
        ),
      );
    }
    if (widget.existingBanners.isNotEmpty) {
      options.add(InsertPosition(
        label: 'Al final',
        index: widget.existingBanners.length,
      ));
    }
    return options;
  }

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
            const SizedBox(height: 15),
            _buildPositionSelector(),
            const SizedBox(height: 20),
            _buildLabel("Título"),
            _buildTextField(titleController, "Escribe el título..."),
            _buildLabel("Cuerpo (Body)"),
            _buildTextField(bodyController, "Descripción corta...", maxLines: 3),
            _buildLabel("URL Destino (Solo lectura)"),
            _buildTextField(
              TextEditingController(text: widget.imageUrl),
              "",
              readOnly: true,
              maxLines: null,
            ),
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
                      await context.read<BannerProvider>().confirmAddBanner(
                        newBanner,
                        index: selectedPosition.index,
                      );
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

  Widget _buildPositionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2124),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Elige la posicion",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2F33),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<InsertPosition>(
              value: selectedPosition,
              dropdownColor: const Color(0xFF2C2F33),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              isExpanded: true,
              items: _options.map((pos) {
                return DropdownMenuItem(
                  value: pos,
                  child: Text(
                    pos.label,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedPosition = value);
              },
            ),
          ),
        ),
      ],
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/banner_model.dart';
import '../providers/banner_provider.dart';

class InsertPosition {
  final String label;
  final int index;
  InsertPosition({required this.label, required this.index});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsertPosition && label == other.label && index == other.index;

  @override
  int get hashCode => label.hashCode ^ index.hashCode;
}

class BannerAddPage extends StatefulWidget {
  final String imageUrl;
  final List<BannerModel> existingBanners;

  const BannerAddPage({super.key, required this.imageUrl, required this.existingBanners});

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
    _options = _buildOptions();
    selectedPosition = _options.last;
  }

  List<InsertPosition> _buildOptions() {
    final options = <InsertPosition>[InsertPosition(label: 'Al inicio', index: 0)];
    for (int i = 0; i < widget.existingBanners.length; i++) {
      options.add(InsertPosition(
        label: 'Posición ${i + 2}: Después de "${widget.existingBanners[i].title}"',
        index: i + 1,
      ));
    }
    if (widget.existingBanners.isEmpty) selectedPosition = options.first;
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124),
      appBar: AppBar(title: const Text("Nuevo Banner"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.network(widget.imageUrl, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            _buildDropdown(),
            _buildTextField(titleController, "Título"),
            _buildTextField(bodyController, "Cuerpo", maxLines: 3),
            _buildTextField(targetPageController, "Página Flutter"),
            _buildTextField(createdIdController, "ID Creador"),
            SwitchListTile(
              title: const Text("Abrir Externo", style: TextStyle(color: Colors.white)),
              value: openExternal,
              onChanged: (v) => setState(() => openExternal = v),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<BannerProvider>();
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
                await provider.confirmAddBanner(newBanner, index: selectedPosition.index);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Finalizar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<InsertPosition>(
      value: selectedPosition,
      isExpanded: true,
      dropdownColor: const Color(0xFF2C2F33),
      items: _options.map((pos) => DropdownMenuItem(value: pos, child: Text(pos.label, style: const TextStyle(color: Colors.white)))).toList(),
      onChanged: (v) => setState(() => selectedPosition = v!),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white70)),
    );
  }
}
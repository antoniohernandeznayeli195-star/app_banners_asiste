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
        label: 'Después de "${widget.existingBanners[i].title}"',
        index: i + 1,
      ));
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Detalles del Banner", 
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            _buildLabel("Título"),
            _buildInput(titleController),
            _buildLabel("Cuerpo (Body)"),
            _buildInput(bodyController),
            const SizedBox(height: 20),
            _buildUrlBox(),
            _buildLabel("Página Flutter (Target)"),
            _buildInput(targetPageController),
            _buildLabel("ID de Creador"),
            _buildInput(createdIdController),
            _buildLabel("Posición"),
            _buildDropdown(),
            const SizedBox(height: 15),
            _buildSwitch(),
            const SizedBox(height: 40),
            _buildActionButtons(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
      );

  Widget _buildInput(TextEditingController controller) => TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      );

  Widget _buildUrlBox() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C343B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("URL Destino", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 6),
            Text(widget.imageUrl, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      );

  Widget _buildDropdown() => DropdownButtonHideUnderline(
        child: DropdownButton<InsertPosition>(
          value: selectedPosition,
          isExpanded: true,
          dropdownColor: const Color(0xFF2C2F33),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
          items: _options.map((pos) => DropdownMenuItem(value: pos, child: Text(pos.label, style: const TextStyle(color: Colors.white, fontSize: 14)))).toList(),
          onChanged: (v) => setState(() => selectedPosition = v!),
        ),
      );

  Widget _buildSwitch() => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text("Abrir Externo", style: TextStyle(color: Colors.white, fontSize: 15)),
        value: openExternal,
        activeColor: const Color(0xFF81C784),
        onChanged: (v) => setState(() => openExternal = v),
      );

  Widget _buildActionButtons(BuildContext context) => Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF2C2F33),
                    title: const Text("Confirmar", style: TextStyle(color: Colors.white)),
                    content: const Text("¿Estás segura de que deseas crear este banner y subir toda la información al servidor?", style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar", style: TextStyle(color: Colors.white54))),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Finalizar", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ) ?? false;

                if (confirm) {
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
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF81C784), Color(0xFFAED581)]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text("Finalizar", style: TextStyle(color: Color(0xFF1E2124), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      );
}
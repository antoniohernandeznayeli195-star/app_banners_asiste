import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/banner_model.dart';
import '../providers/banner_provider.dart';

class BannerDetailPage extends StatefulWidget {
  final BannerModel banner;
  const BannerDetailPage({super.key, required this.banner});

  @override
  State<BannerDetailPage> createState() => _BannerDetailPageState();
}

class _BannerDetailPageState extends State<BannerDetailPage> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _targetPageController;
  late TextEditingController _createdIdController;
  late bool _openExternal;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner.title);
    _bodyController = TextEditingController(text: widget.banner.body);
    _targetPageController = TextEditingController(text: widget.banner.targetPageFlutter);
    _createdIdController = TextEditingController(text: widget.banner.createdId);
    _openExternal = widget.banner.openExternal;
  }

  void _save() async {
    final updated = BannerModel(
      title: _titleController.text,
      imageUrl: widget.banner.imageUrl,
      url: widget.banner.url,
      openExternal: _openExternal,
      body: _bodyController.text,
      createdId: _createdIdController.text,
      goToTitle: _titleController.text,
      targetPageFlutter: _targetPageController.text,
    );
    await context.read<BannerProvider>().updateBanner(widget.banner, updated);
    if (mounted) setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detalles del Banner", 
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.green),
            onPressed: () => _isEditing ? _save() : setState(() => _isEditing = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.banner.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            _buildLabel("Título"),
            _buildInput(_titleController),
            _buildLabel("Cuerpo (Body)"),
            _buildInput(_bodyController),
            const SizedBox(height: 20),
            _buildUrlBox(),
            _buildLabel("Página Flutter (Target)"),
            _buildInput(_targetPageController),
            _buildLabel("ID de Creador"),
            _buildInput(_createdIdController),
            const SizedBox(height: 15),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Abrir Externo", style: TextStyle(color: Colors.white, fontSize: 15)),
              value: _openExternal,
              activeColor: const Color(0xFF81C784),
              onChanged: _isEditing ? (v) => setState(() => _openExternal = v) : null,
            ),
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
        readOnly: !_isEditing,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _isEditing ? Colors.white38 : Colors.white10)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
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
            Text(widget.banner.imageUrl, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      );
}
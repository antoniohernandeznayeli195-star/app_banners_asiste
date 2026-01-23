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
  late TextEditingController _urlController;
  late bool _openExternal;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner.title);
    _urlController = TextEditingController(text: widget.banner.url);
    _openExternal = widget.banner.openExternal;
  }

  void _save() async {
    final updated = BannerModel(
      title: _titleController.text,
      imageUrl: widget.banner.imageUrl,
      url: _urlController.text,
      openExternal: _openExternal,
      body: widget.banner.body,
      createdId: widget.banner.createdId,
      goToTitle: widget.banner.goToTitle,
      targetPageFlutter: widget.banner.targetPageFlutter,
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
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () => _isEditing ? _save() : setState(() => _isEditing = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Image.network(widget.banner.imageUrl, height: 200, fit: BoxFit.contain),
            const SizedBox(height: 20),
            _buildField("Título", _titleController),
            _buildField("URL Destino", _urlController),
            SwitchListTile(
              title: const Text("Abrir Externo", style: TextStyle(color: Colors.white)),
              value: _openExternal,
              onChanged: _isEditing ? (v) => setState(() => _openExternal = v) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white70)),
    );
  }
}
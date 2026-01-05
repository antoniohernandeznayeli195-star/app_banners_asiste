import 'dart:io';
import 'package:flutter/foundation.dart';
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

  void _save() {
    final updated = BannerModel(
      title: _titleController.text,
      imageUrl: widget.banner.imageUrl,
      url: _urlController.text,
      openExternal: _openExternal,
    );
    context.read<BannerProvider>().updateBanner(widget.banner, updated);
    setState(() => _isEditing = false);
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
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () => _isEditing ? _save() : setState(() => _isEditing = true),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _buildImage(widget.banner.imageUrl),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildField("Título", _titleController),
            _buildField("URL de Destino", _urlController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SwitchListTile(
                title: const Text("Abrir en navegador externo", 
                  style: TextStyle(color: Colors.white, fontSize: 16)),
                value: _openExternal,
                activeColor: Colors.green,
                onChanged: _isEditing ? (val) => setState(() => _openExternal = val) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        enabled: _isEditing,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http') || kIsWeb) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
      );
    }
    return Image.file(
      File(url),
      fit: BoxFit.contain,
      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
    );
  }
}
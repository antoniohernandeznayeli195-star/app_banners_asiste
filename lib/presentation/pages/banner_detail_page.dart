import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/banner_model.dart';
import '../../presentation/providers/banner_provider.dart';

class BannerDetailPage extends StatefulWidget {
  final BannerModel banner;
  const BannerDetailPage({super.key, required this.banner});

  @override
  State<BannerDetailPage> createState() => _BannerDetailPageState();
}

class _BannerDetailPageState extends State<BannerDetailPage> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _idController;
  late TextEditingController _imageUrlController;
  late bool _openExternal;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner.title);
    _idController = TextEditingController(text: widget.banner.identifier);
    _imageUrlController = TextEditingController(text: widget.banner.imageUrl);
    _openExternal = widget.banner.openExternal;
  }

  Future<void> _launchImageURL() async {
    final String urlText = _imageUrlController.text.trim();
    if (!urlText.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La ImageURL no es un enlace web")),
      );
      return;
    }
    final Uri url = Uri.parse(urlText);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo abrir: $e")),
      );
    }
  }

  void _saveChanges() {
    final updatedBanner = BannerModel(
      title: _titleController.text,
      imageUrl: _imageUrlController.text,
      identifier: _idController.text,
      openExternal: _openExternal,
      url: widget.banner.url,
    );
    context.read<BannerProvider>().updateBanner(widget.banner, updatedBanner);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cambios guardados")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white, size: 28),
            onPressed: () {
              if (_isEditing) _saveChanges();
              else setState(() => _isEditing = true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPreviewImage(_imageUrlController.text),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text("Propiedades",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 25),
                  _buildEditableField("Título", _titleController),
                  _buildEditableField("Identifier", _idController),
                  _buildEditableField("Image URL", _imageUrlController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Open External", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const Spacer(),
                      Switch(
                        value: _openExternal,
                        activeColor: Colors.green,
                        onChanged: _isEditing ? (val) => setState(() => _openExternal = val) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _launchImageURL,
                      icon: const Icon(Icons.image_search, color: Colors.white),
                      label: const Text("Previsualizar Imagen"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Image.asset('assets/images/pemex_logo.png', height: 40,
                errorBuilder: (c, e, s) => const Text("PEMEX", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w300)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: _isEditing,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              disabledBorder: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          if (!_isEditing) const Divider(color: Colors.white38),
        ],
      ),
    );
  }

  Widget _buildPreviewImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80, color: Colors.grey));
    } else {
      return Image.file(File(url), fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80, color: Colors.grey));
    }
  }
}
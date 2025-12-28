import 'dart:io';
import 'package:app_banners_asiste/presentation/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/banner_model.dart';
import 'banner_detail_page.dart';

class BannersPage extends StatefulWidget {
  final String type;
  const BannersPage({super.key, required this.type});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _showAddBannerForm(String imagePath) async {
    final titleController = TextEditingController();
    final identifierController = TextEditingController();
    final urlController = TextEditingController();
    bool openExternal = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E2124),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Nuevo Banner", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(imagePath), height: 100, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                _buildTextField(titleController, "Título"),
                _buildTextField(identifierController, "Identifier (Ej: login)"),
                _buildTextField(urlController, "URL (Opcional)"),
                SwitchListTile(
                  title: const Text("Abrir Externo", style: TextStyle(color: Colors.white, fontSize: 14)),
                  value: openExternal,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => openExternal = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<BannerProvider>().addBannerCustom(
                    title: titleController.text,
                    path: imagePath,
                    id: identifierController.text,
                    url: urlController.text,
                    external: openExternal,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        _showAddBannerForm(image.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().loadBanners(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = context.watch<BannerProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/images/pemex_logo.png', height: 35,
          errorBuilder: (c, e, s) => const Text("Banners", style: TextStyle(color: Colors.black))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 30),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: bannerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              padding: const EdgeInsets.all(20),
              onReorder: bannerProvider.reorderBanners,
              children: bannerProvider.banners.asMap().entries.map((entry) {
                return _buildBannerCard(entry.value, entry.key, bannerProvider);
              }).toList(),
            ),
    );
  }

  Widget _buildBannerCard(BannerModel banner, int index, BannerProvider provider) {
    return GestureDetector(
      key: ValueKey('banner_${banner.imageUrl}_$index'),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BannerDetailPage(banner: banner))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: const Color(0xFFBDBDBD), borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageWidget(banner.imageUrl),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(banner.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => provider.removeBanner(banner),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, height: 180, fit: BoxFit.cover, errorBuilder: (c, e, s) => _errorWidget());
    } else {
      return Image.file(File(url), height: 180, fit: BoxFit.cover, errorBuilder: (c, e, s) => _errorWidget());
    }
  }

  Widget _errorWidget() => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image, size: 50, color: Colors.grey));
}
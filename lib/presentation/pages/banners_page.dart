import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/banner_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().loadBanners(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BannerProvider>();
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
            onPressed: () async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) _showAddBannerForm(image.path);
            },
          ),
        ],
      ),
      body: provider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onReorder: provider.reorderBanners,
            children: provider.banners.map((banner) => _buildCard(banner, provider)).toList(),
          ),
    );
  }

  Widget _buildCard(BannerModel banner, BannerProvider provider) {
    return Container(
      key: ValueKey(banner.imageUrl + banner.title),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => BannerDetailPage(banner: banner))
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    //width: 500,
                    constraints: const BoxConstraints(minHeight: 100),
                    child: _buildPreviewImage(banner.imageUrl),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 194, 193, 193),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => provider.removeBanner(banner),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                banner.title.isEmpty ? "Sin título" : banner.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String url) {
    if (url.startsWith('http') || kIsWeb) {
      return Image.network(
        url, 
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (c, e, s) => const SizedBox(height: 150, child: Icon(Icons.image, size: 50, color: Colors.grey)),
      );
    }
    return Image.file(
      File(url), 
      fit: BoxFit.cover,
      alignment: Alignment.center,
      //Cargador de la imagen
      errorBuilder: (c, e, s) => const SizedBox(height: 150, child: Icon(Icons.image, size: 50, color: Colors.grey)),
    );
  }

  Future<void> _showAddBannerForm(String imagePath) async {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    bool openExternal = false;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E2124),
          title: const Text("Nuevo Banner", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Título", labelStyle: TextStyle(color: Colors.white70))),
                TextField(controller: urlController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "URL", labelStyle: TextStyle(color: Colors.white70))),
                SwitchListTile(
                  title: const Text("Abrir Externo", style: TextStyle(color: Colors.white)),
                  value: openExternal,
                  onChanged: (v) => setState(() => openExternal = v),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(onPressed: () {
              context.read<BannerProvider>().addBannerCustom(title: titleController.text, path: imagePath, url: urlController.text, external: openExternal);
              Navigator.pop(context);
            }, child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
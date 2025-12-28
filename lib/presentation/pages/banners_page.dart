import 'dart:io';
import 'package:app_banners_asiste/presentation/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/banner_model.dart';

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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        context.read<BannerProvider>().addBanner("Nuevo Banner", image.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = context.watch<BannerProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Image.asset('assets/images/pemex_logo.png', height: 35,
          errorBuilder: (c, e, s) => const Text("Banners")),
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
    return Container(
      key: ValueKey('banner_${banner.imageUrl}_$index'),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageWidget(banner.imageUrl),
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.black12,
                child: Text(
                  banner.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => provider.removeBanner(banner),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, height: 180, fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _errorWidget());
    } else {
      return Image.file(File(url), height: 180, fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _errorWidget());
    }
  }

  Widget _errorWidget() {
    return Container(height: 180, color: Colors.grey[400],
      child: const Icon(Icons.broken_image, size: 50));
  }
}
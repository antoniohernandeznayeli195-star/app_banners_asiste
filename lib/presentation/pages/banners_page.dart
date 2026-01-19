import 'dart:io';
import 'package:app_banners_asiste/presentation/pages/banner_add_page.dart';
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

  Future<void> _handleNewBannerFlow() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final provider = context.read<BannerProvider>();

    try {
      final String? remoteUrl = await provider.uploadTempImage(image.path);

      if (remoteUrl != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BannerAddPage(imageUrl: remoteUrl, existingBanners: provider.banners,),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        title: Image.asset(
          'assets/images/pemex_logo.png',
          height: 35,
          errorBuilder: (c, e, s) => const Text(
            "Banners",
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 30),
            onPressed: _handleNewBannerFlow,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onReorder: provider.reorderBanners,
              children: provider.banners
                  .map((banner) => _buildCard(banner, provider))
                  .toList(),
            ),
    );
  }

  Widget _buildCard(BannerModel banner, BannerProvider provider) {
    return GestureDetector(
      key: ValueKey("${banner.imageUrl}${banner.title}"),
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BannerDetailPage(banner: banner),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(20),
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
                  child: _buildPreviewImage(banner.imageUrl),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
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
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const SizedBox(
          height: 150,
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    }
    return Image.file(
      File(url),
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
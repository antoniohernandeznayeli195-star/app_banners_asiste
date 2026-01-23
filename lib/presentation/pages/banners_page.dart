import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/banner_provider.dart';
import 'banner_add_page.dart';

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
      appBar: AppBar(
        title: const Text("Gestión de Banners"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final url = await provider.uploadTempImage(image.path);
                if (url != null && mounted) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BannerAddPage(imageUrl: url, existingBanners: provider.banners)));
                }
              }
            },
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              itemCount: provider.banners.length,
              onReorder: provider.reorderBanners,
              itemBuilder: (context, index) {
                final banner = provider.banners[index];
                return ListTile(
                  key: ValueKey("${banner.imageUrl}_$index"),
                  leading: Image.network(banner.imageUrl, width: 50, fit: BoxFit.cover),
                  title: Text(banner.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removeBanner(banner),
                  ),
                );
              },
            ),
    );
  }
}
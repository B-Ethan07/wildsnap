import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wildsnap/screens/main_screen.dart';
import 'package:wildsnap/services/post_service.dart';
import 'package:wildsnap/widgets/custom_appbar.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String? _imageUrl;
  bool _isLoading = false;

  final _animalNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _postService = PostService();

  @override
  void dispose() {
    _animalNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  Future<bool> isValidImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      final contentType = response.headers['content-type'];

      return response.statusCode == 200 &&
          contentType != null &&
          contentType.startsWith('image/');
    } catch (_) {
      return false;
    }
  }

  Widget _buildImagePreview() {
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey[600],
          size: 60,
        ),
      );
    }

    return Image.network(
      _imageUrl!,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text("Image non valide"));
      },
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }

  Future<void> _submitPost() async {
    final imageUrl = _imageUrl?.trim();

    if (_animalNameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez remplir tous les champs et fournir une URL d\'image valide.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // ✅ Valider que l'image est accessible
    final isImageValid = await isValidImageUrl(imageUrl);

    if (!isImageValid) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'image fournie n\'est pas valide ou inaccessible.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Publier le post avec le service
      await _postService.createPost(
        animalName: _animalNameController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
        userId: FirebaseAuth.instance.currentUser?.uid,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post publié avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      _animalNameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();

      setState(() {
        _imageUrl = null;
      });

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      _navigateToHome();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la publication: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildImagePreview(),
                ),
                const SizedBox(height: 24),

                // Boutons pour caméra et galerie

                TextField(
                      controller: _imageUrlController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: "Lien de l'image",
                        border: OutlineInputBorder(),
                        hintText: "https://example.com/image.jpg",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _imageUrl = value.trim();
                        });
                      },
                    ),
                const SizedBox(height: 16),

                // Formulaire
                TextField(
                  controller: _animalNameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: "Nom de l'animal",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _locationController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Localisation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Bouton Post
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text('Poster'),
                ),
              ],
            ),
          ),

          // Overlay de chargement (par-dessus tout)
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

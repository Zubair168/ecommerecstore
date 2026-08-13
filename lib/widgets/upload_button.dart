import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerecstore/services/upload_service.dart';

typedef UploadCallback = void Function(String url);

class UploadButton extends StatefulWidget {
  final UploadCallback? onUploaded;
  final String preset;

  const UploadButton({super.key, this.onUploaded, this.preset = 'notes_app'});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool _loading = false;
  String? _uploadedUrl;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    setState(() => _loading = true);
    try {
      final res = await UploadService.uploadFile(
        File(xfile.path),
        preset: widget.preset,
      );
      final url = res['secure_url'] as String?;
      setState(() {
        _uploadedUrl = url;
      });
      if (url != null && widget.onUploaded != null) widget.onUploaded!(url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _loading ? null : _pickAndUpload,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          label: Text(
            _loading
                ? 'Uploading...'
                : (_uploadedUrl == null ? 'Upload Image' : 'Upload Again'),
          ),
        ),
        if (_uploadedUrl != null) ...[
          const SizedBox(height: 8),
          Image.network(
            _uploadedUrl!,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
          const SizedBox(height: 6),
          Text(
            _uploadedUrl!,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

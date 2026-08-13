import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/services/auth_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerecstore/services/upload_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Max tiger');
  final _emailCtrl = TextEditingController(text: 'maxtiger234@gmail.com');
  final _phoneCtrl = TextEditingController(text: '+122 123 132 1234');
  final _bdayCtrl = TextEditingController(text: '1999/12/08');
  String _gender = 'Male';
  String? _photoUrl;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bdayCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    setState(() => _loading = true);
    try {
      final res = await UploadService.uploadFile(File(xfile.path));
      final url = res['secure_url'] as String?;
      if (url != null) setState(() => _photoUrl = url);
      if (url != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image uploaded')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _loading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data();
      if (data != null) {
        _nameCtrl.text = (data['displayName'] as String?) ?? _nameCtrl.text;
        _emailCtrl.text = (data['email'] as String?) ?? _emailCtrl.text;
        _phoneCtrl.text = (data['phone'] as String?) ?? _phoneCtrl.text;
        _bdayCtrl.text = (data['birthday'] as String?) ?? _bdayCtrl.text;
        _gender = (data['gender'] as String?) ?? _gender;
        _photoUrl = (data['photoUrl'] as String?) ?? _photoUrl;
        setState(() {});
      }
    } catch (_) {
      // ignore load errors — keep defaults
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF344054),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with edit/upload
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFF2F4F7),
                        backgroundImage:
                            _photoUrl != null && _photoUrl!.isNotEmpty
                            ? NetworkImage(_photoUrl!) as ImageProvider
                            : const AssetImage(AppAssets.avatarUserDefault),
                        child: _photoUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickAndUpload,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Full name
            const Text(
              'Full name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 6),
            _inputField(controller: _nameCtrl, hint: 'Full name'),
            const SizedBox(height: 16),

            // Email
            const Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 6),
            _inputField(controller: _emailCtrl, hint: 'Email'),
            const SizedBox(height: 16),

            // Phone no.
            const Text(
              'Phone no.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 6),
            _inputField(
              controller: _phoneCtrl,
              hint: 'Phone number',
              suffix: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('🇺🇸', style: TextStyle(fontSize: 18)),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF667085),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            const Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _gender,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Birthday
            const Text(
              'Birthday',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 6),
            _inputField(
              controller: _bdayCtrl,
              hint: 'YYYY/MM/DD',
              suffix: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF667085),
                size: 18,
              ),
            ),
            const SizedBox(height: 36),

            // Save changes button (Dark Navy)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        try {
                          final updates = <String, dynamic>{
                            'displayName': _nameCtrl.text.trim(),
                            'email': _emailCtrl.text.trim(),
                            'phone': _phoneCtrl.text.trim(),
                            'gender': _gender,
                            'birthday': _bdayCtrl.text.trim(),
                            'photoUrl': _photoUrl ?? '',
                          };
                          await AuthService.updateProfile(updates);
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await user.updateDisplayName(_nameCtrl.text.trim());
                            if (_photoUrl != null && _photoUrl!.isNotEmpty) {
                              try {
                                await user.updatePhotoURL(_photoUrl);
                              } catch (_) {}
                            }
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully.'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Update failed: $e')),
                            );
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEAECF0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEAECF0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1D2939), width: 1.5),
        ),
      ),
    );
  }
}

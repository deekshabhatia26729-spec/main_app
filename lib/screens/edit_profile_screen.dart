import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController(
    text: 'Divya Sethi',
  );
  final TextEditingController _mobileController = TextEditingController(
    text: '6537728882',
  );
  final TextEditingController _emailController = TextEditingController(
    text: '01@gmail.com',
  );

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  // Editing state
  String? _editingField;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Colors
  final Color primaryPurple = const Color(0xFF6229E8);
  final Color lightPurple = const Color(0xFF8B5CF6);
  final Color iconPurple = const Color(0xFF7C3AED);
  final Color textDark = const Color(0xFF1F2937);
  final Color textGrey = const Color(0xFF6B7280);
  final Color cardGrey = const Color(0xFFF5F7FB);
  final Color blueOutline = const Color(0xFF3B82F6);

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _startEditing(String field, FocusNode focusNode) {
    setState(() {
      _editingField = field;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      focusNode.requestFocus();
    });
  }

  void _stopEditing() {
    setState(() {
      _editingField = null;
    });
    _nameFocus.unfocus();
    _mobileFocus.unfocus();
    _emailFocus.unfocus();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateProfile() {
    // Update profile logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopEditing,
      child: Scaffold(
        backgroundColor: cardGrey,
        body: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top Image Section with Rounded Bottom Corners
                  Stack(
                    children: [
                      // Profile Image
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.network(
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&q=80',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 100,
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),

                      // Overlay Buttons
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button - Blue Outlined Circle
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: blueOutline,
                                    width: 2.5,
                                  ),
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: blueOutline,
                                  size: 24,
                                ),
                              ),
                            ),

                            // Edit Button - Purple Filled Circle
                            GestureDetector(
                              onTap: _pickImageFromGallery,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [primaryPurple, lightPurple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryPurple.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Profile Details Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Name Field
                            _buildEditableField(
                              icon: Icons.person_outline,
                              label: 'Name',
                              controller: _nameController,
                              focusNode: _nameFocus,
                              fieldKey: 'name',
                              keyboardType: TextInputType.name,
                            ),

                            _buildDivider(),

                            // Mobile Field
                            _buildEditableField(
                              icon: Icons.phone_outlined,
                              label: 'Mobile',
                              controller: _mobileController,
                              focusNode: _mobileFocus,
                              fieldKey: 'mobile',
                              keyboardType: TextInputType.phone,
                            ),

                            _buildDivider(),

                            // Email Field
                            _buildEditableField(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              controller: _emailController,
                              focusNode: _emailFocus,
                              fieldKey: 'email',
                              keyboardType: TextInputType.emailAddress,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Update Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryPurple, lightPurple],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _updateProfile,
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            child: Text(
                              'Update profile',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String fieldKey,
    required TextInputType keyboardType,
    bool isLast = false,
  }) {
    final bool isEditing = _editingField == fieldKey;

    return GestureDetector(
      onTap: () {
        if (!isEditing) {
          _startEditing(fieldKey, focusNode);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 4, bottom: isLast ? 4 : 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconPurple, size: 22),
            ),

            const SizedBox(width: 16),

            // Label and Value/TextField
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  isEditing
                      ? TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: keyboardType,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: textDark,
                            letterSpacing: 0,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 0,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryPurple.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          cursorColor: primaryPurple,
                          onEditingComplete: _stopEditing,
                        )
                      : Text(
                          controller.text,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: textGrey,
                            letterSpacing: 0,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, thickness: 1, color: Colors.grey[200]),
    );
  }
}

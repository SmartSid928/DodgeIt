import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> categories = [
    'Pothole',
    'Damaged Road',
    'Waterlogging',
    'Road Blockage',
    'Accident-prone Area',
    'Other',
  ];

  String selectedCategory = 'Pothole';
  String selectedSeverity = 'Medium';

  XFile? selectedImage;
  Position? currentPosition;

  bool isGettingLocation = false;
  bool isSubmitting = false;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1600,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = image;
        });
      }
    } catch (e) {
      showMessage('Unable to select image: $e');
    }
  }

  Future<void> getLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        showMessage('Please enable location services.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showMessage('Location permission was not granted.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
      });

      showMessage('Location captured successfully!');
    } catch (e) {
      showMessage('Unable to get location: $e');
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> submitReport() async {
    if (selectedImage == null) {
      showMessage('Please add a road photo.');
      return;
    }

    if (currentPosition == null) {
      showMessage('Please capture your location.');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      showMessage('Please describe the road issue.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Backend submission will be implemented later.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    showMessage('Report validated! Backend submission is coming next.');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16A36A);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report Road Issue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help improve our roads',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Report road problems in your area.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            const Text(
              'Road Photo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: selectedImage == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 42,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text('Add a photo of the road issue'),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(selectedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            const Text(
              'Issue Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 22),

            const Text(
              'Severity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: ['Low', 'Medium', 'High'].map((severity) {
                return ChoiceChip(
                  label: Text(severity),
                  selected: selectedSeverity == severity,
                  selectedColor: green.withValues(alpha: 0.2),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedSeverity = severity;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            const Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: isGettingLocation ? null : getLocation,
              icon: isGettingLocation
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                isGettingLocation
                    ? 'Getting location...'
                    : currentPosition == null
                    ? 'Capture Current Location'
                    : 'Location Captured',
              ),
            ),

            if (currentPosition != null) ...[
              const SizedBox(height: 8),
              Text(
                'Latitude: ${currentPosition!.latitude.toStringAsFixed(6)}\n'
                'Longitude: ${currentPosition!.longitude.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],

            const SizedBox(height: 22),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 300,
              decoration: const InputDecoration(
                hintText: 'Describe the road problem...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : submitReport,
                icon: const Icon(Icons.send),
                label: Text(isSubmitting ? 'Validating...' : 'Submit Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterParkingPage extends StatefulWidget {
  const RegisterParkingPage({super.key});

  @override
  State<RegisterParkingPage> createState() => _RegisterParkingPageState();
}

class _RegisterParkingPageState extends State<RegisterParkingPage> {
  double _dailyPrice = 25.0;
  double _monthlyPrice = 300.0;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _spotsController = TextEditingController();
  bool _termsAccepted = false;

  // Location state
  // Eliminar lat/lng, error y loading
  bool _isStepValid() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty &&
               _descriptionController.text.isNotEmpty &&
               _spotsController.text.isNotEmpty &&
               _selectedImages[0] != null;
      case 1:
        return _addressController.text.isNotEmpty;
      case 2:
        return true;
      case 3:
        return _priceController.text.isNotEmpty &&
               double.tryParse(_priceController.text) != null &&
               _termsAccepted == true;
      default:
        return false;
    }
  }

  String _selectedParkingType = 'Público';
  List<String> _parkingTypes = ['Público', 'Privado', 'Residencial', 'Comercial'];

  List<String> _amenities = [
    'Vigilancia 24/7',
    'Cámaras de seguridad',
    'Techo cubierto',
    'Iluminación',
    'Baños',
    'Lavado de autos',
    'Carga eléctrica',
    'Acceso para discapacitados'
  ];

  List<String> _selectedAmenities = [];

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _selectedImages = [null, null, null];

  // Horario y días de atención
  TimeOfDay _openingTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 22, minute: 0);
  List<int> _selectedDays = [0, 1, 2, 3, 4]; // Lunes a Viernes

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _spotsController.dispose();
    super.dispose();
  }

  void _editPriceDialog(String title, {required bool isDaily}) {
    final controller = TextEditingController(
        text: isDaily ? _dailyPrice.toStringAsFixed(2) : _monthlyPrice.toStringAsFixed(2));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.surface
            : colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: colorScheme.primary, size: 44),
            const SizedBox(height: 20),
            Text(
              'Editar $title',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 26),
            TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Nuevo precio',
                prefixText: 'S/ ',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                prefixStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancelar',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final value = double.tryParse(controller.text);
                      if (value != null) {
                        setState(() {
                          if (isDaily) _dailyPrice = value;
                          else _monthlyPrice = value;
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: Text(
                      'Guardar',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editSummaryFieldDialog(String title, TextEditingController controller, {bool isNumber = false}) {
    final localController = TextEditingController(text: controller.text);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.surface
            : colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: colorScheme.primary, size: 44),
            const SizedBox(height: 20),
            Text(
              'Editar $title',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 26),
            TextField(
              controller: localController,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nuevo $title',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancelar',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.text = localController.text;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: Text(
                      'Guardar',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.background
            : Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Registro de Estacionamiento',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? colorScheme.onSurface.withOpacity(0.08)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: colorScheme.onSurface,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Paso ${_currentStep + 1} de 4',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / 4 * 100).toInt()}%',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 4,
                      backgroundColor: colorScheme.primary.withOpacity(0.08),
                      color: colorScheme.primary,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildCurrentStep(),
              ),
            ),

            // Bottom navigation
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Anterior',
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isStepValid() && !_isLoading ? _nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 4,
                        shadowColor: colorScheme.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        _currentStep == 3 ? 'Registrar' : 'Siguiente',
                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                      ),
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildLocationStep();
      case 2:
        return _buildFeaturesStep();
      case 3:
        return _buildPricingStep();
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Información Básica',
          'Ingresa los datos principales de tu estacionamiento',
          Icons.local_parking_rounded,
        ),
        const SizedBox(height: 24),

        _buildInputField(
          controller: _nameController,
          label: 'Nombre del estacionamiento',
          hint: 'Ej: Parking San Isidro',
          icon: Icons.business,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un nombre';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        _buildInputField(
          controller: _descriptionController,
          label: 'Descripción',
          hint: 'Describe brevemente tu estacionamiento',
          icon: Icons.description,
          maxLines: 3,
        ),

        const SizedBox(height: 20),

        _buildDropdownField(
          label: 'Tipo de estacionamiento',
          value: _selectedParkingType,
          items: _parkingTypes,
          icon: Icons.category,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedParkingType = value;
              });
            }
          },
        ),

        const SizedBox(height: 20),

        _buildInputField(
          controller: _spotsController,
          label: 'Número de espacios',
          hint: 'Ej: 20',
          icon: Icons.space_bar,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el número de espacios';
            }
            if (int.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Fotos del estacionamiento'),

        const SizedBox(height: 16),

        _buildImageUploadSection(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Ubicación',
          'Indica dónde se encuentra tu estacionamiento',
          Icons.location_on,
        ),
        const SizedBox(height: 24),
        // Input de dirección con botón de buscar
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _addressController,
                label: 'Dirección o lugar',
                hint: 'Ej: Av. Javier Prado 1234, San Isidro o Starbucks',
                icon: Icons.home,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la dirección o lugar';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 56,
              child: Builder(
                builder: (context) {
                  final colorScheme = Theme.of(context).colorScheme;
                  return ElevatedButton(
                    onPressed: () {
                      _showGoogleMapsDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Icon(Icons.map, size: 26, color: colorScheme.onPrimary),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Si la dirección está llena, muestra el resumen del lugar
        if (_addressController.text.isNotEmpty)
          Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;
              return Container(
                margin: const EdgeInsets.only(top: 4, bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.place, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _addressController.text,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        _buildSectionTitle('Información adicional'),
        const SizedBox(height: 16),
        _buildInputField(
          label: 'Referencias',
          hint: 'Ej: Frente al parque, esquina con Av. Principal',
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildGoogleMapsLocationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          'Seleccionar ubicación en el mapa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () {
          _showGoogleMapsDialog();
        },
      ),
    );
  }

  void _showGoogleMapsDialog() {
    final searchController = TextEditingController(text: _addressController.text);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.surface
              : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.map,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Buscar en Google Maps',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Ingresa una dirección o lugar',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? colorScheme.onSurface.withOpacity(0.08)
                      : colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                autofocus: true,
                onSubmitted: (value) {
                  _openGoogleMapsAndSetAddress(searchController.text);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _openGoogleMapsAndSetAddress(searchController.text);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Buscar en Google Maps',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGoogleMapsAndSetAddress(String address) async {
    if (address.trim().isEmpty) return;
    final encoded = Uri.encodeComponent(address);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encoded';
    // Actualiza el campo de dirección con lo buscado
    setState(() {
      _addressController.text = address;
    });
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildFeaturesStep() {
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Características',
          'Selecciona las características de tu estacionamiento',
          Icons.star,
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Servicios disponibles'),
        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _amenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? colorScheme.onSurface.withOpacity(0.08)
                  : colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              labelStyle: textTheme.bodyMedium?.copyWith(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Horario de atención'),
        const SizedBox(height: 16),

        // Card editable para horario de apertura
        _buildTimeSelectionCard(
          title: 'Horario de apertura',
          icon: Icons.access_time,
          time: _openingTime.format(context),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: _openingTime,
            );
            if (picked != null) {
              setState(() {
                _openingTime = picked;
              });
            }
          },
        ),

        const SizedBox(height: 12),

        // Card editable para horario de cierre
        _buildTimeSelectionCard(
          title: 'Horario de cierre',
          icon: Icons.access_time,
          time: _closingTime.format(context),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: _closingTime,
            );
            if (picked != null) {
              setState(() {
                _closingTime = picked;
              });
            }
          },
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Días de atención'),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final isSelected = _selectedDays.contains(index);
            final colorScheme = Theme.of(context).colorScheme;
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(index);
                  } else {
                    _selectedDays.add(index);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPricingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Precios y Términos',
          'Establece las tarifas y condiciones',
          Icons.attach_money,
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Tarifas'),

        const SizedBox(height: 16),

        _buildInputField(
          controller: _priceController,
          label: 'Precio por hora (S/)',
          hint: 'Ej: 5.00',
          icon: Icons.monetization_on,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el precio';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un precio válido';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),
        _buildPricingCard(
          title: 'Tarifa por día',
          price: 'S/ ${_dailyPrice.toStringAsFixed(2)}',
          description: 'Estacionamiento por día completo',
          icon: Icons.calendar_today,
          onEdit: () => _editPriceDialog('Tarifa por día', isDaily: true),
        ),

        const SizedBox(height: 12),

        _buildPricingCard(
          title: 'Tarifa mensual',
          price: 'S/ ${_monthlyPrice.toStringAsFixed(2)}',
          description: 'Abono mensual',
          icon: Icons.date_range,
          onEdit: () => _editPriceDialog('Tarifa mensual', isDaily: false),
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Métodos de pago aceptados'),

        const SizedBox(height: 16),

        _buildPaymentMethodsSelection(),

        const SizedBox(height: 24),

        _buildSectionTitle('Términos y condiciones'),

        const SizedBox(height: 16),

        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CheckboxListTile(
                value: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
                title: Text(
                  'Acepto los términos y condiciones',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Al registrar mi estacionamiento, acepto las políticas de ParkingNow',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: colorScheme.primary,
                checkColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tileColor: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Summary card
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorScheme.onSurface.withOpacity(0.08)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen del registro',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryItem('Nombre', _nameController.text.isEmpty ? 'Parking San Isidro' : _nameController.text, onEdit: () => _editSummaryFieldDialog('Nombre', _nameController)),
                  _buildSummaryItem('Dirección', _addressController.text.isEmpty ? 'Av. Javier Prado 1234' : _addressController.text, onEdit: () => _editSummaryFieldDialog('Dirección', _addressController)),
                  _buildSummaryItem('Espacios', _spotsController.text.isEmpty ? '20' : _spotsController.text, onEdit: () => _editSummaryFieldDialog('Espacios', _spotsController, isNumber: true)),
                  _buildSummaryItem('Precio por hora', _priceController.text.isEmpty ? 'S/ 5.00' : 'S/ ${_priceController.text}', onEdit: () => _editSummaryFieldDialog('Precio por hora', _priceController, isNumber: true)),
                  _buildSummaryItem('Tipo', _selectedParkingType, onEdit: () {/* Abre un diálogo para editar el tipo si deseas */}),
                  _buildSummaryItem('Servicios', '${_selectedAmenities.length} seleccionados', onEdit: null),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildInputField({
    TextEditingController? controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: colorScheme.primary),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.onSurface.withOpacity(0.08)
                : colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.onSurface.withOpacity(0.08)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.onSurface.withOpacity(0.08)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
                  child: _buildImageUploadBox(index: index, isMain: index == 0),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            'Sube al menos una foto de tu estacionamiento',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La primera imagen será la principal',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadBox({required int index, bool isMain = false}) {
    final file = _selectedImages[index];
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () async {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final permission = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primary.withOpacity(0.08),
                  child: Icon(Icons.photo_library_rounded, color: colorScheme.primary, size: 32),
                ),
                const SizedBox(height: 24),
                Text(
                  'Permitir acceso a tu galería',
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Quieres permitir que ParkingNow acceda a tu galería para subir una foto de tu estacionamiento?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(
                          'No permitir',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Permitir',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (permission == true) {
          final pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
          if (pickedFile != null) {
            setState(() {
              _selectedImages[index] = pickedFile;
            });
          }
        }
        // Si no permite, no hacer nada
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMain ? colorScheme.primary : colorScheme.outline,
              width: isMain ? 2 : 1,
            ),
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 24,
                      color: isMain ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isMain ? 'Principal' : 'Adicional',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: isMain ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTimeSelectionCard({
    required String title,
    required IconData icon,
    required String time,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.onSurface.withOpacity(0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelection() {
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final selectedDays = [0, 1, 2, 3, 4]; // Lunes a Viernes seleccionados

    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isSelected = selectedDays.contains(index);
        return InkWell(
          onTap: () {
            // Toggle day selection
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
            child: Center(
              child: Text(
                days[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String description,
    required IconData icon,
    required VoidCallback onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.onSurface.withOpacity(0.08)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 16,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSelection() {
    final paymentMethods = [
      {'name': 'Efectivo', 'icon': Icons.money},
      {'name': 'Tarjeta', 'icon': Icons.credit_card},
      {'name': 'Yape', 'icon': Icons.smartphone},
      {'name': 'Plin', 'icon': Icons.phone_android},
    ];

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: paymentMethods.map((method) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.onSurface.withOpacity(0.08)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                method['icon'] as IconData,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                method['name'] as String,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                size: 16,
                color: colorScheme.primary,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryItem(String label, String value, {VoidCallback? onEdit}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // No background needed for summary item unless specified. If needed, wrap in Container with the same color logic.
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit, size: 16, color: colorScheme.primary.withOpacity(0.7)),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Diálogo de éxito elegante y moderno
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.surface
                : colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 12,
            contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.15),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Icon(Icons.check_circle, color: Colors.green, size: 52),
                ),
                const SizedBox(height: 20),
                Text(
                  '¡Registro exitoso!',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tu estacionamiento ha sido registrado correctamente. Pronto comenzarás a recibir reservas.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cerrar',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Ir al Dashboard',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    }
  }
}
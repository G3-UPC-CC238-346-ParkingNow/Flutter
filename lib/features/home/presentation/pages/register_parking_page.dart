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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: AppColors.primary, size: 44),
            const SizedBox(height: 20),
            Text(
              'Editar $title',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1E293B),
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
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      style: TextStyle(
                        color: AppColors.primary,
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
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: AppColors.primary, size: 44),
            const SizedBox(height: 20),
            Text(
              'Editar $title',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 26),
            TextField(
              controller: localController,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nuevo $title',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      style: TextStyle(
                        color: AppColors.primary,
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
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Registro de Estacionamiento',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1E293B),
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
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
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / 4 * 100).toInt()}%',
                        style: TextStyle(
                          color: AppColors.primary,
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
                      backgroundColor: Colors.grey[200],
                      color: AppColors.primary,
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
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Anterior',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isStepValid() && !_isLoading ? _nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        _currentStep == 3 ? 'Registrar' : 'Siguiente',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
              child: ElevatedButton(
                onPressed: () {
                  _showGoogleMapsDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: const Icon(Icons.map, size: 26, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Si la dirección está llena, muestra el resumen del lugar
        if (_addressController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.place, color: Color(0xFF2563EB), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _addressController.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Buscar en Google Maps',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Buscar en Google Maps',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
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
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
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
                      color: isSelected ? Colors.white : Colors.grey[600],
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

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
            title: const Text(
              'Acepto los términos y condiciones',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Al registrar mi estacionamiento, acepto las políticas de ParkingNow',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),

        const SizedBox(height: 24),

        // Summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen del registro',
                style: TextStyle(
                  color: Colors.white,
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
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
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
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color(0xFF1E293B),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La primera imagen será la principal',
            style: TextStyle(
              color: Colors.grey[500],
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
    return GestureDetector(
      onTap: () async {
        // Mostrar diálogo de permiso elegante
        final permission = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.08),
                  child: Icon(Icons.photo_library_rounded, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 24),
                Text(
                  'Permitir acceso a tu galería',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Quieres permitir que ParkingNow acceda a tu galería para subir una foto de tu estacionamiento?',
                  style: TextStyle(
                    color: Colors.grey[700],
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
                          style: TextStyle(
                            color: AppColors.primary,
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
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Permitir',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMain ? AppColors.primary : Colors.grey[300]!,
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
                      color: isMain ? AppColors.primary : Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isMain ? 'Principal' : 'Adicional',
                      style: TextStyle(
                        fontSize: 12,
                        color: isMain ? AppColors.primary : Colors.grey[600],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelection() {
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final selectedDays = [0, 1, 2, 3, 4]; // Lunes a Viernes seleccionados

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
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
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
                  color: isSelected ? Colors.white : Colors.grey[600],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey[400],
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

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: paymentMethods.map((method) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                method['icon'] as IconData,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                method['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryItem(String label, String value, {VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 16, color: Colors.white70),
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 12,
            contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.13),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 52),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Registro exitoso!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tu estacionamiento ha sido registrado correctamente. Pronto comenzarás a recibir reservas.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
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
                          style: TextStyle(
                            color: AppColors.primary,
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
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Ir al Dashboard',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';
import 'package:parkingnow_owner/routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _rucController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();

  // State variables
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  int _currentStep = 0;
  bool _isLoading = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _rucController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    _capacityController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF0F172A), const Color(0xFF2563EB)]
                    : [const Color(0xFF2563EB), const Color(0xFF60A5FA)],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Progress indicator
                _buildProgressIndicator(),

                // Form content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildPersonalInfoStep(),
                            _buildSecurityStep(),
                            _buildBusinessInfoStep(),
                            _buildConfirmationStep(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Paso ${_currentStep + 1} de 3',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_parking,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ParkingNow Owner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Únete a nuestra red de propietarios',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'Información Personal',
            'Cuéntanos sobre ti',
            Icons.person_outline,
          ),
          const SizedBox(height: 32),

          _buildEnhancedTextField(
            controller: _nameController,
            label: 'Nombre completo',
            hint: 'Ingresa tu nombre y apellidos',
            icon: Icons.person,
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 20),

          _buildEnhancedTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            hint: 'ejemplo@correo.com',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) return 'Campo requerido';
              if (!value.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 20),

          _buildEnhancedTextField(
            controller: _phoneController,
            label: 'Número de teléfono',
            hint: '+51 999 999 999',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 40),

          _buildNavigationButtons(
            onNext: () => _nextStep(),
            showPrevious: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'Seguridad',
            'Protege tu cuenta',
            Icons.security,
          ),
          const SizedBox(height: 32),

          _buildEnhancedTextField(
            controller: _passwordController,
            label: 'Contraseña',
            hint: 'Mínimo 8 caracteres',
            icon: Icons.lock,
            obscureText: !_passwordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Campo requerido';
              if (value.length < 8) return 'Mínimo 8 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 20),

          _buildEnhancedTextField(
            controller: _confirmPasswordController,
            label: 'Confirmar contraseña',
            hint: 'Repite tu contraseña',
            icon: Icons.lock_outline,
            obscureText: !_confirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Campo requerido';
              if (value != _passwordController.text) return 'Las contraseñas no coinciden';
              return null;
            },
          ),

          const SizedBox(height: 20),
          _buildPasswordStrengthIndicator(),
          const SizedBox(height: 40),

          _buildNavigationButtons(
            onNext: () => _nextStep(),
            onPrevious: () => _previousStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeader(
              'Información del Negocio',
              'Detalles de tu estacionamiento',
              Icons.business,
            ),
            const SizedBox(height: 32),

            _buildEnhancedTextField(
              controller: _rucController,
              label: 'RUC',
              hint: '20123456789',
              icon: Icons.business_center,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Campo requerido';
                if (value.length != 11) return 'RUC debe tener 11 dígitos';
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildEnhancedTextField(
              controller: _businessNameController,
              label: 'Nombre del negocio',
              hint: 'Estacionamiento Central',
              icon: Icons.store,
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 20),

            _buildEnhancedTextField(
              controller: _addressController,
              label: 'Dirección del estacionamiento',
              hint: 'Av. Principal 123, Lima',
              icon: Icons.location_on,
              maxLines: 2,
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 20),

            _buildEnhancedTextField(
              controller: _capacityController,
              label: 'Capacidad total',
              hint: 'Número de espacios disponibles',
              icon: Icons.local_parking,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Campo requerido';
                if (int.tryParse(value) == null) return 'Debe ser un número';
                return null;
              },
            ),
            const SizedBox(height: 40),

            _buildNavigationButtons(
              onNext: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => _isLoading = false);
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboardOwner);
                }
              },
              onPrevious: () => _previousStep(),
              nextText: 'Finalizar registro',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'Confirmación',
            'Revisa y acepta los términos',
            Icons.check_circle_outline,
          ),
          const SizedBox(height: 32),

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.10)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen de tu registro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryItem('Nombre', _nameController.text),
                _buildSummaryItem('Email', _emailController.text),
                _buildSummaryItem('Teléfono', _phoneController.text),
                _buildSummaryItem('Negocio', _businessNameController.text),
                _buildSummaryItem('RUC', _rucController.text),
                _buildSummaryItem('Dirección', _addressController.text),
                _buildSummaryItem('Capacidad', '${_capacityController.text} espacios'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Terms and conditions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.10)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: _acceptTerms,
                  onChanged: (value) => setState(() => _acceptTerms = value!),
                  title: Text(
                    'Acepto los términos y condiciones',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: TextButton(
                    onPressed: () => _showTermsDialog(),
                    child: Text(
                      'Leer términos y condiciones',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue[200]
                            : const Color(0xFF667EEA),
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[700]
                      : const Color(0xFF667EEA),
                  checkColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white,
                ),
                CheckboxListTile(
                  value: _acceptPrivacy,
                  onChanged: (value) => setState(() => _acceptPrivacy = value!),
                  title: Text(
                    'Acepto la política de privacidad',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: TextButton(
                    onPressed: () => _showPrivacyDialog(),
                    child: Text(
                      'Leer política de privacidad',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue[200]
                            : const Color(0xFF667EEA),
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[700]
                      : const Color(0xFF667EEA),
                  checkColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          _buildNavigationButtons(
            onNext: () => _register(),
            onPrevious: () => _previousStep(),
            nextText: 'Crear Cuenta',
            isNextEnabled: _acceptTerms && _acceptPrivacy,
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blue[700]?.withOpacity(0.15)
                : const Color(0xFF667EEA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blue[200]
                : const Color(0xFF667EEA),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF667EEA),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blue[200]!
                    : const Color(0xFF667EEA),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    Color strengthColor = Colors.red;
    String strengthText = 'Débil';

    if (strength >= 3) {
      strengthColor = Colors.green;
      strengthText = 'Fuerte';
    } else if (strength >= 2) {
      strengthColor = Colors.orange;
      strengthText = 'Media';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fortaleza de la contraseña: $strengthText',
          style: TextStyle(
            color: strengthColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strength / 4,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons({
    required VoidCallback onNext,
    VoidCallback? onPrevious,
    bool showPrevious = true,
    String nextText = 'Siguiente',
    bool isNextEnabled = true,
  }) {
    return Row(
      children: [
        if (showPrevious && onPrevious != null)
          Expanded(
            child: OutlinedButton(
              onPressed: onPrevious,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[200]!
                      : const Color(0xFF667EEA),
                ),
              ),
              child: Text(
                'Anterior',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[200]
                      : const Color(0xFF667EEA),
                ),
              ),
            ),
          ),
        if (showPrevious && onPrevious != null) const SizedBox(width: 16),
        Expanded(
          flex: showPrevious ? 1 : 2,
          child: ElevatedButton(
            onPressed: isNextEnabled ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue[700]
                  : const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              nextText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    setState(() => _currentStep--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty;
      case 1:
        return _passwordController.text.length >= 8 &&
            _passwordController.text == _confirmPasswordController.text;
      case 2:
        return _rucController.text.length == 11 &&
            _businessNameController.text.isNotEmpty &&
            _addressController.text.isNotEmpty &&
            _capacityController.text.isNotEmpty;
      default:
        return true;
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate() && _acceptTerms && _acceptPrivacy) {
      setState(() => _isLoading = true);

      // Simulate registration process
      await Future.delayed(const Duration(seconds: 3));

      setState(() => _isLoading = false);

      // Show success dialog
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Registro Exitoso!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu cuenta ha sido creada exitosamente. Te hemos enviado un correo de verificación.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRoutes.dashboardOwner);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí van los términos y condiciones completos de la aplicación...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí va la política de privacidad completa de la aplicación...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
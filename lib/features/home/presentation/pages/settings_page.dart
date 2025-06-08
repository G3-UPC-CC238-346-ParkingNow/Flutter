
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoBackup = true;
  bool _biometricAuth = false;
  String _selectedLanguage = 'Español';
  String _selectedCurrency = 'PEN (S/)';

  final List<String> _languages = ['Español', 'English', 'Português', 'Français'];
  final List<String> _currencies = ['PEN (S/)', 'USD (\$)', 'EUR (€)', 'COP (\$)'];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Color(0xFF3B82F6),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF1D4ED8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Eliminado el icono de engranaje (ajustes)
                            const Text(
                              'Configuraciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Personaliza tu experiencia',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              // Eliminado el botón de ayuda (ícono de ayuda)
              const SizedBox(width: 16),
            ],
          ),

          // Profile Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _editProfilePicture(),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Juan Carlos Pérez',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Propietario Premium',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Cuenta Verificada',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _navigateToEditProfile(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Color(0xFF3B82F6),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Settings Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // General Settings
                  _buildSettingsSection(
                    'General',
                    Icons.tune,
                    [
                      _buildSwitchTile(
                        'Modo Oscuro',
                        'Cambia la apariencia de la aplicación',
                        Icons.dark_mode,
                        _isDarkMode,
                            (value) => setState(() => _isDarkMode = value),
                      ),
                      _buildNavigationTile(
                        'Idioma',
                        _selectedLanguage,
                        Icons.language,
                            () => _showLanguageDialog(),
                      ),
                      _buildNavigationTile(
                        'Moneda',
                        _selectedCurrency,
                        Icons.attach_money,
                            () => _showCurrencyDialog(),
                      ),
                      _buildNavigationTile(
                        'Zona Horaria',
                        'GMT-5 (Lima)',
                        Icons.schedule,
                            () => _navigateToTimezoneSettings(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Notifications Settings
                  _buildSettingsSection(
                    'Notificaciones',
                    Icons.notifications,
                    [
                      _buildSwitchTile(
                        'Notificaciones Push',
                        'Recibe alertas importantes',
                        Icons.notifications_active,
                        _notificationsEnabled,
                            (value) => setState(() => _notificationsEnabled = value),
                      ),
                      _buildSwitchTile(
                        'Sonidos',
                        'Reproduce sonidos de notificación',
                        Icons.volume_up,
                        _soundEnabled,
                            (value) => setState(() => _soundEnabled = value),
                      ),
                      _buildSwitchTile(
                        'Vibración',
                        'Vibra al recibir notificaciones',
                        Icons.vibration,
                        _vibrationEnabled,
                            (value) => setState(() => _vibrationEnabled = value),
                      ),
                      _buildNavigationTile(
                        'Configurar Alertas',
                        'Personaliza tus alertas',
                        Icons.tune,
                            () => _navigateToAlertSettings(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Security Settings
                  _buildSettingsSection(
                    'Seguridad',
                    Icons.security,
                    [
                      _buildSwitchTile(
                        'Autenticación Biométrica',
                        'Usa huella dactilar o Face ID',
                        Icons.fingerprint,
                        _biometricAuth,
                            (value) => setState(() => _biometricAuth = value),
                      ),
                      _buildNavigationTile(
                        'Verificación en Dos Pasos',
                        'Configurar 2FA',
                        Icons.verified_user,
                            () => _navigateTo2FASetup(),
                      ),
                      _buildNavigationTile(
                        'Sesiones Activas',
                        'Gestiona tus dispositivos',
                        Icons.devices,
                            () => _navigateToActiveSessions(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Data & Privacy
                  _buildSettingsSection(
                    'Datos y Privacidad',
                    Icons.privacy_tip,
                    [
                      _buildSwitchTile(
                        'Copia de Seguridad Automática',
                        'Respalda tus datos automáticamente',
                        Icons.backup,
                        _autoBackup,
                            (value) => setState(() => _autoBackup = value),
                      ),
                      _buildNavigationTile(
                        'Exportar Datos',
                        'Descarga una copia de tus datos',
                        Icons.download,
                            () => _navigateToDataExport(),
                      ),
                      _buildNavigationTile(
                        'Política de Privacidad',
                        'Lee nuestras políticas',
                        Icons.policy,
                            () => _navigateToPrivacyPolicy(),
                      ),
                      _buildNavigationTile(
                        'Términos de Servicio',
                        'Consulta los términos',
                        Icons.description,
                            () => _navigateToTermsOfService(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Support Settings
                  _buildSettingsSection(
                    'Soporte',
                    Icons.support_agent,
                    [
                      _buildNavigationTile(
                        'Centro de Ayuda',
                        'Encuentra respuestas rápidas',
                        Icons.help_center,
                            () => _navigateToHelpCenter(),
                      ),
                      _buildNavigationTile(
                        'Contactar Soporte',
                        'Habla con nuestro equipo',
                        Icons.chat,
                            () => _navigateToContactSupport(),
                      ),
                      _buildNavigationTile(
                        'Reportar Problema',
                        'Informa sobre errores',
                        Icons.bug_report,
                            () => _navigateToReportBug(),
                      ),
                      _buildNavigationTile(
                        'Quejas y Reclamos',
                        'Presenta tu queja formal',
                        Icons.report_problem,
                            () => _navigateToFileComplaint(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Emergency Settings
                  _buildSettingsSection(
                    'Emergencia',
                    Icons.emergency,
                    [
                      _buildNavigationTile(
                        'Reportar Robo',
                        'Reporta un incidente de seguridad',
                        Icons.local_police,
                            () => _navigateToReportTheft(),
                        isEmergency: true,
                      ),
                      _buildNavigationTile(
                        'Contactos de Emergencia',
                        'Configura contactos importantes',
                        Icons.emergency_share,
                            () => _navigateToEmergencyContacts(),
                        isEmergency: true,
                      ),
                      _buildNavigationTile(
                        'Protocolo de Emergencia',
                        'Revisa los procedimientos',
                        Icons.medical_services,
                            () => _navigateToEmergencyProtocol(),
                        isEmergency: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Account Management
                  _buildSettingsSection(
                    'Cuenta',
                    Icons.account_circle,
                    [
                      _buildNavigationTile(
                        'Información de la Cuenta',
                        'Gestiona tu información personal',
                        Icons.person_outline,
                            () => _navigateToAccountInfo(),
                      ),
                      _buildNavigationTile(
                        'Plan de Suscripción',
                        'Premium - Renovación: 15/02/2025',
                        Icons.card_membership,
                            () => _navigateToSubscriptionInfo(),
                      ),
                      _buildNavigationTile(
                        'Métodos de Pago',
                        'Gestiona tus tarjetas y pagos',
                        Icons.payment,
                            () => _navigateToPaymentMethods(),
                      ),
                      _buildNavigationTile(
                        'Cerrar Sesión',
                        'Salir de la aplicación',
                        Icons.logout,
                            () => _showLogoutDialog(),
                        isDestructive: true,
                      ),
                      _buildNavigationTile(
                        'Eliminar Cuenta',
                        'Eliminar permanentemente tu cuenta',
                        Icons.delete_forever,
                            () => _showDeleteAccountDialog(),
                        isDestructive: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // App Info
                  Container(
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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF3B82F6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Información de la App',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Versión',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              '1.0.0',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Última actualización',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              '05 Enero 2025',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _checkForUpdates(),
                                icon: const Icon(Icons.system_update, size: 16),
                                label: const Text('Buscar actualizaciones'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF3B82F6),
                                  side: const BorderSide(color: Color(0xFF3B82F6)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _rateApp(),
                                icon: const Icon(Icons.star, size: 16),
                                label: const Text('Calificar App'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF3B82F6),
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ...children.map((child) => Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: child,
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[700],
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF3B82F6),
            activeTrackColor: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false, bool isEmergency = false}) {
    Color iconColor = Colors.grey[700]!;
    Color titleColor = Colors.black;

    if (isDestructive) {
      iconColor = Colors.red;
      titleColor = Colors.red;
    } else if (isEmergency) {
      iconColor = Colors.orange;
      titleColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Methods
  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
  }

  void _navigateToTimezoneSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TimezoneSettingsPage(),
      ),
    );
  }

  void _navigateToAlertSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlertSettingsPage(),
      ),
    );
  }


  void _navigateTo2FASetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TwoFactorAuthPage(),
      ),
    );
  }

  void _navigateToActiveSessions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActiveSessionsPage(),
      ),
    );
  }

  void _navigateToDataExport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DataExportPage(),
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyPage(),
      ),
    );
  }

  void _navigateToTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsOfServicePage(),
      ),
    );
  }

  void _navigateToHelpCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpCenterPage(),
      ),
    );
  }

  void _navigateToContactSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactSupportPage(),
      ),
    );
  }

  void _navigateToReportBug() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportBugPage(),
      ),
    );
  }

  void _navigateToFileComplaint() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FileComplaintPage(),
      ),
    );
  }

  void _navigateToReportTheft() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportTheftPage(),
      ),
    );
  }

  void _navigateToEmergencyContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmergencyContactsPage(),
      ),
    );
  }

  void _navigateToEmergencyProtocol() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmergencyProtocolPage(),
      ),
    );
  }

  void _navigateToAccountInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountInfoPage(),
      ),
    );
  }

  void _navigateToSubscriptionInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionInfoPage(),
      ),
    );
  }

  void _navigateToPaymentMethods() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodsPage(),
      ),
    );
  }

  // Dialog Methods
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF3B82F6),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Seleccionar Moneda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF3B82F6),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar Cuenta'),
        content: const Text(
          'Esta acción es irreversible. Se eliminarán todos tus datos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo centro de ayuda...'),
        backgroundColor: Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil actualizada'),
          backgroundColor: Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buscando actualizaciones...'),
        backgroundColor: Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo tienda de aplicaciones...'),
        backgroundColor: Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Páginas adicionales
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Juan Carlos Pérez');
  final _emailController = TextEditingController(text: 'juan.perez@email.com');
  final _phoneController = TextEditingController(text: '+51 987 654 321');
  final _addressController = TextEditingController(text: 'Av. Javier Prado 123, San Isidro');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Fields
            _buildFormField('Nombre completo', _nameController, Icons.person),
            const SizedBox(height: 16),
            _buildFormField('Correo electrónico', _emailController, Icons.email),
            const SizedBox(height: 16),
            _buildFormField('Teléfono', _phoneController, Icons.phone),
            const SizedBox(height: 16),
            _buildFormField('Dirección', _addressController, Icons.location_on),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil actualizado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}


// Páginas adicionales simplificadas
class TimezoneSettingsPage extends StatelessWidget {
  const TimezoneSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zona Horaria'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Configuración de Zona Horaria'),
      ),
    );
  }
}

class AlertSettingsPage extends StatelessWidget {
  const AlertSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Alertas'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Configuración de Alertas'),
      ),
    );
  }
}

class TwoFactorAuthPage extends StatelessWidget {
  const TwoFactorAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación 2FA'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Configuración de Autenticación de Dos Factores'),
      ),
    );
  }
}

class ActiveSessionsPage extends StatelessWidget {
  const ActiveSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesiones Activas'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Gestión de Sesiones Activas'),
      ),
    );
  }
}

class DataExportPage extends StatelessWidget {
  const DataExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar Datos'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Exportación de Datos'),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Política de Privacidad'),
      ),
    );
  }
}

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos de Servicio'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Términos de Servicio'),
      ),
    );
  }
}

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Ayuda'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Centro de Ayuda'),
      ),
    );
  }
}

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactar Soporte'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Contactar Soporte'),
      ),
    );
  }
}

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Problema'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Reportar Problema'),
      ),
    );
  }
}

class FileComplaintPage extends StatelessWidget {
  const FileComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quejas y Reclamos'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Quejas y Reclamos'),
      ),
    );
  }
}

class ReportTheftPage extends StatelessWidget {
  const ReportTheftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Robo'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Reportar Robo'),
      ),
    );
  }
}

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos de Emergencia'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Contactos de Emergencia'),
      ),
    );
  }
}

class EmergencyProtocolPage extends StatelessWidget {
  const EmergencyProtocolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protocolo de Emergencia'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Protocolo de Emergencia'),
      ),
    );
  }
}

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Cuenta'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Información de Cuenta'),
      ),
    );
  }
}

class SubscriptionInfoPage extends StatelessWidget {
  const SubscriptionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscripción'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Información de Suscripción'),
      ),
    );
  }
}

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de Pago'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Métodos de Pago'),
      ),
    );
  }
}
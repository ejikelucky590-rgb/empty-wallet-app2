import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/country_model.dart';
import '../services/country_service.dart';
import 'onboarding_controller.dart';
import '../validators/username_validator.dart';
import 'onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = OnboardingController();

  bool _isSaving = false;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = false;
  bool _hasCheckedUsername = false;

  String? _usernameError;

  // Form Field Value Trackers
  final _stageNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  List<CountryModel> _countries = [];
  List<String> _availableStates = [];

  String? _selectedCountryCode;
  String? _selectedState;
  String? _selectedGender;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _controller.dispose();
    _stageNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await CountryService.loadCountries();
      if (mounted) setState(() => _countries = countries);
    } catch (e) {
      debugPrint('Failed to load countries: $e');
    }
  }

  void _onStageNameChanged(String value) {
    setState(() {
      _hasCheckedUsername = false;
      _isUsernameAvailable = false;
    });
    _controller.usernameDebounce?.cancel();
    _controller.usernameDebounce = Timer(const Duration(milliseconds: 600), () async {
      setState(() {
        _isCheckingUsername = true;
        _usernameError = null;
      });
      
      final result = await _controller.checkUsernameAvailability(UsernameValidator.normalize(value));
      
      if (mounted) {
        setState(() {
          _isUsernameAvailable = result['available'];
          _usernameError = result['error'];
          _isCheckingUsername = false;
          _hasCheckedUsername = true;
        });
      }
    });
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13),
    );
    if (picked != null && mounted) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  Future<void> _submitOnboarding() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountryCode == null || _selectedState == null || _selectedGender == null || _selectedBirthDate == null) {
      _showSnackBar('Please complete all form selection attributes.', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      await _controller.saveProfile(
        stageName: _stageNameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        countryCode: _selectedCountryCode!,
        state: _selectedState!,
        gender: _selectedGender!,
        birthDate: _selectedBirthDate!,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception:', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Complete Your Profile'), centerTitle: true, elevation: 0),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text("Let's build your artist identity", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('This information will be visible to your fans', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 40),

              // Stage/Artist Name Input
              TextFormField(
                controller: _stageNameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Stage / Artist Name',
                  prefixIcon: const Icon(Icons.star_outline),
                  helperText: 'This will also be used as your @username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  errorText: _usernameError,
                  suffixIcon: _isCheckingUsername
                      ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(4.0), child: CircularProgressIndicator(strokeWidth: 2)))
                      : (_hasCheckedUsername && _isUsernameAvailable) ? const Icon(Icons.check_circle, color: Colors.green) : null,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Stage name is required';
                  if (_isCheckingUsername) return 'Checking availability...';
                  if (_hasCheckedUsername && !_isUsernameAvailable) return 'Please choose a different username';
                  return null;
                },
                onChanged: _onStageNameChanged,
              ),
              const SizedBox(height: 20),

              // First and Last Legal Names
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                      validator: (val) => (val?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: 'Last Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                      validator: (val) => (val?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountryCode,
                decoration: InputDecoration(labelText: 'Country', prefixIcon: const Icon(Icons.public), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                items: _countries.map((c) => DropdownMenuItem(value: c.code, child: Text(c.name))).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCountryCode = val;
                    _selectedState = null;
                    _availableStates = _countries.firstWhere((c) => c.code == val).states;
                  });
                },
                validator: (val) => val == null ? 'Country is required' : null,
              ),
              const SizedBox(height: 20),

              // State Dropdown
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(labelText: 'State / Region', prefixIcon: const Icon(Icons.map_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                items: _availableStates.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: _selectedCountryCode == null ? null : (val) => setState(() => _selectedState = val),
                validator: (val) => val == null ? 'State is required' : null,
              ),
              const SizedBox(height: 24),

              // Custom Modular Widgets Split
              GenderSelector(
                selectedGender: _selectedGender,
                onSelected: (gender) => setState(() => _selectedGender = gender),
              ),
              const SizedBox(height: 24),

              BirthDatePickerTile(
                selectedBirthDate: _selectedBirthDate,
                onTap: _pickBirthDate,
              ),
              const SizedBox(height: 40),

              // Form Submit Control Action
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitOnboarding,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isSaving
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

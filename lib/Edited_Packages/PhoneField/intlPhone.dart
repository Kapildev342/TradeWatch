//library intl_phone_field;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CountriesList.dart';
import 'CountryPickerDialog.dart';
import 'phones.dart';

class IntlPhoneField extends StatefulWidget {
  final bool obscureText;

  final TextAlign textAlign;

  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  final ValueChanged<PhoneNumber>? onChanged;

  final ValueChanged<Country>? onCountryChanged;

  final FutureOr<String?> Function(PhoneNumber?)? validator;

  final TextInputType keyboardType;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final void Function(String)? onSubmitted;

  final bool enabled;

  final Brightness? keyboardAppearance;

  final String? initialValue;

  final String? initialCountryCode;

  final List<String>? countries;

  final InputDecoration decoration;

  final TextStyle? style;

  final bool disableLengthCheck;

  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  final TextStyle? dropdownTextStyle;

  final List<TextInputFormatter>? inputFormatters;

  final String searchText;

  final IconPosition dropdownIconPosition;

  final Icon dropdownIcon;

  final bool autofocus;

  final AutovalidateMode? autovalidateMode;

  final bool showCountryFlag;

  final String? invalidNumberMessage;

  final Color? cursorColor;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final double cursorWidth;

  final bool? showCursor;

  final EdgeInsetsGeometry flagsButtonPadding;

  final TextInputAction? textInputAction;

  final PickerDialogStyle? pickerDialogStyle;

  final EdgeInsets flagsButtonMargin;

  IntlPhoneField({
    Key? key,
    this.initialCountryCode,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    @Deprecated('Use searchFieldInputDecoration of PickerDialogStyle instead') this.searchText = 'Search country',
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
    this.flagsButtonMargin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _IntlPhoneFieldState createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries == null ? countries : countries.where((country) => widget.countries!.contains(country.code)).toList();
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (widget.initialCountryCode == null && number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere((country) => number.startsWith(country.dialCode), orElse: () => _countryList.first);
      number = number.substring(_selectedCountry.dialCode.length);
    } else {
      _selectedCountry = _countryList.firstWhere((item) => item.code == (widget.initialCountryCode ?? 'US'), orElse: () => _countryList.first);
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      final initialPhoneNumber = PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: '+${_selectedCountry.dialCode}',
        number: widget.initialValue ?? '',
        maxLength: _selectedCountry.maxLength,
      );

      final value = widget.validator?.call(initialPhoneNumber);

      if (value is String) {
        validatorMessage = value;
      } else {
        (value as Future).then((msg) {
          validatorMessage = msg;
        });
      }
    }
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          style: widget.pickerDialogStyle,
          filteredCountries: filteredCountries,
          searchText: widget.searchText,
          countryList: _countryList,
          selectedCountry: _selectedCountry,
          onCountryChanged: (country) {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
        ),
      ),
    );
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(child: _buildFlagsButton()),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            width: 200,
            child: TextFormField(
              initialValue: (widget.controller == null) ? number : null,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              cursorColor: widget.cursorColor,
              onTap: widget.onTap,
              controller: widget.controller,
              focusNode: widget.focusNode,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorWidth: widget.cursorWidth,
              showCursor: widget.showCursor,
              onFieldSubmitted: widget.onSubmitted,
              decoration: widget.decoration.copyWith(counterText: !widget.enabled ? '' : null),
              style: widget.style,
              onSaved: (value) {
                widget.onSaved?.call(
                  PhoneNumber(
                    countryISOCode: _selectedCountry.code,
                    countryCode: '+${_selectedCountry.dialCode}',
                    number: value!,
                    maxLength: _selectedCountry.maxLength,
                  ),
                );
              },
              onChanged: (value) async {
                final phoneNumber = PhoneNumber(
                  countryISOCode: _selectedCountry.code,
                  countryCode: '+${_selectedCountry.dialCode}',
                  number: value,
                  maxLength: _selectedCountry.maxLength,
                );

                if (widget.autovalidateMode != AutovalidateMode.disabled) {
                  validatorMessage = await widget.validator?.call(phoneNumber);
                }

                widget.onChanged?.call(phoneNumber);
              },
              validator: (value) {
                if (!widget.disableLengthCheck && value != null) {
                  return value.length >= _selectedCountry.minLength && value.length <= _selectedCountry.maxLength ? null : widget.invalidNumberMessage;
                }
                return validatorMessage;
              },
              maxLength: widget.disableLengthCheck ? null : _selectedCountry.maxLength,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              keyboardAppearance: widget.keyboardAppearance,
              autofocus: widget.autofocus,
              textInputAction: widget.textInputAction,
              autovalidateMode: widget.autovalidateMode,
            ),
          ),
        ),
      ],
    );
  }

  Container _buildFlagsButton() {
    return Container(
      margin: widget.flagsButtonMargin,
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFA5A5A5), width: 1.5)),
      child: DecoratedBox(
        decoration: widget.dropdownDecoration,
        child: InkWell(
          borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
          child: Padding(
            padding: widget.flagsButtonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.leading) ...[
                  widget.dropdownIcon,
                  const SizedBox(width: 4),
                ],
                if (widget.showCountryFlag) ...[
                  Image.asset(
                    'lib/Constants/Assets/flags/${_selectedCountry.code.toLowerCase()}.png',
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                FittedBox(
                  child: Text(
                    '+${_selectedCountry.dialCode}',
                    style: widget.dropdownTextStyle,
                  ),
                ),
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.trailing) ...[
                  const SizedBox(width: 4),
                  widget.dropdownIcon,
                ],
                const SizedBox(width: 8),
              ],
            ),
          ),
          onTap: widget.enabled ? _changeCountry : null,
        ),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}

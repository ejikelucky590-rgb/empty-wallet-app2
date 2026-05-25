import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/country_model.dart';

class CountryService {
  static Future<List<CountryModel>>
      loadCountries() async {
    final rawJson = await rootBundle.loadString(
      'lib/data/countries.json',
    );

    final decoded = jsonDecode(rawJson);

    return (decoded as List)
        .map(
          (item) => CountryModel.fromJson(
            item,
          ),
        )
        .toList();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_node/core/validation/field_validators.dart';

void main() {
  group('FieldValidators', () {
    test('requires identity fields', () {
      expect(FieldValidators.requiredText('  ', label: 'Name'), isNotNull);
      expect(FieldValidators.requiredText('Gian', label: 'Name'), isNull);
    });

    test('enforces the message limit', () {
      expect(FieldValidators.message('Hola Full Day 🚀'), isNull);
      expect(FieldValidators.message('a' * 281), isNotNull);
    });
  });
}

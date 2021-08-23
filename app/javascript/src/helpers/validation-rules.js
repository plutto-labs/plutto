import { defineRule } from 'vee-validate';
// eslint-disable-next-line camelcase
import { required, min_value, email } from '@vee-validate/rules';

defineRule('required', required);
defineRule('email', email);
defineRule('minValue', min_value);

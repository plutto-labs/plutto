import { defineRule } from 'vee-validate';

defineRule('required', value => {
  if (!value || !value.length) {
    return 'This field is required';
  }

  return true;
});

defineRule('email', value => {
  if (!value || !value.length) {
    return true;
  }

  // eslint-disable-next-line max-len
  if (!/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(value)) {
    return 'This field must be a valid email';
  }

  return true;
});

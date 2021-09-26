<template>
  <PluttoDropdown
    :selected="selected"
    :options="countryOptions()"
    label-key="label"
    value-key="value"
    @selected="(country) => { this.$emit('country-selected', country) }"
  />
</template>

<script>
import PluttoDropdown from '@/components/plutto-dropdown';

export default {
  components: { PluttoDropdown },
  props: {
    selected: {
      default: null,
      type: String,
    },
  },
  methods: {
    countryOptions() {
      return this.COUNTRIES_KEYS.map((key) => (
        { value: key, label: this.formatCountry(key, { withFlag: true }) }
      ));
    },
  },
};
</script>

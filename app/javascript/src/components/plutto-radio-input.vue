<template>
  <Field
    as="div"
    :name="inputId"
  >
    <div
      class="flex flex-row-reverse items-center justify-end"
      v-for="option in options"
      :key="option"
    >
      <label
        :for="`${inputId}_${option}`"
        class="ml-4"
      >
        {{ option }}
      </label>
      <input
        :value="option"
        class="plutto-checkbox plutto-checkbox--radio"
        :class="{'cursor-not-allowed': disabled}"
        type="radio"
        v-model="selectedOption"
        :id="`${inputId}_${option}`"
        :disabled="disabled"
      >
    </div>
  </Field>
</template>
<script>
import { Field } from 'vee-validate';

export default {
  props: {
    inputId: {
      type: String,
      required: true,
    },
    options: {
      type: Array,
      required: true,
    },
    modelValue: {
      type: String,
      default: '',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  components: { Field },
  computed: {
    selectedOption: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
  },
};
</script>

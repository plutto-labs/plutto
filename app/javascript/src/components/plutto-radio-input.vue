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

<style lang="scss">
.plutto-checkbox {
  @apply appearance-none m-0 text-sm w-4 h-4 outline-none text-center border border-gray-300 cursor-pointer;
  border-radius: .15em;

  &:checked {
    @apply bg-primary border-0;
  }

  &:checked::after {
    content: '\2713';
    line-height: 14px;
    vertical-align: top;
    @apply text-gray-800;
  }

  &--radio {
    @apply rounded-full;

    &:checked::after {
      content: '\2022';
      @apply text-gray-800 mb-1;
      font-size: 32px;
      line-height: 10px;
      margin-left: 1.5px;
    }
  }

  &:disabled {
    @apply opacity-50 bg-gray-500 cursor-not-allowed;
  }
}
</style>

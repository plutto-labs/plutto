<template>
  <div class="relative">
    <div class="relative w-40 h-8 shadow-md">
      <div
        class="absolute top-0 bottom-0 left-0 w-8 h-full leading-none border rounded-l cursor-pointer border-temporary-gray-200"
        :style="`background-color: ${color};`"
        @click="showColorPicker"
      />
      <input
        class="plutto-input__input text-temporary-gray-500"
        :value="color"
        disabled
      >
    </div>
    <div
      class="absolute mt-2"
      v-if="showPicker"
    >
      <ColorPicker
        theme="light"
        :color="color"
        @changeColor="changeColor"
      />
    </div>
  </div>
</template>
<script>
import { ColorPicker } from 'vue-color-kit';
import 'vue-color-kit/dist/vue-color-kit.css';

export default {
  components: {
    ColorPicker,
  },
  props: {
    modelValue: {
      type: String,
      default: '#000000',
    },
  },
  data() {
    return {
      showPicker: false,
    };
  },
  methods: {
    showColorPicker() {
      this.showPicker = !this.showPicker;
    },
    changeColor(color) {
      this.color = color.hex;
    },
  },
  computed: {
    color: {
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
<style scoped>
.hu-color-picker {
  width: 220px !important;
}
</style>

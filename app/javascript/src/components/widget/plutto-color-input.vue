<template>
  <div
    class="relative"
    v-click-outside="closeColorPicker"
  >
    <div class="relative w-40 h-8">
      <div
        class="absolute top-0 bottom-0 left-0 w-8 h-full leading-none border rounded-l cursor-pointer border-gray-700"
        :style="`background-color: ${color};`"
        @click="showColorPicker"
      />
      <input
        class="plutto-input__input text-gray-400"
        :value="color"
        disabled
      >
      <span
        class="absolute top-0 bottom-0 right-0 w-6 h-full text-2xl cursor-pointer plutto-icon text-temporary-gray-200"
        v-if="undo"
        @click="$emit('undo')"
      >
        replay
      </span>
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
import vClickOutside from 'click-outside-vue3';

export default {
  components: {
    ColorPicker,
  },
  props: {
    modelValue: {
      type: String,
      default: '#000000',
    },
    undo: {
      type: Boolean,
      default: false,
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
    closeColorPicker() {
      this.showPicker = false;
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
  directives: {
    clickOutside: vClickOutside.directive,
  },
};
</script>
<style scoped>
.hu-color-picker {
  width: 220px !important;
}
</style>

<template>
  <div
    class="relative inline-block m-auto text-left"
    v-click-outside="closeMenu"
  >
    <div class="h-full rounded-md shadow-sm">
      <Field
        as="div"
        @click="openDropdown"
        v-model="selectedOptionValue"
        :name="dropdownId"
        class="inline-flex items-center justify-center w-full h-full px-4 py-2 text-sm font-medium bg-gray-700 border-gray-500 rounded-md shadow-sm cursor-pointer focus:outline-none text-gray-50 hover:bg-gray-500"
        :class="{'cursor-not-allowed': disabled}"
        id="options-menu"
        aria-haspopup="true"
        aria-expanded="true"
      >
        <span> {{ selectedOption[labelKey] || selectedOption || 'Choose...' }} </span>
        <span class="text-xl plutto-icon">expand_more</span>
      </Field>
    </div>
    <transition
      enter-active-class="transition duration-100 ease-out"
      enter-class="transform scale-95 opacity-0"
      enter-to-class="transform scale-100 opacity-100"
      leave-active-class="transition duration-75 ease-in"
      leave-class="transform scale-100 opacity-100"
      leave-to-class="transform scale-95 opacity-0"
    >
      <div
        v-if="isMenuOpen"
        class="absolute z-50 mt-2 overflow-y-auto bg-gray-700 rounded-md shadow-lg outline-none max-h-48 ring-1 ring-black ring-opacity-5"
        :class="{'left-0': float === 'left', 'right-0': float === 'right'}"
      >
        <div
          class="flex flex-col flex-wrap text-sm"
          role="menu"
          aria-orientation="vertical"
          aria-labelledby="options-menu"
        >
          <div
            class="px-4 py-2 rounded-md cursor-pointer hover:bg-gray-500"
            v-for="(option, optionIndex) in options"
            :key="optionIndex"
            @click="selectOption(option)"
          >
            <a
              class="truncate rounded-md"
            > {{ option && option[labelKey] || option }} </a>
          </div>
          <div
            v-if="addElementText"
            class="border-t-2 border-gray-400 cursor-pointer rounded-b-md hover:bg-gray-500"
            @click="$emit('add-element-clicked'); closeMenu()"
          >
            <a
              class="flex items-center px-4 py-2 text-sm"
            ><span class="mr-4 plutto-icon">add</span> {{ addElementText }} </a>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { Field } from 'vee-validate';
import vClickOutside from 'click-outside-vue3';

export default {
  components: {
    Field,
  },
  props: {
    selected: {
      type: [String, Number],
      default: null,
    },
    options: {
      type: Array,
      required: true,
    },
    valueKey: {
      type: String,
      default: 'value',
    },
    labelKey: {
      type: String,
      default: 'name',
    },
    addElementText: {
      type: String,
      default: null,
    },
    dropdownId: {
      type: String,
      default: '',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    float: {
      type: String,
      default: 'left',
    },
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  data() {
    return {
      selectedOption: '',
      isMenuOpen: false,
    };
  },
  mounted() {
    if (this.selected) {
      this.selectedOption = this.options.find((opt) => opt[this.valueKey] === this.selected) || this.selected;
    }
  },
  methods: {
    selectOption(selectedOption) {
      this.selectedOption = selectedOption;
      this.$emit('selected', selectedOption[this.valueKey] || this.selectedOption);
      this.isMenuOpen = false;
    },
    closeMenu() {
      this.isMenuOpen = false;
    },
    openDropdown() {
      if (!this.disabled) this.isMenuOpen = !this.isMenuOpen;
    },
  },
  computed: {
    selectedOptionValue() {
      return this.selectedOption[this.labelKey] || this.selectedOption || null;
    },
  },
  watch: {
    selected() {
      if (this.selected) {
        this.selectedOption = this.options.find((opt) => opt[this.valueKey] === this.selected) || this.selected;
      }
    },
  },
};
</script>

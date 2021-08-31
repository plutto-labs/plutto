<template>
  <Menu
    as="div"
    class="relative inline-block m-auto text-left"
  >
    <div class="h-full">
      <MenuButton
        class="inline-flex items-center justify-center w-full h-full px-4 py-2 text-sm font-medium bg-gray-700 border-gray-500 rounded-md shadow-sm focus:outline-none text-gray-50 hover:bg-gray-500"
      >
        {{ selectedOption[labelKey] || selectedOption || 'Choose...' }}
        <ChevronDownIcon
          class="w-5 h-5 ml-2 -mr-1"
          aria-hidden="true"
        />
      </MenuButton>
    </div>

    <transition
      enter-active-class="transition duration-75 ease-out"
      enter-from-class="transform scale-95 opacity-0"
      enter-to-class="transform scale-100 opacity-100"
      leave-active-class="transition ease-in duration-50"
      leave-from-class="transform scale-100 opacity-100"
      leave-to-class="transform scale-95 opacity-0"
    >
      <MenuItems class="absolute left-0 right-0 z-50 w-56 mt-2 bg-gray-700 rounded-md shadow-lg outline-none ring-1 ring-black ring-opacity-5">
        <div>
          <MenuItem
            v-slot="{ active }"
            v-for="(option, optionIndex) in options"
            :key="optionIndex"
          >
            <a
              @click="selectOption(option)"
              class="rounded-md"
              :class="[active ? 'bg-gray-500' : 'text-white', 'block px-4 py-2 text-sm']"
            > {{ option && option[labelKey] || option }} </a>
          </MenuItem>
          <MenuItem
            v-slot="{ active }"
            v-if="addElementText"
            class="flex items-center border-t-2 border-gray-400"
          >
            <a
              @click="$emit('add-element-clicked')"
              :class="[active ? 'bg-gray-500' : 'text-white', 'block px-4 py-2 text-sm']"
            ><span class="mr-4 plutto-icon">add</span> {{ addElementText }} </a>
          </MenuItem>
        </div>
      </MenuItems>
    </transition>
  </Menu>
</template>

<script>
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue';
import { ChevronDownIcon } from '@heroicons/vue/solid';

export default {
  components: {
    Menu,
    MenuButton,
    MenuItem,
    MenuItems,
    ChevronDownIcon,
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
  },
  data() {
    return {
      selectedOption: '',
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

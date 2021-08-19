<template>
  <Menu
    as="div"
    class="relative inline-block m-auto text-left"
  >
    <div>
      <MenuButton
        class="inline-flex justify-center w-full px-4 py-2 text-sm font-medium bg-gray-700 border-gray-500 rounded-md shadow-sm focus:outline-none text-gray-50 hover:bg-gray-500"
      >
        {{ selected }}
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
      <MenuItems class="absolute right-0 z-50 w-56 mt-2 origin-top-right bg-gray-700 rounded-md shadow-lg outline-none ring-1 ring-black ring-opacity-5">
        <div>
          <MenuItem
            v-slot="{ active }"
            v-for="(option, optionIndex) in options"
            :key="optionIndex"
          >
            <a
              @click="$emit('selected', option.id)"
              class="rounded-md"
              :class="[active ? 'bg-gray-500' : 'text-white', 'block px-4 py-2 text-sm']"
            > {{ option.value }} </a>
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
      type: String,
      required: true,
    },
    options: {
      type: Array,
      required: true,
    },
  },
};
</script>

<template>
  <div>
    <h2 class="mb-4 text-sm font-medium">
      {{ title }}
    </h2>
    <div class="block">
      <div
        v-for="(option, index) in options"
        :key="index"
        class="py-2 pl-3 text-xs font-medium cursor-pointer hover:border-primary-600"
        :class="option.value === selectedOption ?
          'border-primary-600 border-l text-primary-600' :
          'text-gray-300 border-l border-gray-500'"
        @click="$emit('optionClicked', option.value)"
      >
        {{ option.label }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      required: true,
      type: String,
    },
    options: {
      required: true,
      type: Array,
    },
    selectedOption: {
      required: true,
      type: String,
    },
  },
};
</script>

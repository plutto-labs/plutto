<template>
  <div class="flex">
    <div
      v-for="(tab, index) in tabs"
      :key="index"
      class="px-3 py-2 mr-2 text-xs font-medium cursor-pointer hover:border-primary-600"
      :class="tab.value === selectedTab ?
        'border-primary-600 border text-primary-600' :
        'text-gray-300 border border-gray-500'"
      @click="$emit('tabClicked', tab.value)"
    >
      {{ tab.label }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    tabs: {
      required: true,
      type: Array,
    },
    selectedTab: {
      required: true,
      type: String,
    },
  },
};
</script>

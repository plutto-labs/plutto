<template>
  <div class="flex">
    <div
      v-for="(tab, index) in tabs"
      :key="index"
      class="px-3 py-2 mr-2 text-xs font-medium cursor-pointer hover:border-melon-600"
      :class="tab.value === selectedTab ?
        'border-melon-600 border text-melon-600' :
        'text-gray-600 border border-gray-400'"
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

<template>
  <div class="flex items-center h-8 p-2 space-x-2 bg-gray-800 border border-gray-400 rounded shadow">
    <span
      class="w-6 text-2xl text-gray-400 plutto-icon"
      :class="{ 'text-primary': newValuePresent }"
    >{{ newValuePresent ? 'keyboard_return' : 'search' }}</span>
    <input
      type="text"
      class="w-64 text-sm bg-gray-800 focus:outline-none"
      v-model="searchString"
      @keyup.enter="onEnter"
    >
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchString: '',
      lastSearchedString: '',
    };
  },
  methods: {
    onEnter() {
      this.lastSearchedString = this.searchString;
      this.$emit('search', this.searchString);
    },
  },
  computed: {
    newValuePresent() {
      return this.searchString !== this.lastSearchedString;
    },
  },
};
</script>

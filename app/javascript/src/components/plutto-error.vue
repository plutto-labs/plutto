<template>
  <transition name="fade">
    <div
      class="absolute right-0 flex items-center p-6 text-sm border rounded-l text-danger bg-danger-light top-8 border-danger-light"
      v-if="globalError && globalError.response"
    >
      <span>{{ parsedError.detail || parsedError.message || parsedError }}</span>
      <span
        @click="$store.dispatch('CLEAR_ERROR')"
        class="ml-4 text-xl cursor-pointer plutto-icon"
      >close</span>
    </div>
  </transition>
</template>

<script>
import { mapState } from 'vuex';

export default {
  computed: {
    ...mapState({
      globalError: state => state.ui.error,
    }),
    parsedError() {
      return this.globalError.response.data.error;
    },
  },
};
</script>

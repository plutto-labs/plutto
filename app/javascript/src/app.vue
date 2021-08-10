<template>
  <div id="app">
    <side-bar>
      <router-view />
    </side-bar>
  </div>
</template>

<script>
import SideBar from './components/side-bar.vue';

export default {
  components: {
    SideBar,
  },
};
</script>

<style>
main {
  @apply text-white py-6 px-8 relative z-0 flex-1 overflow-y-auto focus:outline-none bg-gray-900;
}

.plutto-spacer {
  @apply border-b-4 border-gray-900;
}
</style>

<template>
  <div id="app">
    <side-bar>
      <div class="content">
        <router-view />
      </div>
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
  @apply text-white py-6 px-8;
}
</style>

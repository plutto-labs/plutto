<template>
  <div id="app">
    <p>{{ message }}</p>
    <router-link
      to="/"
      class=""
    >
      Home
    </router-link>
    <side-bar>
      <div class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <h1 class="text-2xl font-semibold text-gray-900">
          Dashboard
        </h1>
      </div>
      <div class="px-4 mx-auto max-w-7xl sm:px-6 md:px-8">
        <div class="py-4">
          <div class="border-4 border-gray-200 border-dashed rounded-lg h-96" />
        </div>
      </div>
    </side-bar>
  </div>
</template>

<script>
import SideBar from './side-bar.vue';

export default {
  data() {
    return {
      message: 'Hello Vue!',
    };
  },
  components: {
    SideBar,
  },
};
</script>

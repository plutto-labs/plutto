<template>
  <div id="app">
    <p>{{ message }}</p>
    <router-link
      to="/"
      class=""
    >
      Home
    </router-link>
  </div>
</template>

<script>
export default {
  data() {
    return {
      message: 'Hello Vue!',
    };
  },
};
</script>

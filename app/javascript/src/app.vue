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

<style lang="scss">
main {
  @apply text-white py-6 relative z-0 flex-1 overflow-y-auto focus:outline-none bg-gray-900;
}

.btn {
  @apply inline-flex text-sm px-6 py-0 font-medium bg-transparent border border-primary text-primary
    tracking-wide no-underline justify-center items-center cursor-pointer rounded-md;
  min-height: 32px;

  &--big {
    @apply h-6 text-base;
    min-width: 148px;
  }

  &--filled {
    @apply border-0 bg-primary-600 text-gray-900;
  }

  &--cancel {
    @apply border-danger text-danger;
  }

  &--secondary {
    @apply border-secondary text-secondary;
  }

  &--full {
    @apply w-full;
  }

  &[disabled] {
    @apply border-0 bg-gray-200 text-gray-400 cursor-not-allowed;
  }
}

.plutto-spacer {
  @apply border-b-4 border-gray-400;
}
</style>

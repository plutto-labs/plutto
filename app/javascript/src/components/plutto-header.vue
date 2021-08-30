<template>
  <header>
    <span
      v-if="showBackButton"
      @click="$router.go(-1)"
    >arrow_back</span>
    <h1 v-if="title">
      {{ title }}
    </h1>
    <div v-if="buttonText">
      <button
        class="btn"
        @click="$emit('button-clicked')"
      >
        {{ buttonText }}
      </button>
    </div>
  </header>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: null,
    },
    showBackButton: {
      type: Boolean,
      default: false,
    },
    buttonText: {
      type: String,
      default: null,
    },
  },
};
</script>

<style scoped lang="scss">
header {
  @apply grid gap-3 text-xl px-6 text-white;

  grid-template-columns: 3rem 1fr minmax(auto, 15rem);
  grid-template-areas: 'back title action';

  span {
    @apply flex items-center justify-center h-full cursor-pointer;
    grid-area: back;
    font-family: 'Material Icons';
  }

  h1 {
    grid-area: title;
  }

  div {
    @apply text-right flex items-center justify-end;
    grid-area: action;
  }
}
</style>

<template>
  <div id="app">
    <NavBar v-if="loggedIn">
      <router-view />
    </NavBar>
    <router-view v-else />
  </div>
</template>

<script>
import NavBar from './components/nav-bar.vue';

export default {
  props: {
    environment: {
      type: String,
      required: true,
    },
  },
  components: {
    NavBar,
  },
  computed: {
    loggedIn() {
      return this.$store.getters.isLoggedIn;
    },
  },
  beforeMount() {
    this.$store.dispatch('SET_ENVIRONMENT', this.environment);
  },
};
</script>

<style lang="scss">
main {
  @apply text-white py-6 relative z-0 flex-1 overflow-y-auto focus:outline-none bg-gray-900 h-screen;
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
    @apply border-0 text-gray-900 bg-gray-300 cursor-not-allowed;
  }
}

.plutto-spacer {
  @apply border-b-4 border-gray-400;
}

.plutto-input {
  @apply h-12 relative w-full;

  &__icon {
    @apply left-0 h-5 absolute m-auto top-0 bottom-0 mx-3 text-xl leading-none;
    font-family: 'Material Icons';
  }

  &__icon-right {
    @apply right-0 h-5 absolute m-auto top-0 bottom-0 mx-3 text-xl leading-none;
    font-family: 'Material Icons';
  }

  &__input {
    @apply h-full bg-transparent w-full pl-10 rounded border border-gray-200;

    &::placeholder {
      @apply text-gray-200;
    }

    &:focus {
      @apply border-primary outline-none;
      box-shadow: 0 0 4px 0 rgba(165, 206, 204, .72), inset -2px -2px 2px 0 rgba(233, 214, 215, .18);

      &::placeholder {
        @apply border-primary;
      }
    }
  }
}

.plutto-tag {
  @apply px-4 py-1 text-xs text-gray-800 rounded-lg bg-primary-200;

  &--green {
    @apply bg-transparent text-success border border-success;
  }
}

.plutto-icon {
  @apply block text-xl leading-none;
  font-family: 'Material Icons';
}

/* stylelint-disable selector-no-qualifying-type, rule-empty-line-before, property-no-vendor-prefix*/

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  appearance: none;
  margin: 0;
}

input[type=number] {
  -moz-appearance: textfield;
}
</style>

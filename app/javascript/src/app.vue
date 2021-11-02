<template>
  <div
    id="app"
    class="h-screen bg-gray-900"
  >
    <div
      v-if="loggedUser"
      class="flex items-center justify-center w-full h-8 bg-danger-light text-danger text-bold"
    >
      Logged As: {{ loggedUser.email }}, remember to logout!
    </div>
    <NavBar v-if="loggedIn">
      <router-view class="h-full" />
    </NavBar>
    <router-view
      v-else
      class="h-full"
    />
    <PluttoError />
  </div>
</template>

<script>
import { mapState } from 'vuex';
import NavBar from '@/components/nav-bar.vue';
import PluttoError from '@/components/plutto-error.vue';

export default {
  components: { NavBar, PluttoError },
  props: {
    loggedUser: {
      type: Object,
      default: () => {},
    },
  },
  async beforeCreate() {
    if (this.loggedUser?.id !== undefined) {
      this.$store.dispatch('UPDATE_USER_DATA', this.loggedUser.id)
        .catch((err) => {
          if (err.response && err.response.status === 401) {
            this.$store.dispatch('LOGOUT_USER');
            this.$router.replace('/login');
          }
        });
    }
  },
  beforeMount() {
    if (this.loggedIn) {
      this.$store.dispatch('UPDATE_USER_DATA', this.currentUser.id)
        .catch((err) => {
          if (err.response && err.response.status === 401) {
            this.$store.dispatch('LOGOUT_USER');
            this.$router.replace('/login');
          }
        });
    }
  },
  computed: {
    ...mapState({
      currentUser: state => state.auth,
    }),
    loggedIn() {
      return this.$store.getters.isLoggedIn;
    },
  },
};
</script>

<style lang="scss">
main {
  @apply text-white py-6 relative z-0 flex-1 overflow-y-auto focus:outline-none;
}

.btn {
  @apply inline-flex text-sm px-6 py-0 font-medium bg-transparent border border-primary text-primary
    tracking-wide no-underline justify-center items-center cursor-pointer rounded-md hover:bg-gray-600
    focus:bg-gray-600;
  min-height: 32px;

  &--big {
    @apply h-6 text-base;
    min-width: 148px;
  }

  &--filled {
    @apply border-0 bg-primary-600 text-gray-900 hover:bg-primary-400 focus:bg-primary-400;
  }

  &--cancel {
    @apply border-danger text-danger;
  }

  &--dismiss {
    @apply border-gray-300 text-gray-300;
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

  &__label {
    @apply absolute text-gray-300 md:-mt-6 -mt-4 text-xs md:text-base;
  }

  &__input {
    @apply h-full bg-transparent w-full pl-10 rounded border border-gray-200;

    &::placeholder {
      @apply text-gray-100 text-opacity-50;
    }

    &:focus {
      @apply border-primary outline-none;
      box-shadow: 0 0 4px 0 rgba(165, 206, 204, .72), inset -2px -2px 2px 0 rgba(233, 214, 215, .18);

      &::placeholder {
        @apply border-primary;
      }
    }

    &--no-icon {
      @apply pl-4;
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
  @apply block leading-none;
  font-family: 'Material Icons';
}

.tag-color {
  &--purple {
    @apply text-purple-800 bg-purple-200;
  }

  &--blue {
    @apply text-blue-800 bg-blue-200;
  }

  &--green {
    @apply text-green-800 bg-green-200;
  }

  &--red {
    @apply text-red-800 bg-red-200;
  }

  &--yellow {
    @apply text-yellow-800 bg-yellow-200;
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity .5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
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

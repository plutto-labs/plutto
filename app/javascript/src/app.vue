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

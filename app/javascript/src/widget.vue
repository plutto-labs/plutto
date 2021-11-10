<template>
  <div
    id="app"
    class="h-screen"
  >
    <NavBar v-if="loggedIn">
      <router-view />
    </NavBar>
    <router-view v-else />
    <PluttoError />
  </div>
</template>

<script>
import { mapState } from 'vuex';
import NavBar from '@/components/widget/nav-bar.vue';
import PluttoError from '@/components/plutto-error.vue';

export default {
  components: { NavBar, PluttoError },
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

<style lang="scss" scoped>
main {
  @apply py-6 relative z-0 flex-1 overflow-y-auto focus:outline-none text-temporary-primary h-full;
}

</style>

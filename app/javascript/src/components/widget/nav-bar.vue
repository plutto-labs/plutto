<template>
  <div>
    <nav class="flex justify-between px-4 py-4 bg-temporary-gray-100 md:px-8">
      <h1 class="flex items-center text-2xl font-semibold text-temporary">
        <span class="mr-2 text-melon md:mr-8 material-icons">nightlight</span>
        <div class="flex">
          <p>
            Plutto
          </p>
        </div>
      </h1>
      <div class="flex">
        <div class="flex items-center">
          <div class="mr-2 md:mr-6 w-28 md:w-auto">
            <p class="text-sm font-medium truncate text-temporary">
              {{ currentUser.email }}
            </p>
            <p
              class="text-xs font-medium text-right cursor-pointer text-temporary"
              @click="logout()"
            >
              Logout
            </p>
          </div>
          <p class="inline-block p-1 text-xl text-center text-white uppercase rounded-full h-9 w-9 bg-melon">
            {{ currentUser.email.charAt(0) }}
          </p>
        </div>
      </div>
    </nav>
    <nav class="flex justify-between px-4 overflow-x-scroll md:px-16">
      <div class="flex">
        <router-link
          v-for="item in navigation"
          :key="item.label"
          :to="item.path"
          :class="[
            item.matchingRoutes.includes($route.name) ?
              'text-melon border-b-2 border-melon' :
              'text-temporary-gray-300 hover:text-melon border-b border-temporary-gray-100',
            'px-3 py-4 text-xs md:text-sm font-medium'
          ]"
        >
          {{ item.label }}
        </router-link>
      </div>
      <div class="w-full border-b border-temporary-gray-100" />
    </nav>
    <div class="h-full px-4 md:px-16">
      <slot />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

const navigation = [
  { label: 'Embed', path: '/embed', matchingRoutes: ['embed'] },
  { label: 'Dashboard', path: '/dashboard', matchingRoutes: ['dashboard'] },
  { label: 'Settings', path: '/widget-settings', matchingRoutes: ['widget-settings'] },
];

export default {
  computed: {
    ...mapState({
      currentUser: state => state.auth,
      organization: state => state.organization,
    }),
  },
  mounted() {
    this.analyticsIdentify(this.currentUser.id, {
      email: this.currentUser.email,
    });
    this.analyticsGroup(this.organization.id, {
      name: this.organization.name,
    });
  },
  methods: {
    async logout() {
      await this.$store.dispatch('LOGOUT_USER');
      this.$router.replace('/login');
    },
  },
  setup() {
    return {
      navigation,
    };
  },
};
</script>

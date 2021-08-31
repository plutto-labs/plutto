<template>
  <div class="bg-gray-900">
    <nav class="flex justify-between px-4 py-4 bg-gray-800 md:px-8">
      <h1 class="flex items-center text-2xl font-semibold text-primary">
        <span class="mr-2 text-white md:mr-8 material-icons">nightlight</span> Plutto
      </h1>
      <div class="flex">
        <div class="flex items-center">
          <div class="mr-2 md:mr-6 w-28 md:w-auto">
            <p class="text-sm font-medium text-white truncate">
              {{ currentUser.email }}
            </p>
            <p
              class="text-xs font-medium text-right text-gray-300 cursor-pointer group-hover:text-gray-200"
              @click="logout()"
            >
              Logout
            </p>
          </div>
          <p class="inline-block p-1 text-xl text-center uppercase rounded-full h-9 w-9 bg-primary">
            {{ currentUser.email.charAt(0) }}
          </p>
        </div>
      </div>
    </nav>
    <!-- <div class="plutto-spacer" /> -->
    <nav class="flex px-4 overflow-x-scroll md:px-16">
      <router-link
        v-for="item in navigation"
        :key="item.label"
        :to="item.path"
        :class="[
          item.matchingRoutes.indexOf($route.name) !== -1 ?
            'text-white border-b border-primary' : 'text-gray-300 hover:text-white',
          'px-3 mx-1 py-4 text-xs md:text-sm font-medium'
        ]"
      >
        {{ item.label }}
      </router-link>
    </nav>
    <div class="md:px-16">
      <slot />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { mapState } from 'vuex';

const navigation = [
  { label: 'Customers', path: '/customers', matchingRoutes: ['customers', 'new-customer'] },
  { label: 'Plans', path: '/plans', matchingRoutes: ['plans', 'new-plan', 'new-plan-version', 'plan'] },
  { label: 'Meters', path: '/meters', matchingRoutes: ['meters'] },
  { label: 'Settings', path: '/settings', matchingRoutes: ['settings'] },
];

export default {
  data() {
    return {
      settingsItem: { label: 'Settings', path: '/settings' },
    };
  },
  computed: {
    ...mapState({
      currentUser: state => state.auth,
    }),
  },
  mounted() {
    this.analyticsIdentify(this.currentUser.id, {
      email: this.currentUser.email,
    });
    this.analyticsGroup(this.currentUser.organizationId, {
      name: this.currentUser.organizationName,
    });
  },
  methods: {
    logout() {
      this.$store.dispatch('LOGOUT_USER');
      this.$router.replace('/login');
    },
  },
  setup() {
    const sidebarOpen = ref(false);

    return {
      navigation,
      sidebarOpen,
    };
  },
};
</script>

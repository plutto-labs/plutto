<template>
  <div class="flex h-screen overflow-hidden bg-gray-100">
    <TransitionRoot
      as="template"
      :show="sidebarOpen"
    >
      <Dialog
        as="div"
        static
        class="fixed inset-0 z-40 flex md:hidden"
        @close="sidebarOpen = false"
        :open="sidebarOpen"
      >
        <TransitionChild
          as="template"
          enter="transition-opacity ease-linear duration-300"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="transition-opacity ease-linear duration-300"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <DialogOverlay class="fixed inset-0 bg-gray-600 bg-opacity-75" />
        </TransitionChild>
        <TransitionChild
          as="template"
          enter="transition ease-in-out duration-300 transform"
          enter-from="-translate-x-full"
          enter-to="translate-x-0"
          leave="transition ease-in-out duration-300 transform"
          leave-from="translate-x-0"
          leave-to="-translate-x-full"
        >
          <div class="relative flex flex-col flex-1 w-full max-w-xs bg-gray-800">
            <TransitionChild
              as="template"
              enter="ease-in-out duration-300"
              enter-from="opacity-0"
              enter-to="opacity-100"
              leave="ease-in-out duration-300"
              leave-from="opacity-100"
              leave-to="opacity-0"
            >
              <div class="absolute top-0 right-0 pt-2 -mr-12">
                <button
                  class="flex items-center justify-center w-10 h-10 ml-1 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                  @click="sidebarOpen = false"
                >
                  <span class="sr-only">Close sidebar</span>
                  <XIcon
                    class="w-6 h-6 text-white"
                    aria-hidden="true"
                  />
                </button>
              </div>
            </TransitionChild>
            <div class="flex-1 h-0 py-6 overflow-y-auto">
              <div class="flex items-center flex-shrink-0 px-4 mb-6">
                <h1 class="flex items-center text-2xl font-semibold text-primary">
                  <span class="mr-3 text-white material-icons">nightlight</span> Plutto
                </h1>
              </div>
              <div class="plutto-spacer" />
              <nav class="px-2 mt-6 space-y-1 bg-gray-800">
                <router-link
                  v-for="item in navigation"
                  :key="item.label"
                  :to="item.path"
                  :class="[
                    $route.path === item.path ?
                      'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white',
                    'group flex items-center px-2 py-2 text-base font-medium rounded-md'
                  ]"
                >
                  <component
                    :is="item.icon"
                    :class="[
                      $route.path === item.path ? 'text-primary' : 'text-primary-200 group-hover:text-primary-100',
                      'mr-4 flex-shrink-0 h-6 w-6'
                    ]"
                    aria-hidden="true"
                  />
                  {{ item.label }}
                </router-link>
              </nav>
            </div>
            <div class="flex flex-shrink-0 p-4 bg-gray-700">
              <div class="flex items-center">
                <div>
                  <img
                    class="inline-block w-10 h-10 rounded-full"
                    src="https://s3.amazonaws.com/nest.platan.us/team_members/pictures/000/000/013/square/ham.jpg?1489623587"
                    alt=""
                  >
                </div>
                <div class="ml-3">
                  <p class="text-base font-medium text-white">
                    {{ currentUser.email }}
                  </p>
                  <p
                    class="text-xs font-medium text-gray-300 cursor-pointer group-hover:text-gray-200"
                    @click="logout()"
                  >
                    Logout
                  </p>
                </div>
              </div>
            </div>
          </div>
        </TransitionChild>
        <div class="flex-shrink-0 w-14">
          <!-- Force sidebar to shrink to fit close icon -->
        </div>
      </Dialog>
    </TransitionRoot>

    <!-- Static sidebar for desktop -->
    <div class="hidden md:flex md:flex-shrink-0">
      <div class="flex flex-col w-64">
        <!-- Sidebar component, swap this element with another sidebar if you like -->
        <div class="flex flex-col flex-1 h-0 bg-gray-800">
          <div class="flex flex-col flex-1 py-6 overflow-y-auto">
            <div class="flex items-center flex-shrink-0 px-4 mb-6">
              <h1 class="flex items-center text-2xl font-semibold text-primary">
                <span class="mr-3 text-white material-icons">nightlight</span> Plutto
              </h1>
            </div>
            <div class="plutto-spacer" />
            <nav class="flex-1 px-2 mt-6 space-y-1 bg-gray-800">
              <router-link
                v-for="item in navigation"
                :key="item.label"
                :to="item.path"
                :class="[
                  $route.path === item.path ?
                    'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white',
                  'group flex items-center px-2 py-2 text-sm font-medium rounded-md'
                ]"
              >
                <component
                  :is="item.icon"
                  :class="[$route.path === item.path ?
                    'text-primary' :
                    'text-primary-200 group-hover:text-primary-100', 'mr-3 flex-shrink-0 h-6 w-6']"
                  aria-hidden="true"
                />
                {{ item.label }}
              </router-link>
            </nav>
          </div>
          <div class="flex flex-shrink-0 p-4 bg-gray-700">
            <div class="flex items-center">
              <div>
                <img
                  class="inline-block rounded-full h-9 w-9"
                  src="https://s3.amazonaws.com/nest.platan.us/team_members/pictures/000/000/013/square/ham.jpg?1489623587"
                  alt=""
                >
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-white">
                  {{ currentUser.email }}
                </p>
                <p
                  class="text-xs font-medium text-gray-300 cursor-pointer group-hover:text-gray-200"
                  @click="logout()"
                >
                  Logout
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-col flex-1 w-0 overflow-hidden">
      <div class="pt-1 pl-1 bg-gray-900 md:hidden sm:pl-3 sm:pt-3">
        <button
          class="-ml-0.5 -mt-0.5 h-12 w-12 inline-flex items-center justify-center rounded-md text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
          @click="sidebarOpen = true"
        >
          <span class="sr-only">Open sidebar</span>
          <MenuIcon
            class="w-6 h-6"
            aria-hidden="true"
          />
        </button>
      </div>
      <slot />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { mapState } from 'vuex';
import { Dialog, DialogOverlay, TransitionChild, TransitionRoot } from '@headlessui/vue';
import {
  FolderIcon,
  MenuIcon,
  UsersIcon,
  XIcon,
  LightningBoltIcon,
} from '@heroicons/vue/outline';

const navigation = [
  { label: 'Customers', path: '/customers', icon: UsersIcon },
  { label: 'Plans', path: '/plans', icon: FolderIcon },
  { label: 'Meters', path: '/meters', icon: LightningBoltIcon },
];

export default {
  components: {
    Dialog,
    DialogOverlay,
    TransitionChild,
    TransitionRoot,
    MenuIcon,
    XIcon,
  },
  computed: {
    ...mapState({
      currentUser: state => state.auth,
    }),
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

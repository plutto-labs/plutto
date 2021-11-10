<template>
  <main>
    <div class="px-6 mt-6">
      <div class="w-full mx-auto md:max-w-xl">
        <p class="pb-2 border-b text-gray-5 border-gray-50">
          Your API Keys
        </p>
        <div
          class="p-4 mt-4 bg-gray-800 rounded-lg"
          v-for="(apiKey, index) in apiKeys"
          :key="index"
        >
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-50">
                {{ apiKey.name }}
              </p>
              <p class="pt-2 text-sm font-medium text-gray-500">
                {{ formatDateTime(apiKey.createdAt) }}
              </p>
            </div>
            <TrashIcon
              class="w-6 h-6 cursor-pointer text-primary"
              @click="deleteApiKey(apiKey)"
            />
          </div>
          <div v-if="apiKey.token">
            <PluttoCopyableDiv
              class="pt-2 mx-auto text-sm"
              icon-class="text-xl text-primary"
              :value="apiKey.token"
            />
            <p class="text-xs text-danger-light">
              Make sure to copy your API key now. You won’t be able to see it again!
            </p>
          </div>
        </div>
        <div
          v-if="apiKeys && apiKeys.length > 0 && !createEnabled"
          class="flex justify-end mt-4"
        >
          <button
            class="px-4 py-2 btn"
            @click="createEnabled = true"
          >
            Add new
          </button>
        </div>
        <div
          v-else
          class="flex gap-4 mt-4"
        >
          <div class="bg-gray-800 rounded-lg plutto-input">
            <input
              placeholder="Name your API key"
              class="bg-gray-900 plutto-input__input"
              v-model="newApiKey.name"
            >
          </div>
          <div class="flex items-center">
            <label for="api-key-public">Public?</label>
            <input
              type="checkbox"
              class="ml-2 plutto-checkbox"
              id="api-key-public"
              v-model="newApiKey.public"
            >
          </div>
          <button
            class="p-2 btn"
            @click="createApiKey"
          >
            Create
          </button>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';
import { TrashIcon } from '@heroicons/vue/outline';

export default {
  components: { PluttoCopyableDiv, TrashIcon },
  data() {
    return {
      name: '',
      newApiKey: {},
      createEnabled: false,
    };
  },
  computed: {
    ...mapState({
      organization: state => state.organization,
      apiKeys: state => state.apiKeys.apiKeys,
    }),
    bearer() {
      return { bearerType: 'Organization', bearerId: this.organization.id };
    },
  },
  async mounted() {
    await this.$store.dispatch('GET_API_KEYS', this.bearer);
  },
  methods: {
    copyToClipboard() {
      navigator.clipboard.writeText(this.apiKey);
    },
    createApiKey() {
      this.$store.dispatch('CREATE_API_KEY',
        { ...this.bearer, ...this.newApiKey, category: this.newApiKey.public ? 'pk' : 'sk' },
      ).then(() => {
        this.newApiKey = {};
        this.createEnabled = false;
      });
    },
    deleteApiKey(apiKey) {
      this.$store.dispatch('DESTROY_API_KEY', apiKey);
    },
  },
};
</script>

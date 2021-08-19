<template>
  <main>
    <PluttoHeader
      title="Settings"
    />
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
              value="api_key_dd4bf05727515ce2704b96bf0a5046afd38f54faeeeaeba32be4eec51ba05234"
            />
            <p class="text-xs text-danger-light">
              Make sure to copy your API key now. You won’t be able to see it again!
            </p>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';
import dateTime from '@/utils/date-time';
import { TrashIcon } from '@heroicons/vue/outline';

export default {
  components: { PluttoHeader, PluttoCopyableDiv, TrashIcon },
  computed: {
    ...mapState({
      organizationName: state => state.auth.organizationName,
      organizationId: state => state.auth.organizationId,
      apiKeys: state => state.apiKeys.apiKeys,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_API_KEYS', { bearerType: 'Organization', bearerId: this.organizationId });
  },
  methods: {
    copyToClipboard() {
      navigator.clipboard.writeText(this.apiKey);
    },
    formatDateTime(date) {
      return dateTime(date);
    },
    deleteApiKey(apiKey) {
      this.$store.dispatch('DESTROY_API_KEY', apiKey);
    },
  },
};
</script>

<template>
  <main>
    <PluttoHeader
      title="Settings"
    />
    <div class="px-6 mt-6">
      <div class="max-w-xl p-10 mx-auto space-y-5 bg-gray-800 rounded-lg">
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500">
          <label class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2">
            Organization
          </label>
          <div class="mt-1 plutto-input sm:mt-0 sm:col-span-2">
            <input
              class="block w-full bg-gray-700 border-gray-500 rounded-md plutto-input__input text-gray-50 focus:ring-0 focus:border-primary sm:text-sm"
              type="text"
              v-model="organizationName"
              disabled
            >
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2">
            API Key
          </label>
          <div class="mt-1 plutto-input sm:mt-0 sm:col-span-2">
            <span
              class="cursor-pointer plutto-input__icon-right text-primary"
              @click="copyToClipboard"
            >
              content_copy
            </span>
            <input
              class="block w-full bg-gray-700 border-gray-500 rounded-md plutto-input__input text-gray-50 focus:ring-0 focus:border-primary sm:text-sm"
              type="password"
              v-model="apiKey"
              disabled
            >
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';

export default {
  components: { PluttoHeader },
  data() {
    return {
      apiKey: 'XXXXXXXXXXXXXXXXXXXXXX',
    };
  },
  computed: {
    ...mapState({
      organizationName: state => state.auth.organizationName,
    }),
  },
  methods: {
    copyToClipboard() {
      navigator.clipboard.writeText(this.apiKey);
    },
  },
};
</script>

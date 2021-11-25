<template>
  <div class="px-6 mt-6">
    <div class="w-full md:max-w-xl">
      <p class="pb-2 border-b text-gray-5 border-gray-50">
        Payment Settings
      </p>
    </div>
    <div
      v-if="newSettings"
      class="mt-6"
    >
      <div class="flex flex-row-reverse items-center justify-end">
        <label
          for="autopost"
          class="ml-4"
        >
          Post invoices automatically
          <div class="text-xs text-gray-700">
            An email with invoice details will be sent to customers every billing period
          </div>
        </label>
        <input
          class="plutto-checkbox"
          type="checkbox"
          v-model="newSettings.sendInvoicesAutomatically"
          id="autopost"
          @change="updateSettings"
        >
      </div>
      <div class="flex flex-row-reverse items-center justify-end mt-2">
        <label
          for="autocollect"
          class="ml-4"
        >
          Charge invoices automatically
          <div class="text-xs text-gray-700">
            Your customers will be charged automatically if payment methods are available
          </div>
        </label>
        <input
          class="plutto-checkbox"
          type="checkbox"
          v-model="newSettings.chargeInvoicesAutomatically"
          id="autocollect"
          disabled
          @change="updateSettings"
        >
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  data() {
    return {
      newSettings: null,
    };
  },
  beforeMount() {
    this.newSettings = { ...this.settings };
  },
  methods: {
    async updateSettings() {
      await this.$store.dispatch('UPDATE_ORGANIZATION', { ...this.organization, settings: this.newSettings });
      this.newSettings = { ...this.settings };
    },
  },
  computed: {
    ...mapState({
      organization: store => store.organization,
      settings: store => store.organization.settings,
    }),
  },
};
</script>

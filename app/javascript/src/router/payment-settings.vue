<template>
  <div class="px-6 mt-6">
    <div class="w-full md:max-w-xl">
      <p class="pb-2 border-b text-gray-5 border-gray-50">
        Payment Settings
      </p>
    </div>
    <div
      v-if="settings"
      class="mt-6"
    >
      <div class="flex flex-row-reverse items-center justify-end">
        <label
          for="autocollect"
          class="ml-4"
        >
          Send invoices automatically
          <div class="text-xs text-gray-200">
            An email with invoice details will be sent to customers every billing period
          </div>
        </label>
        <input
          class="plutto-checkbox"
          type="checkbox"
          v-model="settings.sendInvoicesAutomatically"
          id="autocollect"
          @change="updateSettings"
        >
      </div>
      <div class="flex flex-row-reverse items-center justify-end mt-2">
        <label
          for="autocollect"
          class="ml-4"
        >
          Charge invoices automatically
          <div class="text-xs text-gray-200">
            Your customers will be charged automatically if payment methods are available
          </div>
        </label>
        <input
          class="plutto-checkbox"
          type="checkbox"
          v-model="settings.chargeInvoicesAutomatically"
          id="autocollect"
          @change="updateSettings"
        >
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  methods: {
    updateSettings() {
      this.$store.dispatch('UPDATE_SETTINGS', { ...this.organization, settings: this.settings });
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

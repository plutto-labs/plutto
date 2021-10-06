<template>
  <Form
    @submit="submit"
    class="w-full px-4 space-y-8 divide-y divide-gray-200 md:max-w-xl md:px-6"
  >
    <div class="m-auto divide-gray-200">
      <div class="sm:col-span-3">
        <div class="mt-8 mb-4 text-lg">
          Plan
        </div>
        <div class="flex my-4">
          <div class="w-full mr-8 plutto-input">
            <label
              for="name"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.name') }}
            </label>
            <input
              class="mt-2 plutto-input__input"
              v-model="newPlan.name"
            >
          </div>
          <div class="w-32 mr-8">
            <label
              for="priceCurrency"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.currency') }}
            </label>
            <PluttoDropdown
              class="w-32 mt-2 plutto-input"
              :selected="newPlan.priceCurrency"
              :options="CURRENCY_KEYS"
              @selected="(priceCurrency) => newPlan.priceCurrency = priceCurrency"
            />
          </div>
        </div>
      </div>
      <div class="mt-8 mb-4 text-lg">
        Permissions
      </div>
      <div
        class="flex items-center justify-between plutto-input"
        v-for="permission in permissions"
        :key="permission.id"
      >
        <div class="flex flex-row-reverse items-center justify-end">
          <label
            :for="`${permission.id}`"
            class="ml-4"
          >
            {{ permission.name }}
          </label>
          <input
            type="checkbox"
            class="plutto-checkbox"
            :id="`${permission.id}`"
            @change="toggleChecked(permission)"
          >
        </div>
        <div v-if="selectedPermissions[permission.id] && permission.meter">
          <label class="mr-4">limit:</label>
          <input
            class="w-20 h-8 px-1 text-center plutto-input__input plutto-input__input--no-icon"
            v-model="selectedPermissions[permission.id].limit"
            type="text"
          >
        </div>
      </div>
    </div>
    <div class="pt-5">
      <div class="flex justify-end">
        <button class="btn">
          Create Plan
        </button>
      </div>
    </div>
  </Form>
</template>

<script>
import PluttoDropdown from '@/components/plutto-dropdown';
import { Form } from 'vee-validate';

export default {
  components: { Form, PluttoDropdown },
  data() {
    return {
      newPlan: {
        name: null,
        priceCurrency: 'CLP',
      },
      // temporal permissions
      permissions: [{
        id: 1,
        name: 'GB Video',
        meter: { id: 'meter-123', name: 'GB Video', meterCountMethod: 'period_sum' },
      }, {
        id: 2,
        name: 'GB Photos',
        meter: { id: 'meter-231', name: 'GB Photos', meterCountMethod: 'period_sum' },
      }, {
        id: 3,
        name: 'Portals',
        meter: { id: 'meter-312', name: 'Portals', meterCountMethod: 'historic_sum' },
      }, {
        id: 4,
        name: 'Dashboard',
        meter: null,
      }, {
        id: 5,
        name: 'Analytics',
        meter: null,
      }, {
        id: 5,
        name: 'Group Sessions',
        meter: null,
      }],
      selectedPermissions: {},
    };
  },
  methods: {
    submit() {
      const plan = { ...this.newPlan, planPermissionsAttributes: this.selectedPermissions };
      this.$store.dispatch('CREATE_PLAN', { plan })
        .then((product) => this.$emit('created-product', product));
    },
    toggleChecked(permission) {
      if (this.selectedPermissions[permission.id]) {
        delete this.selectedPermissions[permission.id];
      } else {
        this.selectedPermissions[permission.id] = { id: permission.id, limit: null };
      }
    },
  },
};
</script>

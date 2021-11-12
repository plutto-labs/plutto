<template>
  <Form
    @submit="editingPermission ? updatePermission() : createPermission()"
    class="max-w-xl p-4 mx-auto space-y-5 bg-gray-50 rounded-lg"
    :validation-schema="schema"
    v-slot="{ errors }"
  >
    <div class="space-y-6 sm:space-y-5">
      <div class="space-y-6 sm:space-y-5">
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-400 sm:pt-5">
          <label
            for="first-name"
            class="block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Name
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-200 border-gray-400 plutto-input__input text-gray-900 sm:max-w-xs sm:text-sm"
              type="text"
              name="name"
              id="name"
              autocomplete="name"
              v-model="newPermission.name"
            />
            <span
              class="absolute text-sm text-danger-light"
              v-if="errors.name"
            >
              Required
            </span>
          </div>
        </div>
        <div class="space-y-6 sm:space-y-5">
          <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-400 sm:pt-5">
            <label
              for="meter-type"
              class="block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 sm:ml-4"
            >
              ¿Track usage?<br>
              <span class="text-xs text-gray-600">Leave empty if not</span>
            </label>
            <PluttoDropdown
              class="w-full plutto-input"
              :selected="newPermission.meterId"
              :options="meters"
              label-key="name"
              value-key="id"
              @selected="(meterId) => newPermission.meterId = meterId"
            />
          </div>
        </div>
        <div
          v-if="newPermission.meterId"
          class="space-y-6 sm:space-y-5"
        >
          <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-400 sm:pt-5">
            <label
              for="meter-type"
              class="block text-sm font-medium text-gray-900 sm:mt-px sm:pt-2 sm:ml-4"
            >
              Using:
            </label>
            <PluttoDropdown
              class="w-full plutto-input"
              :selected="newPermission.meterCountMethod"
              :options="meterCountMethods"
              label-key="label"
              value-key="value"
              @selected="(method) => newPermission.meterCountMethod = method"
            />
          </div>
        </div>
      </div>
    </div>

    <div class="pt-5 mt-5">
      <div class="flex justify-end">
        <button class="btn">
          {{ editingPermission ? 'Edit' : 'Create' }} Permission
        </button>
      </div>
    </div>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import { Form, Field } from 'vee-validate';
import PluttoDropdown from '@/components/plutto-dropdown';

export default {
  components: { Form, Field, PluttoDropdown },
  props: {
    editingPermission: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      newPermission: {},
      schema: {
        name: 'required',
      },
      meterCountMethods: [
        { value: 'period_sum', label: 'the last period information' },
        { value: 'history_sum', label: 'the historic information' },
      ],
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_METERS');
    if (this.editingPermission) this.newPermission = { ...this.editingPermission };
  },
  computed: {
    ...mapState({
      meters: state => state.meters.meters,
    }),
  },
  methods: {
    createPermission() {
      this.$store.dispatch('CREATE_PERMISSION', this.newPermission)
        .then((permission) => this.$emit('created-permission', permission));
    },
    updatePermission() {
      this.$store.dispatch('UPDATE_PERMISSION', this.newPermission)
        .then((permission) => this.$emit('edited-permission', permission));
    },
  },
};
</script>

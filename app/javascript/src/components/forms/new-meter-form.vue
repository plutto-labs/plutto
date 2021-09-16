<template>
  <Form
    @submit="editingMeter ? updateMeter() : createMeter()"
    class="max-w-xl p-4 mx-auto space-y-5 bg-gray-800 rounded-lg"
    :validation-schema="schema"
    v-slot="{ errors }"
  >
    <div class="space-y-6 sm:space-y-5">
      <div class="space-y-6 sm:space-y-5">
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="first-name"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Name
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="name"
              id="name"
              autocomplete="name"
              v-model="newMeter.name"
            />
            <span
              class="absolute text-sm text-danger-light"
              v-if="errors.name"
            >
              Required
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="pt-5 mt-5">
      <div class="flex justify-end">
        <button class="btn">
          {{ editingMeter ? 'Edit' : 'Create' }} Meter
        </button>
      </div>
    </div>
  </Form>
</template>

<script>
import { Form, Field } from 'vee-validate';

export default {
  components: { Form, Field },
  props: {
    editingMeter: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      newMeter: {},
      schema: {
        name: 'required',
      },
    };
  },
  beforeMount() {
    if (this.editingMeter) this.newMeter = { ...this.editingMeter };
  },
  methods: {
    createMeter() {
      this.$store.dispatch('CREATE_METER', this.newMeter)
        .then((meter) => this.$emit('created-meter', meter));
    },
    updateMeter() {
      this.$store.dispatch('UPDATE_METER', this.newMeter)
        .then((meter) => this.$emit('edited-meter', meter));
    },
  },
};
</script>

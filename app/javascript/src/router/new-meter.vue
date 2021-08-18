<template>
  <main>
    <PluttoHeader
      title="New Meter"
    />
    <div class="px-6 mt-6">
      <Form
        @submit="createMeter"
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
              <div class="mt-1 sm:mt-0 sm:col-span-2">
                <Field
                  class="block w-full max-w-lg bg-gray-700 border-gray-500 rounded-md text-gray-50 focus:ring-0 focus:border-primary sm:max-w-xs sm:text-sm"
                  type="text"
                  name="name"
                  id="name"
                  autocomplete="name"
                  v-model="newMeter.name"
                />
                <span class="absolute text-sm text-danger-light">{{ errors.name }}</span>
              </div>
            </div>
          </div>
          <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:pt-5">
            <label
              for="meter-type"
              class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
            >
              Type
            </label>
            <div class="mt-1 sm:mt-0 sm:col-span-2">
              <Field
                class="block w-full max-w-lg bg-gray-700 border-gray-500 rounded-md text-gray-50 focus:ring-0 focus:border-primary sm:max-w-xs sm:text-sm"
                name="type"
                autocomplete="meter-type"
                as="select"
                v-model="newMeter.meterType"
              >
                <option
                  v-for="(type, index) in meterTypes"
                  :key="index"
                  :value="decamelizeString(type)"
                >
                  {{ $t(`message.meters.types.${type}`) }}
                </option>
              </Field>
              <span class="absolute text-sm text-danger-light">{{ errors.type }}</span>
            </div>
          </div>
        </div>

        <div class="pt-5 mt-5">
          <div class="flex justify-end">
            <button class="btn">
              Save
            </button>
          </div>
        </div>
      </form>
    </div>
  </main>
</template>

<script>
import { decamelize } from 'humps';
import { Form, Field } from 'vee-validate';
import PluttoHeader from '../components/plutto-header';

export default {
  components: { PluttoHeader, Form, Field },
  data() {
    return {
      newMeter: {},
      meterTypes: ['periodSum', 'historySum'],
      schema: {
        name: 'required',
        type: 'required',
      },
    };
  },
  methods: {
    createMeter() {
      this.$store.dispatch('CREATE_METER', this.newMeter)
        .then(() => this.$router.go(-1));
    },
    decamelizeString(string) {
      return decamelize(string);
    },
  },
};
</script>

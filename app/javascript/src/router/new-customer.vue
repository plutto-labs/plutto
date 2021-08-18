<template>
  <main>
    <PluttoHeader
      title="New Customer"
    />
    <div class="px-6 mt-6">
      <Form
        @submit="createCustomer"
        :validation-schema="schema"
        v-slot="{ errors }"
        class="max-w-xl p-4 mx-auto space-y-5 bg-gray-800 rounded-lg"
      >
        <div class="space-y-6 sm:space-y-5">
          <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
            <label
              for="name"
              class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
            >
              Name
            </label>
            <div class="mt-1 sm:mt-0 sm:col-span-2">
              <Field
                class="block w-full max-w-lg bg-gray-700 border-gray-500 rounded-md text-gray-50 focus:ring-0 focus:border-primary sm:max-w-xs sm:text-sm"
                type="text"
                name="name"
                autocomplete="name"
                v-model="newCustomer.name"
              />
              <span class="absolute text-sm text-danger-light">{{ errors.name }}</span>
            </div>
          </div>
          <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
            <label
              for="email"
              class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
            >
              Email
            </label>
            <div class="mt-1 sm:mt-0 sm:col-span-2">
              <Field
                class="block w-full max-w-lg bg-gray-700 border-gray-500 rounded-md text-gray-50 focus:ring-0 focus:border-primary sm:max-w-xs sm:text-sm"
                type="text"
                name="email"
                autocomplete="email"
                v-model="newCustomer.email"
              />
              <span class="absolute text-sm text-danger-light">{{ errors.email }}</span>
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
      </Form>
    </div>
  </main>
</template>

<script>
import PluttoHeader from '@/components/plutto-header';
import { Form, Field } from 'vee-validate';

export default {
  components: { PluttoHeader, Form, Field },
  data() {
    return {
      newCustomer: {},
      schema: {
        name: 'required',
        email: 'required|email',
      },
    };
  },
  methods: {
    createCustomer() {
      this.$store.dispatch('CREATE_CUSTOMER', this.newCustomer)
        .then(() => this.$router.go(-1));
    },
  },
};
</script>

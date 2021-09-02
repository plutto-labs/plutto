<template>
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
        <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
          <Field
            class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
            type="text"
            name="name"
            autocomplete="name"
            v-model="newCustomer.name"
          />
          <span
            class="absolute text-sm text-danger-light"
            v-if="errors.name"
          >
            Required
          </span>
        </div>
      </div>
      <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
        <label
          for="email"
          class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
        >
          Email
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
          <Field
            class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
            type="text"
            name="email"
            autocomplete="email"
            v-model="newCustomer.email"
          />
          <span
            class="absolute text-sm text-danger-light"
            v-if="errors.email"
          >
            Mail is not valid
          </span>
        </div>
      </div>
    </div>
    <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
      <label
        for="email"
        class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
      >
        Plan
      </label>
      <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
        <PluttoDropdown
          :selected="newCustomer.planVersionId"
          :options="planVersionsOptions"
          label-key="name"
          value-key="id"
          @selected="selectPlanVersion"
        />
      </div>
    </div>

    <div class="pt-5 mt-5">
      <div class="flex justify-end">
        <button class="btn">
          Create Customer
        </button>
      </div>
    </div>
  </Form>
</template>

<script>
import PluttoDropdown from '@/components/plutto-dropdown';
import { Form, Field } from 'vee-validate';

export default {
  components: { PluttoDropdown, Form, Field },
  data() {
    return {
      newCustomer: {
        planVersionId: null,
      },
      schema: {
        name: 'required',
        email: 'required|email',
      },
    };
  },
  methods: {
    createCustomer() {
      this.$store.dispatch('CREATE_CUSTOMER', this.newCustomer)
        .then((customer) => this.$emit('created-customer', customer));
    },
    selectPlanVersion(planVersionId) {
      this.newCustomer.planVersionId = planVersionId;
    },
  },
  computed: {
    planVersionsOptions() {
      return this.$store.getters.planVersionsOptions;
    },
    displaySelectedPlan() {
      if (!this.newCustomer.planVersionId) return 'Choose';

      return this.planOptions.find(plan => plan.value === this.newCustomer.planVersionId).label;
    },
  },
};
</script>

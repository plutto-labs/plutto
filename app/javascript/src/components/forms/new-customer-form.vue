<template>
  <Form
    @submit="createCustomer"
    :validation-schema="schema"
    v-slot="{ errors }"
    class="max-w-xl p-4 mx-auto space-y-5 overflow-auto bg-gray-800 rounded-lg"
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
      <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
        <label
          for="identifier"
          class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
        >
          Identifier
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
          <Field
            class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
            type="text"
            name="identifier"
            autocomplete="identifier"
            v-model="newCustomer.identifier"
          />
        </div>
      </div>
      <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
        <label
          for="countryIsoCode"
          class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
        >
          Country
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
          <Field
            class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
            type="text"
            name="countryIsoCode"
            autocomplete="country-iso-code"
            v-model="newCustomer.billingInformation.countryIsoCode"
          />
          <span
            class="absolute text-sm text-danger-light"
            v-if="errors.countryIsoCode"
          >
            Required
          </span>
        </div>
      </div>
      <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
        <label
          for="plan"
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
      <button
        @click="toggleShow"
        @click.prevent
        class="mt-1 text-sm font-medium text-white-50 sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start"
      >
        <span
          v-if="!showBillingInformation"
          class="inline-flex items-center"
        >
          <div class="p-2 m-2 bg-gray-700 rounded-full">
            <ChevronRightIcon
              class="w-5 h-5"
              aria-hidden="true"
            />
          </div>
          Billing info
        </span>
        <span
          v-else
          class="inline-flex items-center "
        >
          <div class="p-2 m-2 bg-gray-700 rounded-full">
            <ChevronUpIcon
              class="w-5 h-5"
              aria-hidden="true"
            />
          </div>
          Billing info
        </span>
      </button>
      <div v-if="showBillingInformation">
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="tax-id"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Tax Id
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="tax-id"
              autocomplete="tax-id"
              v-model="newCustomer.billingInformation.taxId"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="legal-name"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Legal Name
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="legal-name"
              autocomplete="legal-name"
              v-model="newCustomer.billingInformation.legalName"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="city"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            City
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="city"
              autocomplete="city"
              v-model="newCustomer.billingInformation.city"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="state"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            State
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="state"
              autocomplete="state"
              v-model="newCustomer.billingInformation.state"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="address"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Street
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="address"
              autocomplete="address"
              v-model="newCustomer.billingInformation.address"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="zip"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Zip
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="zip"
              autocomplete="zip"
              v-model="newCustomer.billingInformation.zip"
            />
          </div>
        </div>
        <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-gray-500 sm:pt-5">
          <label
            for="phone"
            class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
          >
            Phone
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2 plutto-input">
            <Field
              class="block bg-gray-700 border-gray-500 plutto-input__input text-gray-50 sm:max-w-xs sm:text-sm"
              type="text"
              name="phone"
              autocomplete="phone"
              v-model="newCustomer.billingInformation.phone"
            />
          </div>
        </div>
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
import { ChevronRightIcon, ChevronUpIcon } from '@heroicons/vue/solid';

export default {
  components: { PluttoDropdown, Form, Field, ChevronRightIcon, ChevronUpIcon },
  data() {
    return {
      showBillingInformation: false,
      newCustomer: {
        planVersionId: null,
        identifier: null,
        email: null,
        name: null,
        billingInformation: {
          legalName: null,
          address: null,
          city: null,
          state: null,
          zip: null,
          countryIsoCode: null,
          taxId: null,
          phone: null,
        },
      },
      schema: {
        email: 'required|email',
        countryIsoCode: 'required',
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
    toggleShow() {
      this.showBillingInformation = !this.showBillingInformation;
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

<template>
  <Form
    class="w-full px-8"
    @submit="createSubscription"
    v-slot="{ errors }"
    :validation-schema="schema"
    :disabled="true"
  >
    <h1 class="text-xl">
      {{ `${this.presentSubscription ? 'Current' : 'New'} Subscription` }}
    </h1>
    <div class="flex mt-4">
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block mb-4 text-sm font-medium text-gray-800"
        >
          Bill when periods:
        </label>
        <PluttoRadioInput
          input-id="billsAt"
          :options="['start', 'end']"
          v-model="subscription.billsAt"
          :disabled="this.presentSubscription"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.billsAt"
        >
          Required
        </div>
      </div>
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block text-sm font-medium text-gray-800"
        >
          Bill every:
        </label>
        <PluttoDropdown
          dropdown-id="billingPeriodDuration"
          class="w-32 mt-4 plutto-input"
          :options="billingPeriodDurations"
          :selected="subscription.billingPeriodDuration"
          @selected="(bpd) => subscription.billingPeriodDuration = bpd"
          label-key="label"
          value-key="value"
          :disabled="this.presentSubscription"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.billingPeriodDuration"
        >
          Required
        </div>
      </div>
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block text-sm font-medium text-gray-800"
        >
          Trial until:
        </label>
        <DatePicker
          v-model="subscription.trialFinishesAt"
          :model-config="modelConfig"
          :attributes="attrs"
          :min-date="new Date()"
          :popover="{ visibility: 'focus' }"
          :transition="'none'"
          class="my-4"
          :disabled-dates="this.presentSubscription ? { weekdays: [1, 2, 3, 4, 5, 6, 7] } : { weekdays: [] }"
        >
          <template #default="{ inputValue, inputEvents }">
            <div class="plutto-input">
              <input
                class="bg-gray-200 border-gray-400 plutto-input__input"
                :value="inputValue"
                v-on="inputEvents"
              >
            </div>
          </template>
        </DatePicker>
      </div>
    </div>
    <div class="flex items-center justify-between my-8">
      <span class="flex-1">Select permissionGroup:<br><span class="text-xs text-gray-600">(optional)</span></span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        :options="parsedPermissionGroups"
        value-key="id"
        :selected="subscription.permissionGroupId"
        @selected="(permissionGroupId) => subscription.permissionGroupId = permissionGroupId"
        :disabled="this.presentSubscription"
      />
    </div>
    <div class="flex items-center justify-between my-8">
      <span class="flex-1">Add products:<br><span class="text-xs text-gray-600">(0 or more)</span></span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        force-selected-text="Choose..."
        :options="products"
        value-key="id"
        label-key="name"
        @selected="(productId) => selectProduct(productId)"
        :disabled="this.presentSubscription"
      />
    </div>
    <div class="grid grid-cols-3 gap-4 mt-4">
      <div
        v-for="(product) in Object.values(selectedProducts)"
        :key="product"
        class="relative p-4 border border-gray-500 rounded group"
      >
        <div
          class="absolute top-0 right-0 -mt-3 -mr-2 text-xl opacity-0 cursor-pointer plutto-icon group-hover:opacity-100"
          v-if="!this.presentSubscription"
          @click="removeProduct(product.id)"
        >
          cancel
        </div>
        <div
          v-if="product"
          class="flex flex-col"
        >
          <div class="flex items-center justify-between">
            <div>
              {{ product.name }}
            </div>
            <PluttoTooltip
              v-if="meteredPricingError(product, selectedPricings[product.id])"
              :background="'danger'"
            >
              <template #trigger>
                <span
                  class="-my-1 text-lg cursor-pointer text-danger-light plutto-icon"
                >
                  error
                </span>
              </template>
              <template #content>
                <p class="w-24 text-xs text-gray-100">
                  Metered pricing is not allowed when period bills at start
                </p>
              </template>
            </PluttoTooltip>
          </div>
          <PluttoDropdown
            class="w-full mt-2 plutto-input"
            selected="Pricing..."
            :options="pricingOptions(product)"
            @selected="(pricingId) => selectedPricings[product.id] = pricingId"
            :disabled="this.presentSubscription"
          />
        </div>
      </div>
    </div>
    <div class="flex justify-around w-full h-full my-8">
      <button
        class="mt-auto btn btn--cancel"
        v-if="this.presentSubscription"
        @click.prevent="endSubscription"
      >
        Cancel subscription
      </button>
      <button
        class="mt-auto btn"
        v-else
      >
        Create subscription
      </button>
    </div>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import { DatePicker } from 'v-calendar';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoRadioInput from '@/components/plutto-radio-input';
import PluttoTooltip from '@/components/plutto-tooltip';
import { Form } from 'vee-validate';

export default {
  components: { PluttoDropdown, PluttoRadioInput, DatePicker, PluttoTooltip, Form },
  props: {
    currentSubscription: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      selectedProducts: {},
      selectedPricings: {},
      pricingErrors: {},
      subscription: {
        pricingIds: [],
        billingPeriodDuration: null,
        billsAt: null,
        trialFinishesAt: null,
        permissionGroupId: null,
      },
      billingPeriodDurations: [
        { label: 'day', value: 'P1D' },
        { label: 'week', value: 'P1W' },
        { label: 'month', value: 'P1M' },
        { label: '3 months', value: 'P3M' },
        { label: '6 months', value: 'P6M' },
        { label: 'year', value: 'P1Y' },
      ],
      modelConfig: {
        type: 'string',
        mask: 'YYYY-MM-DD',
      },
      attrs: [
        {
          key: 'today',
          highlight: {
            color: 'purple',
            fillMode: 'outline',
          },
          dates: new Date(),
        },
      ],
      schema: {
        billsAt: 'required',
        billingPeriodDuration: 'required',
      },
    };
  },
  async beforeCreate() {
    await Promise.all([
      this.$store.dispatch('GET_PRODUCTS'),
      this.$store.dispatch('GET_PERMISSION_GROUPS'),
    ]);
    if (this.presentSubscription) {
      this.subscription.billsAt = this.currentSubscription.billsAt;
      this.subscription.billingPeriodDuration = this.currentSubscription.billingPeriodDuration;
      this.subscription.trialFinishesAt = this.currentSubscription.trialFinishesAt;
      this.subscription.permissionGroupId = this.currentSubscription.permissionGroup?.id;
      this.currentSubscription.pricings.forEach((pricing) => {
        this.selectedProducts[pricing.productId] = this.findProduct(pricing.productId);
        this.selectedPricings[pricing.productId] = pricing.id;
      });
    }
  },
  computed: {
    ...mapState({
      loading: state => state.products.loading,
      products: state => state.products.products,
      permissionGroups: state => state.permissionGroups.permissionGroups,
      currentCustomer: state => state.customers.currentCustomer,
      globalError: state => state.ui.error,
    }),
    parsedError() {
      return this.globalError?.response?.data?.error;
    },
    parsedPermissionGroups() {
      return this.permissionGroups.map(pg => ({
        ...pg,
        name: `${pg.name} [${pg.currency}]`,
      }));
    },
    presentSubscription() {
      if (this.currentSubscription) return true;

      return false;
    },
  },
  methods: {
    selectProduct(productId) {
      const product = this.findProduct(productId);
      if (product) this.selectedProducts[productId] = product;
    },
    findProduct(productId) {
      return this.products.find(
        (product) => product.id === productId,
      );
    },
    findPricing(pricings, pricingId) {
      return pricings.find(
        (pricing) => pricing.id === pricingId,
      );
    },
    pricingOptions(product) {
      return product.pricings.map(
        pricing => ({ value: pricing.id, name: `${pricing.name} [${pricing.currency}]` }),
      );
    },
    async createSubscription() {
      this.subscription.pricingIds = Object.values(this.selectedPricings);
      await this.$store.dispatch('CREATE_SUBSCRIPTION', { ...this.subscription, customerId: this.currentCustomer.id });

      if (this.parsedError === undefined) {
        this.$emit('created-subscription');
      }
    },
    async endSubscription() {
      await this.$store.dispatch('END_SUBSCRIPTION', { id: this.currentSubscription.id });

      if (this.parsedError === undefined) {
        this.$emit('created-subscription');
      }
    },
    removeProduct(productId) {
      delete this.selectedProducts[productId];
      delete this.selectedPricings[productId];
    },
    meteredPricingError(product, pricingId) {
      if (this.subscription.billsAt !== 'start') {
        this.pricingErrors[product.id] = false;

        return false;
      }

      this.pricingErrors[product.id] = this.findPricing(
        product.pricings, pricingId,
      )?.priceLogics.map(priceLogic => priceLogic.metered).includes(true);

      return this.pricingErrors[product.id];
    },
  },
};
</script>

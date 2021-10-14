<template>
  <div class="w-full px-8">
    <h1 class="text-xl">
      New Subscription
    </h1>
    <div class="flex mt-4">
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block mb-2 text-sm font-medium text-gray-100"
        >
          Bill when periods:
        </label>
        <PluttoRadioInput
          input-id="billsAt"
          :options="['start', 'end']"
          v-model="subscription.billsAt"
        />
      </div>
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block text-sm font-medium text-gray-100"
        >
          Bill every:
        </label>
        <PluttoDropdown
          class="my-4 plutto-input"
          :options="billingPeriodDurations"
          :selected="subscription.billingPeriodDuration"
          @selected="(bpd) => subscription.billingPeriodDuration = bpd"
          label-key="label"
          value-key="value"
        />
      </div>
      <div class="mr-8 w-50">
        <label
          for="bills_at"
          class="block text-sm font-medium text-gray-100"
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
        >
          <template #default="{ inputValue, inputEvents }">
            <div class="plutto-input">
              <input
                class="bg-gray-700 border-gray-500 plutto-input__input"
                :value="inputValue"
                v-on="inputEvents"
              >
            </div>
          </template>
        </DatePicker>
      </div>
    </div>
    <div class="flex items-center justify-between my-8">
      <span class="flex-1">Select Plan:<br><span class="text-xs text-gray-300">(optional)</span></span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        :options="plans"
        value-key="id"
        :selected="subscription.planId"
        @selected="(planId) => subscription.planId = planId"
      />
    </div>
    <div class="flex items-center justify-between my-8">
      <span class="flex-1">Add products:<br><span class="text-xs text-gray-300">(0 or more)</span></span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        force-selected-text="Choose..."
        :options="products"
        value-key="id"
        label-key="name"
        @selected="(productId) => selectProduct(productId)"
      />
    </div>
    <div class="grid grid-cols-3 gap-4 mt-4">
      <div
        v-for="(product) in Object.values(selectedProducts)"
        :key="product"
        class="relative p-4 border border-gray-400 rounded group"
      >
        <div
          class="absolute top-0 right-0 -mt-3 -mr-2 text-xl opacity-0 cursor-pointer plutto-icon group-hover:opacity-100"
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
              v-if="meteredPricingError(product, selectedPricings[productId])"
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
                <p class="w-24 text-xs text-gray-800">
                  Metered pricing is not allowed when period bills at start
                </p>
              </template>
            </PluttoTooltip>
          </div>
          <PluttoDropdown
            class="w-full mt-2 plutto-input"
            selected="Pricing..."
            :options="pricingOptions(product)"
            @selected="(pricingId) => selectedPricings[productId] = pricingId"
          />
        </div>
      </div>
    </div>
    <div class="flex justify-around w-full h-full my-8">
      <button
        class="mt-auto btn"
        @click="createSubscription"
      >
        Create subscription
      </button>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import { DatePicker } from 'v-calendar';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoRadioInput from '@/components/plutto-radio-input';
import PluttoTooltip from '@/components/plutto-tooltip';

export default {
  components: { PluttoDropdown, PluttoRadioInput, DatePicker, PluttoTooltip },
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
        planId: null,
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
    };
  },
  async mounted() {
    await this.$store.dispatch('GET_PRODUCTS');
  },
  computed: {
    ...mapState({
      loading: state => state.products.loading,
      products: state => state.products.products,
      plans: state => state.plans.plans,
      currentCustomer: state => state.customers.currentCustomer,
    }),
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
    createSubscription() {
      this.subscription.pricingIds = Object.values(this.selectedPricings);
      this.$store.dispatch('CREATE_SUBSCRIPTION', { ...this.subscription, customerId: this.currentCustomer.id })
        .then(this.$emit('created-subscription'));
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

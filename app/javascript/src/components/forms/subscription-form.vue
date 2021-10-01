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
    <div class="items-center inline gap-4">
      <span>Add products:</span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        force-selected-text="Choose..."
        :options="productOptions"
        @selected="(productId) => selectProduct(productId)"
      />
    </div>
    <div class="grid grid-cols-3 gap-4 mt-4">
      <div
        v-for="(productId) in selectedProducts"
        :key="productId"
        class="p-4 border border-gray-400 rounded"
      >
        <div class="flex flex-col w-32">
          <div>
            {{ findProduct(productId).name }}
          </div>
          <PluttoDropdown
            class="w-full mt-2 plutto-input"
            selected="Pricing..."
            :options="pricingOptions(productId)"
            @selected="(pricingId) => this.subscription.pricingIds = [...this.subscription.pricingIds, pricingId]"
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

export default {
  components: { PluttoDropdown, PluttoRadioInput, DatePicker },
  data() {
    return {
      selectedProducts: [],
      subscription: {
        pricingIds: [],
        billingPeriodDuration: null,
        billsAt: null,
        trialFinishesAt: null,
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
      currentCustomer: state => state.customers.currentCustomer,
    }),
    productOptions() {
      return this.products.map(product => ({ value: product.id, name: product.name }));
    },
  },
  methods: {
    selectProduct(productId) {
      if (!this.selectedProducts.includes(productId)) this.selectedProducts = [...this.selectedProducts, productId];
    },
    findProduct(productId) {
      return this.products.find(
        (product) => product.id === productId,
      );
    },
    pricingOptions(productId) {
      return this.findProduct(productId).pricings.map(
        pricing => ({ value: pricing.id, name: `${pricing.name} [${pricing.currency}]` }),
      );
    },
    createSubscription() {
      this.$store.dispatch('CREATE_SUBSCRIPTION', { ...this.subscription, customerId: this.currentCustomer.id })
        .then(this.$emit('created-subscription'));
    },
  },
};
</script>

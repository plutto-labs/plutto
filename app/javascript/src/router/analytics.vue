<template>
  <main class="mt-2 overflow-auto">
    <div
      v-if="!loading"
      class="grid grid-cols-2 gap-4"
    >
      <line-chart
        :datasets="{ subscriptions }"
        title="Active subscriptions per month"
        label="Subscriptions"
        class="p-3 rounded-md bg-gray-50"
      />
      <div class="grid grid-cols-2 gap-4">
        <div class="flex flex-col h-full p-5 rounded-md bg-gray-50">
          <div class="relative flex items-center justify-center">
            <div
              class="text-lg font-medium text-skyblue"
            >
              Customer Churn Rate
            </div>
            <PluttoTooltip>
              <template #trigger>
                <span
                  class="absolute top-0 ml-2 text-sm text-gray-400 cursor-pointer plutto-icon"
                >
                  info
                </span>
              </template>
              <template #content>
                <span
                  class="text-xs"
                >
                  The rate at which your customers are canceling their subscriptions
                </span>
              </template>
            </PluttoTooltip>
          </div>
          <div class="flex items-center justify-around ">
            <p class="text-xs text-gray-9000">
              for {{ numbersMonth }}
            </p>
          </div>
          <div
            class="flex items-center justify-around h-full text-3xl"
            :class="churnRate >= 0 ? 'text-aquagreen-800' : 'text-melon-800'"
          >
            {{ churnRate.toFixed(3) }}%
          </div>
        </div>
        <div class="flex flex-col h-full p-5 rounded bg-gray-50">
          <div class="flex items-center justify-around">
            <div>
              Currency
            </div>
          </div>
          <div class="flex items-center h-full">
            <PluttoDropdown
              :selected="selectedCurrency"
              :options="CURRENCY_KEYS"
              label-key="label"
              value-key="value"
              @selected="(currency) => updateCurrency(currency)"
            />
          </div>
        </div>
        <div class="flex flex-col h-full p-5 text-center rounded-md bg-gray-50">
          <div class="flex items-center justify-around text-lg font-medium text-skyblue">
            MRR
          </div>
          <div class="flex items-center justify-around ">
            <p class="text-xs text-gray-9000">
              for {{ numbersMonth }}
            </p>
          </div>
          <div
            class="flex items-center justify-around h-full text-3xl align-middle"
            :class="mrrRate >= 0 ? 'text-aquagreen-800' : 'text-melon-800'"
          >
            <div>
              <span
                v-if="mrrRate >= 0"
                class="inline mr-2 align-middle plutto-icon"
              >arrow_upward</span>
              <span
                v-else
                class="inline mr-2 align-middle plutto-icon"
              >arrow_downward</span>
              <p class="inline align-middle">
                {{ formatCurrency(formatCents(mrrVal, selectedCurrency), selectedCurrency) }}
              </p>
            </div>
          </div>
        </div>
        <div class="flex flex-col h-full p-5 text-center rounded-md bg-gray-50">
          <div class="flex items-center justify-around text-lg font-medium text-skyblue">
            ARR
          </div>
          <div class="flex items-center justify-around ">
            <p class="text-xs text-gray-9000">
              for {{ numbersMonth }}
            </p>
          </div>
          <div
            class="flex items-center justify-around h-full text-3xl align-middle"
            :class="arrRate >= 0 ? 'text-aquagreen-800' : 'text-melon-800'"
          >
            <div>
              <span
                v-if="arrRate >= 0"
                class="inline mr-2 align-middle plutto-icon"
              >arrow_upward</span>
              <span
                v-else
                class="inline mr-2 align-middle plutto-icon"
              >arrow_downward</span>
              <p class="inline align-middle">
                {{ formatCurrency(formatCents(arrVal, selectedCurrency), selectedCurrency) }}
              </p>
            </div>
          </div>
        </div>
      </div>
      <bar-chart
        :datasets="mrr"
        title="Monthly Recurring Revenue"
        label="MRR"
        class="p-3 rounded-md bg-gray-50"
      />
      <line-chart
        :datasets="{ arr }"
        title="Annualized Run Rate"
        label="ARR"
        class="p-3 rounded-md bg-gray-50"
      />
      <line-chart
        :datasets="{ customers }"
        title="Customers created per month"
        label="Customers"
        class="p-3 rounded-md bg-gray-50"
      />
    </div>
    <PluttoLoader
      class="mt-8"
      v-else
    />
  </main>
</template>

<script>

import { mapState } from 'vuex';
import LineChart from '@/components/charts/line-chart';
import BarChart from '@/components/charts/bar-chart.vue';
import PluttoLoader from '@/components/plutto-loader';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoTooltip from '@/components/plutto-tooltip';

export default {
  components: { LineChart, PluttoLoader, BarChart, PluttoDropdown, PluttoTooltip },

  data() {
    return {
      loading: true,
      selectedCurrency: 'USD',
    };
  },
  async beforeMount() {
    await Promise.all([
      this.$store.dispatch('GET_CUSTOMERS_ANALYTICS'),
      this.$store.dispatch('GET_NUMBERS_ANALYTICS'),
      this.fetchCurrencyData(),
    ]);
    this.loading = false;
  },

  computed: {
    ...mapState({
      customers: state => state.analytics.customers,
      numbers: state => state.analytics.numbers,
      subscriptions: state => state.analytics.subscriptions,
      mrr: state => state.analytics.mrr,
      arr: state => state.analytics.arr,
    }),
    churnRate() {
      return this.numbers.churnRate;
    },
    /* eslint-disable no-magic-numbers */
    arrVal() { return this.arrValue(10); },
    arrRate() { return this.arrValue() * 100 / this.arrValue(this.monthKey(10)) || 0; },
    mrrVal() { return this.arrValue(10) / 12; },
    mrrRate() { return this.arrRate / 12 || 0; },
    numbersMonth() {
      return this.monthKey(10);
    },
    /* eslint-enable no-magic-numbers */
  },

  methods: {
    async fetchCurrencyData() {
      await this.$store.dispatch('GET_SUBSCRIPTIONS_ANALYTICS', { currency: this.selectedCurrency });
      await this.$store.dispatch('GET_MRR_ARR_ANALYTICS', { currency: this.selectedCurrency });
    },

    updateCurrency(currency) {
      this.selectedCurrency = currency;
      this.fetchCurrencyData();
    },
    arrValue(key = 1) {
      if (!this.arr) {
        return 0;
      }

      return this.arr[this.monthKey(key)] || 0;
    },
    monthKey(n) {
      return Object.keys(this.arr)[n];
    },
  },
};
</script>

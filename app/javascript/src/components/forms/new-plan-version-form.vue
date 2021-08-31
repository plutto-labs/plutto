<template>
  <Form
    @submit="submit"
    class="w-full space-y-8 divide-y divide-gray-200 md:max-w-xl"
  >
    <div class="m-auto divide-gray-200">
      <template v-if="createPlan">
        <div class="mt-8 mb-4 text-lg">
          Plan information
        </div>
        <div class="flex">
          <div class="w-full">
            <label
              for="name"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.name') }}
            </label>
            <div class="mt-2 plutto-input">
              <span class="plutto-input__icon">science</span>
              <input
                type="text"
                name="name"
                id="name"
                v-model="newPlan.name"
                required
                class="plutto-input__input"
              >
            </div>
          </div>
        </div>
        <div class="flex mt-4">
          <div class="w-32 mr-8">
            <label
              for="currency"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.currency') }}
            </label>
            <PluttoDropdown
              class="mt-2 plutto-input"
              :selected="newPlan.currency"
              :options="CURRENCY_KEYS"
              @selected="(currency) => newPlan.currency = currency"
            />
          </div>
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
              v-model="newPlan.billsAt"
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
              class="mt-2 plutto-input"
              :options="billingPeriodDurations"
              :selected="newPlan.billingPeriodDuration"
              @selected="(bpd) => newPlan.billingPeriodDuration = bpd"
              label-key="label"
              value-key="value"
            />
          </div>
        </div>
      </template>
      <div class="sm:col-span-3">
        <div class="mt-8 mb-4 text-lg">
          Price Logics
        </div>
        <PriceLogics
          v-model="priceLogics"
          :allow-metered="newPlan.billsAt === 'end'"
        />
      </div>
    </div>
    <div class="pt-5">
      <div class="flex justify-end">
        <button
          class="btn"
          :disabled="!canCreatePlan"
        >
          {{ createPlan ? 'Create plan' : 'Create plan Version' }}
        </button>
      </div>
    </div>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import PriceLogics from '@/components/price-logics';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoRadioInput from '@/components/plutto-radio-input';
import { Form } from 'vee-validate';

export default {
  components: { PriceLogics, Form, PluttoDropdown, PluttoRadioInput },
  props: {
    createPlan: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      newPlan: {
        currency: 'USD',
        billsAt: 'end',
      },
      priceLogics: [],
      billingPeriodDurations: [
        { label: 'day', value: 'P1D' },
        { label: 'week', value: 'P1W' },
        { label: 'month', value: 'P1M' },
        { label: '3 months', value: 'P3M' },
        { label: '6 months', value: 'P6M' },
        { label: 'year', value: 'P1Y' },
      ],
    };
  },
  beforeMount() {
    if (!this.createPlan && this.currentPlan.defaultVersion) {
      this.priceLogics = this.currentPlan.defaultVersion.priceLogics;
    }
  },
  methods: {
    submit() {
      if (this.createPlan) {
        this.$store.dispatch('CREATE_PLAN', { plan: this.newPlan, planVersion: this.planVersion })
          .then((plan) => this.$emit('created-plan', plan));
      } else {
        this.$store.dispatch('CREATE_PLAN_VERSION', { planId: this.currentPlan.id, planVersion: this.planVersion })
          .then((planVersion) => this.$emit('created-plan-version', planVersion));
      }
    },
  },
  computed: {
    ...mapState({
      currentPlan: state => state.plans.currentPlan,
    }),
    priceLogicsValid() {
      return this.priceLogics.every((pl) => (!pl.metered || pl.meterId) && (!pl.tierable || pl.tiers));
    },
    canCreatePlan() {
      return this.priceLogics.length > 0 && this.priceLogicsValid &&
        (!this.createPlan || (this.newPlan.name && this.newPlan.billingPeriodDuration));
    },
    planVersion() {
      return {
        priceLogicsAttributes: this.priceLogics.map(pl => {
          const priceLogic = Object.assign({}, { price: pl.price, type: pl.type, meterId: pl.meterId });
          if (pl.tiers && pl.tierable) {
            const tiers = pl.tiers.map((tier, index) => (
              Object.assign({}, { index, upperLimit: tier.upperLimit, price: tier.price })
            ));
            priceLogic.tiersAttributes = tiers;
          }

          return priceLogic;
        }),
      };
    },
  },
};
</script>

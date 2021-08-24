<template>
  <main>
    <PluttoHeader
      :title="createPlan ? 'New Plan' : 'New plan version'"
    />
    <div class="flex justify-center px-6 mt-6">
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
              <div class="w-32 ml-4">
                <label
                  for="name"
                  class="block text-sm font-medium text-gray-100"
                >
                  {{ $t('message.global.currency') }}
                </label>
                <PluttoDropdown
                  class="mt-2 plutto-input"
                  :selected="newPlan.currency"
                  :options="[{ label: 'USD', value: 'USD' }, { label: 'CLP', value: 'CLP' }]"
                  @selected="(currency) => newPlan.currency = currency"
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
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PriceLogics from '@/components/price-logics';
import PluttoHeader from '@/components/plutto-header';
import PluttoDropdown from '@/components/plutto-dropdown';
import { Form } from 'vee-validate';

export default {
  components: { PluttoHeader, PriceLogics, Form, PluttoDropdown },
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
      },
      priceLogics: [],
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
          .then(() => this.$router.go(-1));
      } else {
        this.$store.dispatch('CREATE_PLAN_VERSION', { planId: this.$route.params.id, planVersion: this.planVersion })
          .then(() => this.$router.go(-1));
      }
    },
  },
  computed: {
    ...mapState({
      currentPlan: state => state.plans.currentPlan,
    }),
    canCreatePlan() {
      return this.priceLogics.length > 0 && (!this.createPlan || this.newPlan.name);
    },
    planVersion() {
      return {
        priceLogicsAttributes: this.priceLogics.map(pl => {
          const priceLogic = Object.assign({}, { price: pl.price, type: pl.type });
          if (pl.tiers) {
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

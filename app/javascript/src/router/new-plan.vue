<template>
  <main>
    <PluttoHeader
      title="New Plan"
    />
    <div class="flex justify-center px-6 mt-6">
      <form
        @submit.prevent="createPlan"
        class="w-full space-y-8 divide-y divide-gray-200 md:max-w-xl"
      >
        <div class="m-auto divide-gray-200">
          <div class="mt-8 mb-4 text-lg">
            Plan information
          </div>
          <div class="sm:col-span-3">
            <label
              for="name"
              class="block text-sm font-medium text-gray-100"
            >
              Name
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
          <div class="sm:col-span-3">
            <div class="mt-8 mb-4 text-lg">
              Price Logics
            </div>
            <PriceLogics
              v-model="priceLogics"
            />
            <div class="flex justify-center w-full">
              <button
                class="relative flex items-center justify-center w-full py-8 text-gray-300 border border-gray-700 border-dashed"
                @click.prevent="addPriceLogic"
              >
                <span class="mr-2 plutto-icon">add</span>
                Add Price Logic
              </button>
            </div>
          </div>
        </div>

        <div class="pt-5">
          <div class="flex justify-end">
            <button
              class="btn"
              :disabled="!canCreatePlan"
            >
              Create plan
            </button>
          </div>
        </div>
      </form>
    </div>
  </main>
</template>

<script>
import PriceLogics from '@/components/price-logics';
import PluttoHeader from '@/components/plutto-header';

export default {
  components: { PluttoHeader, PriceLogics },
  data() {
    return {
      newPlan: {},
      priceLogics: [],
    };
  },
  methods: {
    addPriceLogic() {
      this.priceLogics.push({ type: 'PriceLogic::FlatFee', price: 0, tiers: null });
    },
    createPlan() {
      const planVersion = {
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
      this.$store.dispatch('CREATE_PLAN', { plan: this.newPlan, planVersion })
        .then(() => this.$router.go(-1));
    },
  },
  computed: {
    canCreatePlan() {
      return this.priceLogics.length > 0 && this.newPlan.name;
    },
  },
};
</script>

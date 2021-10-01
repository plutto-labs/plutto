<template>
  <main>
    <template v-if="currentProduct">
      <PluttoHeader
        title="Product details"
        :show-back-button="true"
      />
      <div class="px-6 mt-6">
        <div class="text-xl">
          {{ currentProduct.name }}
        </div>
        <div class="flex items-center justify-between my-8">
          <div class="text-lg text-gray-50">
            Pricings:
          </div>
          <button
            class="btn btn--filled"
            @click="showPricingForm = true"
          >
            New pricing
          </button>
        </div>
        <Pricing
          v-for="pricing in currentProduct.pricings"
          :key="pricing.id"
          :pricing="pricing"
          class="p-4 my-4 border border-gray-200 rounded"
        />
      </div>
    </template>
    <PluttoLoader
      v-else-if="loading"
    />
    <PluttoSlideover
      :showing="showPricingForm"
      @close="showPricingForm = false"
    >
      <NewPricingForm
        @created-pricing="pricing => showPricingForm = false"
        :create-product="false"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import Pricing from '@/components/pricing';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import NewPricingForm from '@/components/forms/new-pricing-form';

export default {
  components: { PluttoHeader, PluttoLoader, Pricing, PluttoSlideover, NewPricingForm },
  data() {
    return {
      newPricing: {
        temp: 'value',
      },
      showPricingForm: false,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PRODUCT', this.$route.params.id);
    if (!this.meters) await this.$store.dispatch('GET_METERS');
  },
  computed: {
    ...mapState({
      loading: state => state.products.loading,
      currentProduct: state => state.products.currentProduct,
      meters: state => state.meters.meters,
    }),
  },
};
</script>

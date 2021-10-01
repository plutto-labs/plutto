<template>
  <main>
    <PluttoHeader
      button-text="Add Product"
      @button-clicked="showPricingForm = true"
    />
    <div class="px-6 mx-auto mt-6 max-w-7xl">
      <div
        v-if="!loading"
        class="grid grid-rows-1 gap-6 md:grid-cols-2 lg:grid-cols-3"
      >
        <ProductCard
          v-for="product in products"
          :key="product.id"
          :product="product"
        />
      </div>
      <PluttoLoader
        v-else
      />
    </div>
    <PluttoSlideover
      :showing="showPricingForm"
      @close="showPricingForm = false"
    >
      <NewPricingForm
        @created-product="product => showPricingForm = false"
        :create-product="true"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import ProductCard from '@/components/product-card';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import NewPricingForm from '@/components/forms/new-pricing-form';

export default {
  components: { PluttoHeader, PluttoLoader, ProductCard, PluttoSlideover, NewPricingForm },
  data() {
    return {
      showPricingForm: false,
    };
  },
  computed: {
    ...mapState({
      loading: state => state.products.loading,
      products: state => state.products.products,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_PRODUCTS');
  },
  methods: {
    destroyProduct(product) {
      this.$store.dispatch('DESTROY_PRODUCT', product);
    },
  },
};
</script>

<template>
  <Form
    @submit="submit"
    class="w-full space-y-8 divide-y divide-gray-700 md:max-w-xl"
  >
    <div class="m-auto divide-gray-700">
      <template v-if="createProduct">
        <div class="sm:col-span-3">
          <div class="mt-8 mb-4 text-lg">
            Product information
          </div>
          <div class="flex my-4">
            <div class="w-full mr-8 plutto-input">
              <label
                for="name"
                class="block text-sm font-medium text-gray-800"
              >
                {{ $t('message.global.name') }}
              </label>
              <input
                type="text"
                name="name"
                id="name"
                v-model="newProduct.name"
                required
                class="mt-3 plutto-input__input"
              >
            </div>
            <div class="w-32 mr-8">
              <label
                for="meter-type"
                class="text-sm font-medium text-gray-800"
              >
                Metered with
              </label>
              <PluttoDropdown
                class="w-32 mt-2 plutto-input"
                :selected="newProduct.meterId"
                :options="meters"
                label-key="name"
                value-key="id"
                @selected="(meterId) => newProduct.meterId = meterId"
                add-element-text="Add Meter"
                @addElementClicked="showNewMeterModal = true"
                float="right"
              />
            </div>
          </div>
        </div>
      </template>
      <div class="sm:col-span-3">
        <div class="mt-8 mb-4 text-lg">
          Pricing
        </div>
        <div class="flex my-4">
          <div class="w-full mr-8 plutto-input">
            <label
              for="name"
              class="block text-sm font-medium text-gray-800"
            >
              {{ $t('message.global.name') }}
            </label>
            <input
              class="mt-2 plutto-input__input"
              v-model="newPricing.name"
            >
          </div>
          <div class="w-32 mr-8">
            <label
              for="currency"
              class="block text-sm font-medium text-gray-800"
            >
              {{ $t('message.global.currency') }}
            </label>
            <PluttoDropdown
              class="w-32 mt-2 plutto-input"
              :selected="newPricing.currency"
              :options="CURRENCY_KEYS"
              @selected="(currency) => newPricing.currency = currency"
            />
          </div>
        </div>
        <PriceLogics
          v-model="priceLogics"
          :allow-metered="!!newProduct.meterId || !!currentProduct.meter"
        />
      </div>
    </div>
    <div class="pt-5">
      <div class="flex justify-end">
        <button
          class="btn"
          :disabled="!canCreateProduct"
        >
          {{ createProduct ? 'Create Product' : 'Add pricing' }}
        </button>
      </div>
    </div>
    <PluttoModal
      :showing="showNewMeterModal"
      @close="showNewMeterModal = false"
    >
      <NewMeterForm
        @created-meter="meter => assignNewMeter(meter)"
      />
    </PluttoModal>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import PriceLogics from '@/components/price-logics';
import PluttoDropdown from '@/components/plutto-dropdown';
import { Form } from 'vee-validate';
import PluttoModal from '@/components/plutto-modal';
import NewMeterForm from '@/components/forms/new-meter-form';

export default {
  components: { PriceLogics, Form, PluttoDropdown, PluttoModal, NewMeterForm },
  props: {
    createProduct: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      newProduct: {
        currency: 'CLP',
        meterId: null,
      },
      newPricing: { name: null, currency: null },
      priceLogics: [],
      showNewMeterModal: false,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_METERS');
    if (!this.createProduct && this.currentProduct.defaultVersion) {
      this.priceLogics = this.currentProduct.defaultVersion.priceLogics;
    }
  },
  methods: {
    submit() {
      if (this.createProduct) {
        this.$store.dispatch('CREATE_PRODUCT', { product: this.newProduct, pricing: this.pricing })
          .then((product) => this.$emit('created-product', product));
      } else {
        this.$store.dispatch(
          'CREATE_PRICING',
          { productId: this.currentProduct.id, pricing: this.pricing })
          .then((pricing) => this.$emit('created-pricing', pricing));
      }
    },
    assignNewMeter(newMeter) {
      this.showNewMeterModal = false;
      this.newProduct.meterId = newMeter.id;
    },
  },
  computed: {
    ...mapState({
      currentProduct: state => state.products.currentProduct,
      meters: state => state.meters.meters,
    }),
    priceLogicsValid() {
      return this.priceLogics.every((pl) => (!pl.tierable || pl.tiers));
    },
    canCreateProduct() {
      return this.priceLogics.length > 0 && this.priceLogicsValid &&
        (!this.createProduct || this.newProduct.name);
    },
    pricing() {
      return {
        currency: this.newPricing.currency,
        name: this.newPricing.name,
        priceLogicsAttributes: this.priceLogics.map(pl => {
          const priceLogic = Object.assign({}, {
            price: pl.price,
            type: pl.type,
            meterCountMethod: pl.meterCountMethod,
          });
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

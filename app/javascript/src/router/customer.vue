<template>
  <main>
    <template v-if="currentCustomer">
      <PluttoHeader
        :show-back-button="true"
        :title="currentCustomer.name"
        button-text="Edit Customer"
        @button-clicked="showNewCustomerForm = true"
      />
      <div class="px-6 mt-6 customer-grid">
        <div class="p-2 text-sm text-gray-100 bg-gray-800 border border-gray-400 rounded-lg customer-grid__info md:p-4">
          <div class="mb-2 text-lg text-gray-50">
            Information
          </div>
          <div>
            Name: <span class="text-gray-300">{{ currentCustomer.name }}</span>
          </div>
          <div>
            Email: <span class="text-gray-300">{{ currentCustomer.email }}</span>
          </div>
          <div>
            Identifier: <span class="text-gray-300">{{ currentCustomer.identifier }}</span>
          </div>
          <div>
            Created: <span class="text-gray-300">{{ formatDate(currentCustomer.createdAt) }}</span>
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-100 bg-gray-800 border border-gray-400 rounded-lg customer-grid__billing md:p-4"
          v-if="currentCustomer.billingInformation"
        >
          <div class="mb-2 text-lg text-gray-50">
            Billing Information
          </div>
          <div>
            Name: <span class="text-gray-300">{{ currentCustomer.billingInformation.legalName }}</span>
          </div>
          <div>
            Country: <span class="text-gray-300">{{ currentCustomer.billingInformation.countryIsoCode }}</span>
          </div>
          <div>
            Activity: <span class="text-gray-300">{{ currentCustomer.billingInformation.activity }}</span>
          </div>
          <div>
            Tax ID: <span class="text-gray-300">{{ currentCustomer.billingInformation.taxId }}</span>
          </div>
          <div>
            Address: <span class="text-gray-300">{{ fullAddress(currentCustomer.billingInformation) }}</span>
          </div>
          <div>
            Phone: <span class="text-gray-300">{{ currentCustomer.billingInformation.phone }}</span>
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-300 bg-gray-800 border border-gray-400 rounded-lg customer-grid__subscription md:p-4"
          v-if="currentCustomer.activePlanSubscription"
        >
          <div class="mb-2 text-lg text-gray-50">
            Current Subscription
            <div class="text-xs text-gray-300">
              {{ currentCustomer.activePlanSubscription.id }}
            </div>
          </div>
          <div class="justify-between md:flex">
            <div>
              Plan Name: <span>{{ currentCustomer.activePlanSubscription.planName }}</span>
              <div class="text-xs">
                {{ currentCustomer.activePlanSubscription.version }} -
                {{ currentCustomer.activePlanSubscription.planVersionId }}
              </div>
              <div>
                Subscribed since: <span>{{ formatDateTime(currentCustomer.activePlanSubscription.createdAt) }}</span>
              </div>
              <div>
                Next billing date:
                <span>
                  {{ formatDate(currentCustomer.currentBillingPeriodEndDate) }}
                  ({{ daysFromDate(currentCustomer.currentBillingPeriodEndDate) }})
                </span>
              </div>
            </div>
            <div>
              <div class="mt-2 text-gray-50 md:mt-0">
                Last Invoice Amount
              </div>
              <span class="text-2xl">
                {{ formatCurrency(currentCustomer.previousInvoiceAmount, currentCustomer.previousInvoiceCurrency) }}
              </span>
            </div>
          </div>
        </div>
        <div
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-300 bg-gray-800 border border-gray-400 rounded-lg opacity-50 cursor-not-allowed customer-grid__subscription md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-50">
            No active subscription
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-300 bg-gray-800 border border-gray-400 rounded-lg customer-grid__usage md:p-4"
          v-if="currentCustomer.currentPeriodDetails"
        >
          <div class="mb-2 text-lg text-gray-50">
            Current Usage
          </div>
          <div
            v-for="(detail, index) in currentCustomer.currentPeriodDetails.details"
            :key="index"
            class="flex justify-between"
          >
            <span><span v-if="detail.meter">{{ detail.quantity }}x </span>{{ detail.meter || detail.type }}:</span>
            <span>
              {{ formatCurrency(detail.totalPriceCents, currentCustomer.currentPeriodDetails.price.currencyIso) }}
            </span>
          </div>
          <div class="flex justify-between mt-2 text-xl">
            <span>Total:</span>
            {{ formatCurrency(currentCustomer.currentPeriodDetails.price.cents,
                              currentCustomer.currentPeriodDetails.price.currencyIso) }}
          </div>
        </div>
        <div
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-300 bg-gray-800 border border-gray-400 rounded-lg opacity-50 cursor-not-allowed customer-grid__usage md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-50">
            N/A
          </div>
        </div>
      </div>
    </template>
    <PluttoModal
      :showing="showNewCustomerForm"
      @close="showNewCustomerForm = false"
    >
      <NewCustomerForm
        :editing-customer="currentCustomer"
        @edited-customer="customer => { showNewCustomerForm = false }"
      />
    </PluttoModal>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import NewCustomerForm from '@/components/forms/new-customer-form';
import PluttoModal from '@/components/plutto-modal';

export default {
  components: { PluttoHeader, PluttoModal, NewCustomerForm },
  data() {
    return {
      showNewCustomerForm: false,
      editingCustomer: null,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_CUSTOMER', this.$route.params.id);
  },
  methods: {
    fullAddress(bf) {
      let address = '';
      if (bf.address) address += `${bf.address}, `;
      if (bf.city) address += `${bf.city}, `;
      if (bf.state) address += `${bf.state}, `;
      if (bf.zip) address += `${bf.zip}`;

      return address;
    },
  },
  computed: {
    ...mapState({
      loading: state => state.plans.loading,
      currentCustomer: state => state.customers.currentCustomer,
    }),
  },
};
</script>

<style lang="scss" scoped>
.customer-grid {
  display: grid;
  grid-template-rows: 1fr;
  grid-template-columns: 1fr 1fr 1fr 1fr;
  grid-template-areas: 'info info billing billing'
    'subscription subscription subscription usage'
    'invoices invoices meters meters';
  grid-gap: 24px;

  @media screen and (max-width: '768px') {
    grid-template-areas: 'info' 'billing' 'subscription' ' usage' 'invoices' 'meters';
    grid-template-columns: 1fr;
  }

  &__info {
    grid-area: info;
  }

  &__billing {
    grid-area: billing;
  }

  &__subscription {
    grid-area: subscription;
  }

  &__usage {
    grid-area: usage;
  }

  &__invoices {
    grid-area: invoices;
  }

  &__meters {
    grid-area: meters;
  }
}
</style>

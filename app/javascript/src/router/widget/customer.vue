<template>
  <main>
    <template v-if="currentCustomer">
      <div class="flex">
        <PluttoHeader
          class="w-full"
          :show-back-button="true"
          :title="currentCustomer.name"
          button-text="Edit Customer"
          @button-clicked="showNewCustomerForm = true"
        />
        <button
          class="mx-6 btn btn--filled"
          @click="showSubscriptionForm = true"
        >
          {{ currentCustomer.activeSubscription ? 'Current subscription' : 'Add subscription' }}
        </button>
      </div>
      <div class="px-6 mt-6 customer-grid">
        <div class="p-2 text-sm text-gray-800 border border-gray-500 rounded-lg bg-gray-50 customer-grid__info md:p-4">
          <div class="mb-2 text-lg text-gray-900">
            Information
            <div class="text-xs text-gray-600">
              <PluttoCopyableDiv :value="currentCustomer.identifier" />
            </div>
          </div>
          <div>
            Name: <span class="text-gray-600">{{ currentCustomer.name }}</span>
          </div>
          <div>
            Email: <span class="text-gray-600">{{ currentCustomer.email }}</span>
          </div>
          <div>
            Created: <span class="text-gray-600">{{ formatDate(currentCustomer.createdAt) }}</span>
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-800 border border-gray-500 rounded-lg bg-gray-50 customer-grid__billing md:p-4"
          v-if="currentCustomer.billingInformation"
        >
          <div class="mb-2 text-lg text-gray-900">
            Billing Information
          </div>
          <div>
            Name: <span class="text-gray-600">{{ currentCustomer.billingInformation.legalName }}</span>
          </div>
          <div>
            Country: <span class="text-gray-600">{{ currentCustomer.billingInformation.countryIsoCode }}</span>
          </div>
          <div>
            Activity: <span class="text-gray-600">{{ currentCustomer.billingInformation.activity }}</span>
          </div>
          <div>
            Tax ID: <span class="text-gray-600">{{ currentCustomer.billingInformation.taxId }}</span>
          </div>
          <div>
            Address: <span class="text-gray-600">{{ fullAddress(currentCustomer.billingInformation) }}</span>
          </div>
          <div>
            Phone: <span class="text-gray-600">{{ currentCustomer.billingInformation.phone }}</span>
          </div>
        </div>
        <div
          class="relative p-2 overflow-y-hidden text-sm text-gray-800 border border-gray-500 rounded-lg bg-gray-50 customer-grid__payments md:p-4 max-h-52"
          v-if="currentCustomer.paymentMethods"
        >
          <div class="mb-2 text-lg text-gray-900">
            Payment Methods
          </div>
          <div class="h-full overflow-y-scroll">
            <div
              v-for="(method, index) in currentCustomer.paymentMethods"
              :key="index"
              class="flex items-center justify-between px-3 py-2 my-2 text-xs border border-gray-300 rounded-lg bg-gray-50"
            >
              <div class="flex">
                <div class="relative w-6 h-4">
                  <img
                    v-if="method.cardBrand === 'mastercard'"
                    class="absolute"
                    src="../../../img/master-card.svg"
                  >
                  <img
                    v-if="method.cardBrand === 'visa'"
                    class="absolute -mt-1"
                    src="../../../img/visa.png"
                  >
                </div>
                <span class="ml-2">{{ method.currency }}</span>
              </div>
              <span class="font-mono">
                <span class="hidden xl:inline">
                  &#8226;&#8226;&#8226;&#8226; &#8226;&#8226;&#8226;&#8226; &#8226;&#8226;&#8226;&#8226;
                </span>
                <span class="inline md:hidden">
                  &#8226;&#8226;&#8226;&#8226; &#8226;&#8226;&#8226;&#8226; &#8226;&#8226;&#8226;&#8226;
                </span>
                {{ method.last4Digits }}
              </span>
            </div>
            <div v-if="currentCustomer.paymentMethods.length === 0">
              No method availabe, yet
            </div>
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-600 border border-gray-500 rounded-lg bg-gray-50 customer-grid__subscription md:p-4"
          v-if="currentCustomer.activeSubscription"
        >
          <div class="mb-2 text-lg text-gray-900">
            Current Subscription
            <div class="text-xs text-gray-600">
              <PluttoCopyableDiv :value="currentCustomer.activeSubscription.id" />
            </div>
          </div>
          <div class="justify-between md:flex">
            <div>
              <div
                class="flex items-center mt-2 text-gray-800"
                v-if="currentCustomer.activeSubscription.permissionGroup"
              >
                <p>Plan: </p>
                <div class="ml-3 text-xs text-blue-500">
                  {{ currentCustomer.activeSubscription.permissionGroup.name }}
                </div>
              </div>
              <div>
                <div class="mt-2">
                  Subscribed since: <span>{{ formatDateTime(currentCustomer.activeSubscription.createdAt) }}</span>
                </div>
                <div v-if="currentCustomer.currentBillingPeriodEndDate">
                  Next billing date:
                  <span>
                    {{ formatDate(currentCustomer.currentBillingPeriodEndDate) }}
                    ({{ daysFromDate(currentCustomer.currentBillingPeriodEndDate) }})
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-600 border border-gray-500 rounded-lg opacity-50 cursor-not-allowed bg-gray-50 customer-grid__subscription md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-900">
            No active subscription
          </div>
        </div>
        <div
          class="p-2 text-sm text-gray-600 border border-gray-500 rounded-lg bg-gray-50 customer-grid__usage md:p-4"
          v-if="currentCustomer.currentPeriodDetails && currentCustomer.activeSubscription"
        >
          <div class="mb-2 text-lg text-gray-900">
            Current Plan
          </div>
          <div
            v-for="(detail, index) in currentCustomer.currentPeriodDetails.details"
            :key="index"
            class="flex justify-between"
          >
            <span>{{ detail.description.replace('Permission Group', 'Plan') }}:</span>
            <span>
              {{ formatCurrency(detail.totalPrice, currentCustomer.activeSubscription.currency) }}
            </span>
          </div>
          <div class="flex justify-between mt-2 text-xl">
            <span>Total:</span>
            {{ formatCurrency(currentCustomer.currentPeriodDetails.price,
                              currentCustomer.activeSubscription.currency) }}
          </div>
        </div>
        <div
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-600 border border-gray-500 rounded-lg opacity-50 cursor-not-allowed bg-gray-50 customer-grid__usage md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-900">
            No plan
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
    <PluttoModal
      :showing="showSubscriptionForm"
      @close="showSubscriptionForm = false"
    >
      <SubscriptionForm
        class="relative"
        :current-subscription="currentCustomer.activeSubscription"
        @created-subscription="showSubscriptionForm = false;"
      />
    </PluttoModal>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import NewCustomerForm from '@/components/forms/new-customer-form';
import SubscriptionForm from '@/components/forms/subscription-form';
import PluttoModal from '@/components/plutto-modal';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, PluttoCopyableDiv, SubscriptionForm,
  },
  props: {
    app: {
      type: String,
      default: 'plutto',
    },
  },
  data() {
    return {
      showNewCustomerForm: false,
      showSubscriptionForm: false,
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
      currentCustomer: state => state.customers.currentCustomer,
    }),
  },
};
</script>

<style lang="scss" scoped>
.customer-grid {
  display: grid;
  grid-template-rows: 1fr;
  grid-template-columns: repeat(6, 1fr);
  grid-template-areas: 'info info usage usage billing billing'
    'subscription subscription payments payments billing billing';
  grid-gap: 24px;

  @media screen and (max-width: '768px') {
    grid-template-areas: 'info' 'billing' 'meters' 'subscription' 'none' 'usage' 'payments' ;
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

  &__payments {
    grid-area: payments;
  }

  &__invoices {
    grid-area: invoices;
  }

  &__meters {
    grid-area: meters;
  }
}
</style>

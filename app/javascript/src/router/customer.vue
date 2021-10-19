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
          class="w-48 mr-6 btn btn--filled"
          @click="showSubscriptionForm = true"
        >
          {{ currentCustomer.activeSubscription ? 'Edit subscription' : 'Add subscription' }}
        </button>
      </div>
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
          <div class="flex items-center">
            Identifier:
            <PluttoCopyableDiv
              class="ml-1"
              :value="currentCustomer.identifier"
            />
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
          v-if="currentCustomer.activeSubscription"
        >
          <div class="mb-2 text-lg text-gray-50">
            {{ currentCustomer.activeSubscription.trialFinishesAt === null ?
              'Current Subscription' : 'Trial information' }}
            <div class="text-xs text-gray-300">
              <PluttoCopyableDiv :value="currentCustomer.activeSubscription.id" />
            </div>
          </div>
          <div class="justify-between md:flex">
            <div>
              <div>
                Products:
                <div class="text-xs">
                  {{ productsString(currentCustomer.activeSubscription.pricings) }}
                </div>
              </div>
              <div v-if="currentCustomer.activeSubscription.permissionGroup">
                Permission group: <span>{{ currentCustomer.activeSubscription.permissionGroup.name }}</span>
              </div>
              <div v-if="currentCustomer.activeSubscription.trialFinishesAt !== null">
                <div>
                  End trial date: <span class="text-gray-300">{{ `${formatDate(currentCustomer.activeSubscription.trialFinishesAt)} (${daysFromDate(currentCustomer.activeSubscription.trialFinishesAt)})` }}</span>
                </div>
              </div>
              <div v-else>
                <div>
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
            <div
              v-if="currentCustomer.activeSubscription.trialFinishesAt !== null"
              class="mt-auto"
            >
              <span
                class="h-full text-2xl cursor-pointer plutto-icon"
                @click="showEditTrialForm = true"
              >
                edit_calendar
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
            <span>{{ detail.description }}:</span>
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
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-300 bg-gray-800 border border-gray-400 rounded-lg opacity-50 cursor-not-allowed customer-grid__usage md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-50">
            N/A
          </div>
        </div>
        <div
          class="relative p-2 overflow-y-hidden text-sm text-gray-100 bg-gray-800 border border-gray-400 rounded-lg customer-grid__payments md:p-4 max-h-52"
          v-if="currentCustomer.paymentMethods"
        >
          <div class="mb-2 text-lg text-gray-50">
            Payment Methods
          </div>
          <div class="h-full overflow-y-scroll">
            <div
              v-for="(method, index) in currentCustomer.paymentMethods"
              :key="index"
              class="flex items-center justify-between px-3 py-2 my-2 text-xs bg-gray-900 border border-gray-600 rounded-lg"
            >
              <div class="flex">
                <div class="relative w-6 h-4">
                  <img
                    v-if="method.cardBrand === 'mastercard'"
                    class="absolute"
                    src="../../img/master-card.svg"
                  >
                  <img
                    v-if="method.cardBrand === 'visa'"
                    class="absolute -mt-1"
                    src="../../img/visa.png"
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
      :showing="showEditTrialForm"
      @close="showEditTrialForm = false"
    >
      <EditTrialForm
        :subscription="currentCustomer.activeSubscription"
        @edited-trial="showEditTrialForm = false;"
      />
    </PluttoModal>
    <PluttoModal
      :showing="showSubscriptionForm"
      @close="showSubscriptionForm = false"
    >
      <SubscriptionForm
        class="relative"
        :subscription="currentCustomer.activeSubscription"
        @created-subscription="showSubscriptionForm = false;"
      />
    </PluttoModal>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import NewCustomerForm from '@/components/forms/new-customer-form';
import EditTrialForm from '@/components/forms/edit-trial-form';
import SubscriptionForm from '@/components/forms/subscription-form';
import PluttoModal from '@/components/plutto-modal';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, EditTrialForm, PluttoCopyableDiv, SubscriptionForm,
  },
  data() {
    return {
      showNewCustomerForm: false,
      showSubscriptionForm: false,
      showEditTrialForm: false,
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
  grid-template-columns: 1fr 1fr 1fr 1fr;
  grid-template-areas: 'info info billing billing'
    'subscription subscription usage payments'
    'invoices invoices meters meters';
  grid-gap: 24px;

  @media screen and (max-width: '768px') {
    grid-template-areas: 'info' 'billing' 'subscription' ' usage' 'payments' 'invoices' 'meters';
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

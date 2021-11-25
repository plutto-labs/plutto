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
        <div
          class="p-2 text-sm text-gray-600 border border-gray-500 rounded-lg bg-gray-50 customer-grid__subscription md:p-4"
          v-if="currentCustomer.activeSubscription"
        >
          <div class="mb-2 text-lg text-gray-900">
            {{ currentCustomer.activeSubscription.trialFinishesAt === null ?
              'Current Subscription' : 'Trial information' }}
            <div class="text-xs text-gray-600">
              <PluttoCopyableDiv :value="currentCustomer.activeSubscription.id" />
            </div>
          </div>
          <div class="justify-between md:flex">
            <div>
              <div class="text-gray-800">
                Products:
                <div class="text-xs">
                  <div
                    v-for="(pricing, index) in currentCustomer.activeSubscription.pricings"
                    :key="pricing.id"
                  >
                    <div class="text-skyblue-800">
                      {{ index + 1 }}. {{ pricing.productName }}
                    </div>
                    <span class="ml-3 text-skyblue">{{ pricing.name }} [{{ pricing.currency }}]</span>
                  </div>
                </div>
              </div>
              <div
                class="mt-2 text-gray-800"
                v-if="currentCustomer.activeSubscription.permissionGroup"
              >
                Permission group:
                <div class="ml-3 text-xs text-blue-200">
                  {{ currentCustomer.activeSubscription.permissionGroup.name }}
                </div>
              </div>
              <div v-if="currentCustomer.activeSubscription.trialFinishesAt !== null">
                <div>
                  End trial date: <span class="text-gray-600">{{ `${formatDate(currentCustomer.activeSubscription.trialFinishesAt)} (${daysFromDate(currentCustomer.activeSubscription.trialFinishesAt)})` }}</span>
                </div>
              </div>
              <div v-else>
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
          class="flex items-center justify-center h-32 p-1 text-sm text-gray-600 border border-gray-500 rounded-lg opacity-50 cursor-not-allowed bg-gray-50 customer-grid__usage md:p-4"
          v-else
        >
          <div class="mb-2 text-lg text-gray-900">
            No subscription usage
          </div>
        </div>
        <div class="p-2 text-sm text-gray-600 border border-gray-500 rounded-lg bg-gray-50 customer-grid__meters md:p-4">
          <line-chart
            :datasets="currentCustomer.meterEventsData"
            title="Counts for each meter"
            label="Meter Count"
            class="p-3 rounded-md bg-gray-50"
          />
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
import EditTrialForm from '@/components/forms/edit-trial-form';
import SubscriptionForm from '@/components/forms/subscription-form';
import PluttoModal from '@/components/plutto-modal';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';
import LineChart from '@/components/charts/line-chart';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, EditTrialForm, PluttoCopyableDiv, SubscriptionForm, LineChart,
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
  grid-template-columns: repeat(6, 1fr);
  grid-template-areas: 'info info billing billing usage usage'
    'subscription subscription meters meters meters meters'
    'payments payments meters meters meters meters';
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

<template>
  <div>
    <template v-if="customersRows && customersRows.length > 0">
      <PluttoTable
        class="mt-6 rounded-lg"
        :headers="headers"
        :rows="customersRows"
        :loading="loading"
        @show-clicked="(customer) => $router.push({ name: 'customer', params: { id: customer.id } })"
      />
    </template>
    <div
      class="flex items-center justify-center w-full text-center h-80"
      v-else
    >
      <div>
        <p>
          Ups! Seems like there's no <b>active</b> customers.
        </p>
        <p>
          Try looking for
          <router-link
            class="underline text-primary"
            to="/customers/inactive"
          >
            inactive customers.
          </router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';

export default {
  components: {
    PluttoTable,
  },
  data() {
    return {
      headers: [{
        title: 'info',
        type: 'twoLinesText',
        bigText: 'email',
        smallText: 'name',
      }, {
        title: 'identifier',
        type: 'copyableLine',
      }, {
        title: 'product',
        type: 'oneLineText',
      }, {
        title: 'previousInvoiceAmount',
        type: 'oneLineText',
      }, {
        title: 'currentBillingPeriodEndDate',
        type: 'twoLinesText',
        bigText: 'currentBillingPeriodEndDate',
        smallText: 'numberOfDays',
      }, {
        title: 'none',
        type: 'action',
        action: 'show',
      }],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
    }),
    customersRows() {
      return this.customers && this.customers.map((customer) => (
        {
          email: customer.email,
          name: customer.name,
          identifier: customer.identifier,
          id: customer.id,
          previousInvoiceAmount: this.formatCurrency(customer.previousInvoiceAmount, customer.previousInvoiceCurrency),
          currentBillingPeriodEndDate: this.formatDate(customer.currentBillingPeriodEndDate),
          numberOfDays: this.daysFromDate(customer.currentBillingPeriodEndDate),
          product: this.productsString(customer.activeSubscription?.pricings),
        }
      ));
    },
  },
  async beforeCreate() {
    await this.$store.dispatch('SET_FILTER', { key: 'scope', value: 'active' });
    await this.$store.dispatch('GET_CUSTOMERS');
  },
};
</script>

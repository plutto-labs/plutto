<template>
  <div>
    <PluttoTable
      class="mt-6 rounded-lg"
      :headers="headers"
      :rows="customersRows"
      :loading="loading"
      @show-clicked="(customer) => $router.push({ name: 'customer', params: { id: customer.id } })"
    />
    <PluttoPagination
      class="mt-6"
      :showing="totalPages > 1"
      :total-pages="totalPages"
      @change-page="(page) => getCustomers(page)"
    />
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoPagination from '@/components/plutto-pagination';

export default {
  components: {
    PluttoTable,
    PluttoPagination,
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
        title: 'trialFinishesAt',
        type: 'twoLinesText',
        bigText: 'trialFinishesAt',
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
      totalPages: state => state.customers.totalPages,
    }),
    customersRows() {
      return this.sortedCustomers.map((customer) => (
        {
          email: customer.email,
          name: customer.name,
          identifier: customer.identifier,
          id: customer.id,
          trialFinishesAt: this.formatDate(customer.trialFinishesAt),
          numberOfDays: this.daysFromDate(customer.trialFinishesAt),
          product: this.productsString(customer.activeSubscription?.pricings),
        }
      ));
    },
    sortedCustomers() {
      return [...this.customers].sort(
        (a, b) => new Date(a.trialFinishesAt) - new Date(b.trialFinishesAt),
      );
    },
  },
  async beforeCreate() {
    await this.$store.dispatch('SET_FILTER', { key: 'scope', value: 'trial' });
    await this.$store.dispatch('GET_CUSTOMERS');
  },
  methods: {
    getCustomers(page = 1) {
      this.$store.dispatch('SET_PAGE', page);
      this.$store.dispatch('GET_CUSTOMERS');
    },
  },
};
</script>

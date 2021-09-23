<template>
  <div>
    <PluttoTable
      class="mt-6 rounded-lg"
      :headers="headers"
      :rows="customersRows"
      :loading="loading"
      @show-clicked="(customer) => $router.push({ name: 'customer', params: { id: customer.id } })"
    />
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
        title: 'plan',
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
    }),
    customersRows() {
      return this.customers.map((customer) => (
        {
          email: customer.email,
          name: customer.name,
          identifier: customer.identifier,
          id: customer.id,
          trialFinishesAt: this.formatDate(customer.trialFinishesAt),
          numberOfDays: this.daysFromDate(customer.trialFinishesAt),
          plan: `${customer.activePlanSubscription?.planName} - ${customer.activePlanSubscription?.version}`,
        }
      ));
    },
  },
  async mounted() {
    await this.$store.dispatch('GET_TRIAL_CUSTOMERS');
  },
};
</script>

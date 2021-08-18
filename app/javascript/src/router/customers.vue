<template>
  <main>
    <PluttoHeader
      title="Customers"
      button-text="Add Customer"
    />
    <div class="px-6 mt-6">
      <PluttoTable
        class="mt-6 rounded-lg"
        :headers="headers"
        :rows="customers"
        :loading="loading"
        @delete-clicked="destroyCustomer"
      >
        <template #component="row">
          <PluttoDropdown
            :selected="row.row.activePlanSubscription.planName"
            :options="planOptions()"
            @selected="(planVersionId) => selected(row.row.id, planVersionId)"
          />
        </template>
      </PluttoTable>
    </div>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '@/components/plutto-header';
import PluttoDropdown from '@/components/plutto-dropdown';

export default {
  components: {
    PluttoTable,
    PluttoHeader,
    PluttoDropdown,
  },
  data() {
    return {
      headers: [
        {
          title: 'info',
          type: 'twoLinesText',
          bigText: 'name',
          smallText: 'email',
        },
        {
          title: 'identifier',
          type: 'oneLineText',
        },
        {
          title: 'planSubscription',
          type: 'component',
        },
        {
          title: 'none',
          type: 'action',
          action: 'delete',
        },
      ],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
      plans: state => state.plans.plans,
    }),
  },
  async mounted() {
    await Promise.all([this.$store.dispatch('GET_CUSTOMERS'), this.$store.dispatch('GET_PLANS')]);
  },
  methods: {
    destroyCustomer(customer) {
      this.$store.dispatch('DESTROY_CUSTOMER', customer);
    },
    selected(customerId, planVersionId) {
      this.$store.dispatch('CREATE_PLAN_SUBSCRIPTION', { customerId, planVersionId })
        .then((response) => {
          this.$store.dispatch('UPDATE_CUSTOMER_PLAN_SUBSCRIPTION',
            { id: customerId, planSubscription: response.planSubscription });
        });
    },
    planOptions() {
      return this.plans.map(plan => ({ value: plan.name, id: plan.defaultVersion.id }));
    },
  },
};
</script>

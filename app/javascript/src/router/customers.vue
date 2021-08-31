<template>
  <main>
    <PluttoHeader
      button-text="Add Customer"
      @button-clicked="showNewCustomerForm = true"
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
            :selected="row.row.activePlanSubscription && planVersionId"
            :options="planVersionsOptions"
            label-key="name"
            value-key="id"
            @selected="(planVersionId) => changeCustomerPlanVersion(row.row.id, planVersionId)"
          />
        </template>
      </PluttoTable>
    </div>
    <PluttoModal
      :showing="showNewCustomerForm"
      @close="showNewCustomerForm = false"
    >
      <NewCustomerForm
        @created-customer="customer => showNewCustomerForm = false"
      />
    </PluttoModal>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '@/components/plutto-header';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoModal from '@/components/plutto-modal';
import NewCustomerForm from '@/components/forms/new-customer-form';

export default {
  components: { PluttoTable, PluttoHeader, PluttoDropdown, PluttoModal, NewCustomerForm },
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
      showNewCustomerForm: false,
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
    }),
    planVersionsOptions() {
      return this.$store.getters.planVersionsOptions;
    },
  },
  async mounted() {
    await Promise.all([this.$store.dispatch('GET_CUSTOMERS'), this.$store.dispatch('GET_PLANS')]);
  },
  methods: {
    destroyCustomer(customer) {
      this.$store.dispatch('DESTROY_CUSTOMER', customer);
    },
    changeCustomerPlanVersion(customerId, planVersionId) {
      this.$store.dispatch('CREATE_PLAN_SUBSCRIPTION', { customerId, planVersionId })
        .then((response) => {
          this.$store.dispatch('UPDATE_CUSTOMER_PLAN_SUBSCRIPTION',
            { id: customerId, planSubscription: response.planSubscription });
        });
    },
  },
};
</script>

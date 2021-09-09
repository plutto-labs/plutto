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
            :selected="row.row.activePlanSubscription && row.row.activePlanSubscription.planVersionId"
            :force-selected-text="row.row.activePlanSubscription && planVersionName(row.row.activePlanSubscription)"
            :options="planVersionsOptions"
            label-key="name"
            value-key="id"
            @selected="(planVersionId) => changeCustomerPlanVersion(row.row.id, planVersionId)"
            add-element-text="Add Plan"
            @addElementClicked="showNewPlanVersionForm = true"
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
    <PluttoSlideover
      :showing="showNewPlanVersionForm"
      @close="showNewPlanVersionForm = false"
    >
      <NewPlanVersionForm
        @created-plan="plan => showNewPlanVersionForm = false"
        :create-plan="true"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '@/components/plutto-header';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoModal from '@/components/plutto-modal';
import NewCustomerForm from '@/components/forms/new-customer-form';
import PluttoSlideover from '@/components/plutto-slideover';
import NewPlanVersionForm from '@/components/forms/new-plan-version-form';

export default {
  components: {
    PluttoTable, PluttoHeader, PluttoDropdown, PluttoModal, NewCustomerForm, PluttoSlideover, NewPlanVersionForm,
  },
  data() {
    return {
      headers: [{
        title: 'info',
        type: 'twoLinesText',
        bigText: 'name',
        smallText: 'email',
      }, {
        title: 'identifier',
        type: 'oneLineText',
      }, {
        title: 'id',
        type: 'oneLineText',
      }, {
        title: 'planSubscription',
        type: 'component',
      }, {
        title: 'none',
        type: 'action',
        action: 'delete',
      }],
      showNewCustomerForm: false,
      showNewPlanVersionForm: false,
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
    planVersionName(planSubscription) {
      return `${planSubscription.planName} - ${planSubscription.version}`;
    },
  },
};
</script>

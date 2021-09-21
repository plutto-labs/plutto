<template>
  <div>
    <PluttoTable
      class="mt-6 rounded-lg"
      :headers="headers"
      :rows="customers"
      :loading="loading"
      v-if="plans"
      @edit-clicked="(customer) => $emit('edit-customer', customer)"
    >
      <template #component="row">
        <PluttoDropdown
          :selected="row.row.activePlanSubscription && row.row.activePlanSubscription.planVersionId"
          :force-selected-text="row.row.activePlanSubscription && planVersionName(row.row.activePlanSubscription)"
          :options="plans"
          label-key="name"
          value-key="id"
          @selected="(planId) => showConfirmSubscription(row.row, planId)"
          add-element-text="Add Plan"
          @addElementClicked="showNewPlanVersionForm = true"
        />
      </template>
    </PluttoTable>
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
    <PluttoModal
      v-if="showSubscribeConfirmation"
      :showing="showSubscribeConfirmation"
      @close="showSubscribeConfirmation = false"
    >
      <ConfirmPlanSubscription
        @confirm="createPlanSubscription"
        @cancel="showSubscribeConfirmation = false"
        v-bind="confirmData"
      />
    </PluttoModal>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoSlideover from '@/components/plutto-slideover';
import PluttoModal from '@/components/plutto-modal';
import NewPlanVersionForm from '@/components/forms/new-plan-version-form';
import ConfirmPlanSubscription from '@/components/confirmations/confirm-plan-subscription';

export default {
  components: {
    PluttoTable,
    PluttoSlideover,
    NewPlanVersionForm,
    PluttoDropdown,
    PluttoModal,
    ConfirmPlanSubscription,
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
        type: 'copyableLine',
      }, {
        title: 'planSubscription',
        type: 'component',
      }, {
        title: 'none',
        type: 'action',
        action: 'edit',
      }],
      showNewPlanVersionForm: false,
      showSubscribeConfirmation: false,
      confirmData: {
        customer: null,
        plan: null,
      },
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
    showConfirmSubscription(customer, planId) {
      this.confirmData.customer = customer;
      this.confirmData.plan = this.plans.find((plan) => plan.id === planId);
      this.showSubscribeConfirmation = true;
    },
    createPlanSubscription(trialDate) {
      const customerId = this.confirmData.customer.id;
      const planId = this.confirmData.plan.id;
      this.$store.dispatch('CREATE_PLAN_SUBSCRIPTION', { customerId, planId, trialDate })
        .then((response) => {
          this.showSubscribeConfirmation = false;
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

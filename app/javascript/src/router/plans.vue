<template>
  <main>
    <PluttoHeader
      button-text="Add Plan"
      @button-clicked="showNewPlanVersionForm = true"
    />
    <div class="px-6 mx-auto mt-6 max-w-7xl">
      <div
        v-if="!loading"
        class="grid grid-rows-1 gap-6 md:grid-cols-3"
      >
        <PlanCard
          v-for="plan in plans"
          :key="plan.id"
          :plan="plan"
        />
      </div>
      <PluttoLoader
        v-else
      />
    </div>
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
import PlanCard from '@/components/plan-card';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import NewPlanVersionForm from '@/components/forms/new-plan-version-form';

export default {
  components: { PluttoHeader, PluttoLoader, PlanCard, PluttoSlideover, NewPlanVersionForm },
  data() {
    return {
      showNewPlanVersionForm: false,
    };
  },
  computed: {
    ...mapState({
      loading: state => state.plans.loading,
      plans: state => state.plans.plans,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_PLANS');
  },
  methods: {
    destroyPlan(plan) {
      this.$store.dispatch('DESTROY_PLAN', plan);
    },
  },
};
</script>

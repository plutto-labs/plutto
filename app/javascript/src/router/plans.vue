<template>
  <main>
    <PluttoHeader
      button-text="Add Plan"
      @button-clicked="showPlanForm = true"
    />
    <div class="px-6 mx-auto mt-6 max-w-7xl">
      <div
        v-if="!loading"
        class="grid grid-rows-1 gap-6 md:grid-cols-2 lg:grid-cols-3"
      />
      <div v-else-if="plans">
        <div
          v-for="plan in plans"
          :key="plan.id"
        >
          {{ plan.id }}
        </div>
      </div>
      <PluttoLoader
        v-else
      />
    </div>
    <PluttoSlideover
      :showing="showPlanForm"
      @close="showPlanForm = false"
    >
      <PlanForm
        @created-plan="plan => showPlanForm = false"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import PlanForm from '@/components/forms/plan-form';

export default {
  components: { PluttoHeader, PluttoLoader, PluttoSlideover, PlanForm },
  data() {
    return {
      showPlanForm: false,
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

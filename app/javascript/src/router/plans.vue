<template>
  <main>
    <PluttoHeader
      button-text="Add Plan"
      @button-clicked="$router.push({ name: 'new-plan'})"
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
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PlanCard from '@/components/plan-card';
import PluttoHeader from '../components/plutto-header';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoHeader, PluttoLoader, PlanCard },
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

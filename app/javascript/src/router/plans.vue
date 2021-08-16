<template>
  <main>
    <PluttoHeader
      title="Plans"
      button-text="Add Plan"
      @button-clicked="$router.push({ name: 'new-plan'})"
    />
    <div class="px-6 mt-6">
      <div v-if="!loading">
        <div
          v-for="plan in plans"
          :key="plan.id"
          @click="destroyPlan(plan)"
        >
          {{ plan.name }}
        </div>
      </div>
      <PluttoLoader
        v-else
      />
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '../components/plutto-header';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoHeader, PluttoLoader },
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

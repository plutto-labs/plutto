<template>
  <main>
    <PluttoHeader
      button-text="Add Plan"
      @button-clicked="showPlanForm = true"
    />
    <div class="mx-auto mt-6 max-w-7xl">
      <div
        v-if="!loading"
        class="grid grid-rows-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4"
      >
        <div
          v-for="plan in plans.sort((a, b) => Number(a.price) < Number(b.price) ? -1 : 1)"
          :key="plan.id"
          class="relative px-6 py-8 border border-gray-600 rounded-lg"
        >
          <div class="text-lg underline md:text-xl text-gray-50">
            {{ plan.name }}
          </div>
          <ul class="pl-4 mt-4 mb-8 text-gray-300">
            <li
              class="list-disc"
              v-for="permission in plan.permissions"
              :key="permission.key"
            >
              <span
                class="text-primary"
                v-if="permission.meterId"
              >{{ permission.limit || '&infin;' }}</span> {{ permission.name }}
            </li>
          </ul>
          <div class="absolute bottom-0 w-full py-4 -mx-6 text-xl text-center">
            {{ formatCurrency(plan.price, plan.currency) }}
          </div>
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

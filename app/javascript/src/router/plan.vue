<template>
  <main>
    <template v-if="currentPlan">
      <PluttoHeader
        title="Plan details"
      />
      <div class="px-6 mt-6">
        <div class="text-xl">
          Plan name: {{ currentPlan.name }}
        </div>
        <div class="mt-4">
          <span class="plutto-tag plutto-tag--green">{{ currentPlan.currency }}</span>
        </div>
        <div class="mt-4">
          Bills at <span class="underline text-primary-300">{{ currentPlan.billsAt }}</span> of period
        </div>
        <div class="flex items-center justify-between my-8">
          <div class="text-lg text-gray-300">
            Versions:
          </div>
          <button
            class="btn btn--filled"
            @click="$router.push({ name: 'new-plan-version', params: { id: currentPlan.id } })"
          >
            New version
          </button>
        </div>
        <PlanVersion
          v-for="planVersion in currentPlan.planVersions"
          :key="planVersion.identifier"
          :plan-version="planVersion"
          :is-default-version="planVersion.identifier == currentPlan.defaultVersion.identifier"
          class="p-4 my-4 border border-gray-200 rounded"
        />
      </div>
    </template>
    <PluttoLoader
      v-else-if="loading"
    />
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PlanVersion from '@/components/plan-version';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';

export default {
  components: { PluttoHeader, PluttoLoader, PlanVersion },
  data() {
    return {
      newPlanVersion: {
        temp: 'value',
      },
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PLAN', this.$route.params.id);
  },
  computed: {
    ...mapState({
      loading: state => state.plans.loading,
      currentPlan: state => state.plans.currentPlan,
    }),
  },
};
</script>

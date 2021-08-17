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
        <div class="flex items-center justify-between my-8">
          <div class="text-lg text-gray-300">
            Versions:
          </div>
          <button
            class="btn btn--filled"
            @click="createPlanVersion"
          >
            New version
          </button>
        </div>
        <div
          v-for="planVersion in currentPlan.planVersions"
          :key="planVersion.identifier"
          class="flex items-center justify-between p-4 my-4 border border-gray-200 rounded"
          :class="{ 'border-primary-100': planVersion.identifier == currentPlan.defaultVersion.identifier }"
        >
          <div>{{ planVersion.version }}</div>
          <div class="flex items-center">
            <TrashIcon
              class="w-6 h-6 ml-auto cursor-pointer text-grey-200 hover:text-primary"
              @click="deletePlanVersion(planVersion)"
            />
          </div>
        </div>
      </div>
    </template>
    <PluttoLoader
      v-else-if="loading"
    />
  </main>
</template>

<script>
import { mapState } from 'vuex';
import { TrashIcon } from '@heroicons/vue/outline';
import PluttoHeader from '../components/plutto-header';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoHeader, PluttoLoader, TrashIcon },
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
  methods: {
    createPlanVersion() {
      this.$store.dispatch('CREATE_PLAN_VERSION', { planId: this.currentPlan.id, planVersion: this.newPlanVersion });
    },
    deletePlanVersion(planVersion) {
      this.$store.dispatch('DESTROY_PLAN_VERSION', { planId: this.currentPlan.id, planVersion });
    },
  },
};
</script>

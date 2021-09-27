<template>
  <main>
    <template v-if="currentPlan">
      <PluttoHeader
        title="Plan details"
        :show-back-button="true"
      />
      <div class="px-6 mt-6">
        <div class="text-xl">
          {{ currentPlan.name }} ({{ currentPlan.currency }})
          {{ currentPlan.countryIsoCode ? ` - ${formatCountry(currentPlan.countryIsoCode, { withFlag: true })}` : '' }}
        </div>
        <div class="mt-4 text-sm text-gray-200 md:px-6">
          <div class="flex items-center">
            <span class="mr-4 plutto-icon">date_range</span><span>Bills at <u>{{ currentPlan.billsAt }}</u> of period</span>
          </div>
          <div
            v-if="currentPlan.billingPeriodDuration"
            class="flex items-center mt-2"
          >
            <span class="mr-4 plutto-icon">autorenew</span>
            <span>
              Bills every <u>{{ humanizedDuration(currentPlan.billingPeriodDuration, { removePrefix: true }) }}</u>
            </span>
          </div>
        </div>
        <div class="flex items-center justify-between my-8">
          <div class="text-lg text-gray-50">
            Versions:
          </div>
          <button
            class="btn btn--filled"
            @click="showNewPlanVersionForm = true"
          >
            New version
          </button>
        </div>
        <PlanVersion
          v-for="planVersion in currentPlan.planVersions"
          :key="planVersion.id"
          :plan-version="planVersion"
          :is-default-version="planVersion.id == currentPlan.defaultVersion.id"
          class="p-4 my-4 border border-gray-200 rounded"
        />
      </div>
    </template>
    <PluttoLoader
      v-else-if="loading"
    />
    <PluttoSlideover
      :showing="showNewPlanVersionForm"
      @close="showNewPlanVersionForm = false"
    >
      <NewPlanVersionForm
        @created-plan-version="planVersion => showNewPlanVersionForm = false"
        :create-plan="false"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PlanVersion from '@/components/plan-version';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import NewPlanVersionForm from '@/components/forms/new-plan-version-form';

export default {
  components: { PluttoHeader, PluttoLoader, PlanVersion, PluttoSlideover, NewPlanVersionForm },
  data() {
    return {
      newPlanVersion: {
        temp: 'value',
      },
      showNewPlanVersionForm: false,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PLAN', this.$route.params.id);
    if (!this.meters) await this.$store.dispatch('GET_METERS');
  },
  computed: {
    ...mapState({
      loading: state => state.plans.loading,
      currentPlan: state => state.plans.currentPlan,
      meters: state => state.meters.meters,
    }),
  },
};
</script>

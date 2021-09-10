<template>
  <div class="relative flex flex-col border border-gray-300 rounded">
    <div class="flex-1 px-4 pt-6">
      <div class="text-xl">
        {{ plan.name }}
        <span
          class="absolute top-0 right-0 px-4 ml-4 border-b border-l border-gray-300 rounded-bl text-primary text-2xs"
        >{{ plan.currency }}</span>
      </div>
      <PluttoCopyableDiv
        class="text-gray-100 text-2xs"
        :value="plan.id"
      />
      <div class="pr-2 mt-4 text-sm text-gray-200 md:px-6">
        <div class="flex items-center">
          <span class="mr-4 plutto-icon">date_range</span><span>Bills at <u>{{ plan.billsAt }}</u> of period</span>
        </div>
        <div
          v-if="plan.billingPeriodDuration"
          class="flex items-center mt-2"
        >
          <span class="mr-4 plutto-icon">autorenew</span>
          <span>Bills every <u>{{ humanizedDuration(plan.billingPeriodDuration, { removePrefix: true }) }}</u></span>
        </div>
        <div
          v-if="plan.defaultVersion"
          class="flex items-center mt-2"
        >
          <span class="mr-4 plutto-icon">monetization_on</span><span><u>{{ priceLogicSummary(plan.defaultVersion.priceLogics) }}</u></span>
        </div>
      </div>
    </div>
    <div
      @click="$router.push({ name: 'plan', params: { id: plan.id } })"
      class="px-4 py-2 text-xs text-right text-gray-200 cursor-pointer"
    >
      Details
    </div>
  </div>
</template>

<script>
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: { PluttoCopyableDiv },
  props: {
    plan: {
      type: Object,
      required: true,
    },
  },
  methods: {
    priceLogicSummary(priceLogics) {
      return priceLogics.map((pl) => this.$t(`message.priceLogics.types.${pl.type}`)).join(' + ');
    },
  },
};
</script>

<style lang="scss" scoped>
.plutto-icon {
  font-family: 'Material Icons';
}
</style>

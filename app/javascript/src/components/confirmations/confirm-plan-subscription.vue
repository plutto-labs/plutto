<template>
  <div class="w-full">
    <div class="px-4 md:px-8">
      <h1 class="text-xl md:text-2xl">
        You're about to subscribe {{ customer.name }} to {{ plan.name }}
      </h1>
      <template v-if="customer.activePlanSubscription">
        <div
          class="flex items-center px-4 py-6 my-6 border-2 rounded-lg border-danger-dark bg-danger-light text-danger-dark"
          v-if="subscribedToSameVersion"
        >
          <span class="mr-4 text-2xl md:mr-6 md:text-5xl plutto-icon">error</span>
          <span>
            {{ customer.name }} is already subscribed to plan "{{ customer.activePlanSubscription.planName }}"!
          </span>
        </div>
        <template v-else>
          <div class="flex items-center px-4 py-6 my-6 border-2 rounded-lg border-warning">
            <span class="mr-4 text-2xl md:mr-6 md:text-5xl plutto-icon text-warning">warning</span>
            <div class="text-xs text-gray-300 md:text-base">
              {{ customer.name }} is already subscribed to plan "{{ customer.activePlanSubscription.planName }}"!
              <div v-if="subscribedToSamePlan">
                However there's <b>another version</b> available for the plan.<br><br>
              </div>
              <div class="text-base font-bold md:text-lg text-gray-50">
                Do you want to switch to {{ subscribedToSamePlan ? 'the newer version' : 'this Plan' }}?
              </div>
            </div>
          </div>
          <ul class="list-disc">
            <div class="my-2">
              When you switch plan for a customer:
            </div>
            <span class="ml-4 text-xs text-gray-300 md:text-sm list-item">The current subscription is terminated</span>
            <span class="ml-8 text-xs text-gray-300 list-item">An invoice will be generated with current usage</span>
            <span class="mt-2 ml-4 text-xs text-gray-300 md:text-sm list-item">A new subscription will be created to the "{{ plan.name }}" plan</span>
            <span class="ml-8 text-xs text-gray-300 list-item">
              Next invoice will be
              <b class="text-primary-300"><span v-if="plan.billsAt === 'end'"> in {{ humanizedDuration(plan.billingPeriodDuration) }}</span>
                <span v-else>now!</span></b>
            </span>
          </ul>
        </template>
      </template>
      <template v-else>
        <ul class="list-disc">
          <div class="my-2">
            When you subscribe a customer to a plan:
          </div>
          <span class="mt-2 ml-4 text-sm text-gray-300 list-item">A new subscription will be created to the "{{ plan.name }}" plan</span>
          <span class="ml-8 text-xs text-gray-300 list-item">
            Next invoice will be
            <b class="text-primary-300"><span v-if="plan.billsAt === 'end'"> in {{ humanizedDuration(plan.billingPeriodDuration) }}</span>
              <span v-else>now!</span></b>
          </span>
        </ul>
      </template>
    </div>
    <div class="flex justify-center my-8">
      <button
        class="mx-4 btn btn--big btn--dismiss"
        @click="$emit('cancel')"
      >
        Cancel
      </button>
      <button
        class="mx-4 btn btn--big"
        @click="$emit('confirm')"
        v-if="!subscribedToSameVersion"
      >
        Confirm
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    customer: {
      type: Object,
      required: true,
    },
    plan: {
      type: Object,
      required: true,
    },
  },
  computed: {
    subscribedToSameVersion() {
      return this.customer.activePlanSubscription &&
        this.customer.activePlanSubscription.planVersionId === this.plan.defaultVersion.id;
    },
    subscribedToSamePlan() {
      return this.customer.activePlanSubscription &&
        this.customer.activePlanSubscription.planId === this.plan.id;
    },
  },
};
</script>

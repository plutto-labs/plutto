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
            <div class="text-xs text-gray-600 md:text-base">
              {{ customer.name }} is already subscribed to plan "{{ customer.activePlanSubscription.planName }}"!
              <div v-if="subscribedToSamePlan">
                However there's <b>another version</b> available for the plan.<br><br>
              </div>
              <div class="text-base font-bold md:text-lg text-gray-900">
                Do you want to switch to {{ subscribedToSamePlan ? 'the newer version' : 'this Plan' }}?
              </div>
            </div>
          </div>
          <ul class="list-disc">
            <div class="my-2">
              When you switch plan for a customer:
            </div>
            <span class="ml-4 text-xs text-gray-600 md:text-sm list-item">The current subscription is terminated</span>
            <span class="ml-8 text-xs text-gray-600 list-item">An invoice will be generated with current usage</span>
            <span class="mt-2 ml-4 text-xs text-gray-600 md:text-sm list-item">A new subscription will be created to the "{{ plan.name }}" plan</span>
            <span class="ml-8 text-xs text-gray-600 list-item">
              Next invoice will be
              <b class="text-melon-300"><span v-if="plan.billsAt === 'end'"> in {{ humanizedDuration(plan.billingPeriodDuration) }}</span>
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
          <span class="mt-2 ml-4 text-sm text-gray-600 list-item">A new subscription will be created to the "{{ plan.name }}" plan</span>
          <span class="ml-8 text-xs text-gray-600 list-item">
            Next invoice will be
            <b class="text-melon-300"><span v-if="plan.billsAt === 'end'"> in {{ humanizedDuration(plan.billingPeriodDuration) }}</span>
              <span v-else>now!</span></b>
          </span>
        </ul>
      </template>
      <div
        v-if="!subscribedToSameVersion"
        class="flex items-center justify-between mt-8"
      >
        <div>
          <p class="mr-4">
            Trial until:
          </p>
          <p class="text-xs text-gray-600">
            (optional)
          </p>
        </div>
        <div>
          <DatePicker
            v-model="trialDate"
            :model-config="modelConfig"
            :attributes="attrs"
            :min-date="new Date()"
            :popover="{ visibility: 'focus' }"
            :transition="'none'"
            class="w-96"
          >
            <template #default="{ inputValue, inputEvents }">
              <div class="plutto-input">
                <input
                  class="bg-gray-200 border-gray-400 plutto-input__input"
                  :value="inputValue"
                  v-on="inputEvents"
                >
              </div>
            </template>
          </DatePicker>
          <p
            v-if="trialDate"
            class="absolute text-xs text-gray-600"
          >
            {{ `subscription will start charging ${daysFromDate(trialDate)}` }}
          </p>
        </div>
      </div>
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
        @click="$emit('confirm', trialDate)"
        v-if="!subscribedToSameVersion"
      >
        Confirm
      </button>
    </div>
  </div>
</template>

<script>
import { DatePicker } from 'v-calendar';

export default {
  components: { DatePicker },
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
  data() {
    return {
      trialDate: null,
      modelConfig: {
        type: 'string',
        mask: 'YYYY-MM-DD',
      },
      attrs: [
        {
          key: 'today',
          highlight: {
            color: 'purple',
            fillMode: 'outline',
          },
          dates: new Date(),
        },
      ],
    };
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

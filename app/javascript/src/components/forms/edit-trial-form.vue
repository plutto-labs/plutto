<template>
  <div class="w-full">
    <div class="px-4 md:px-8">
      <h1 class="text-xl md:text-2xl">
        Edit Trial Date
      </h1>
      <div class="flex items-center justify-between mt-8">
        <div class="">
          <p class="mr-4">
            New date:
          </p>
        </div>
        <div>
          <DatePicker
            v-model="newDate"
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
            v-if="newDate"
            class="absolute text-xs text-gray-600"
          >
            {{ `subscription will start charging ${daysFromDate(newDate)}` }}
          </p>
        </div>
      </div>
      <div class="flex justify-center gap-4 my-8">
        <button
          class="btn btn--cancel"
          @click="showConfirmEndTrial = true"
        >
          Start subscription
        </button>
        <button
          class="btn"
          @click="editTrial({ trialFinishesAt: newDate })"
        >
          Save new date
        </button>
      </div>
    </div>
    <PluttoModal
      :showing="showConfirmEndTrial"
      @close="showConfirmEndTrial = false"
    >
      <ConfirmEndTrial
        @confirm="showConfirmEndTrial = false; editTrial({ startSubscription: true })"
        @cancel="showConfirmEndTrial = false"
      />
    </PluttoModal>
  </div>
</template>

<script>
import { DatePicker } from 'v-calendar';
import PluttoModal from '@/components/plutto-modal';
import ConfirmEndTrial from '@/components/confirmations/confirm-end-trial';

export default {
  components: { DatePicker, PluttoModal, ConfirmEndTrial },
  props: {
    subscription: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      showConfirmEndTrial: false,
      newDate: null,
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
  methods: {
    editTrial(body) {
      this.$store.dispatch('EDIT_SUBSCRIPTION_TRIAL', { id: this.subscription.id, ...body })
        .then(this.$emit('edited-trial'));
    },
  },
};
</script>

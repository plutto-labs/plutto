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
                  class="bg-gray-700 border-gray-500 plutto-input__input"
                  :value="inputValue"
                  v-on="inputEvents"
                >
              </div>
            </template>
          </DatePicker>
          <p
            v-if="newDate"
            class="absolute text-xs text-gray-300"
          >
            {{ `subscription will start charging ${daysFromDate(newDate)}` }}
          </p>
        </div>
      </div>
      <div class="flex justify-center gap-4 my-8">
        <button class="btn btn--cancel">
          Start subscription
        </button>
        <button class="btn">
          Save new date
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { DatePicker } from 'v-calendar';

export default {
  components: { DatePicker },
  props: {
    planSubscription: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
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
};
</script>

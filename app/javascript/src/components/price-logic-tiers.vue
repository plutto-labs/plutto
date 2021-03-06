<template>
  <div class="w-full">
    <div class="flex">
      <div
        class="flex items-center justify-end w-full mr-8 text-sm cursor-pointer text text-primary"
        @click="addTier"
        v-if="edit"
      >
        <span class="plutto-icon">add</span>
        <div>add tier</div>
      </div>
    </div>
    <table
      class="w-full divide-y divide-gray-700"
      v-if="tiers"
    >
      <thead class="bg-gray-200">
        <tr>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase rounded-tl-lg text-gray-900"
          />
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase text-gray-900"
          >
            First unit
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase text-gray-900"
          >
            Last unit
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase rounded-tr-lg text-gray-900"
          >
            {{ measurementText }}
          </th>
          <th class="bg-gray-200" />
        </tr>
      </thead>
      <tbody class="bg-gray-50">
        <tr
          class="border-t-4 border-gray-50"
          v-for="(tier, index) in tiers"
          :key="index"
        >
          <td class="px-6 py-4 bg-gray-200 whitespace-nowrap">
            <div class="text-sm font-medium text-gray-900">
              {{ index === 0 ? firstRowText : otherRowsText }}
            </div>
          </td>
          <td class="px-6 py-4 whitespace-nowrap">
            <div class="text-sm font-medium text-gray-9000">
              {{ tierLowerLimit(index) }}
            </div>
          </td>
          <td
            class="whitespace-nowrap"
            v-if="index !== tiers.length - 1"
          >
            <div class="flex items-end justify-center">
              <Field
                :as="edit ? 'input' : 'div'"
                :name="`${priceLogicIndex}-tier-${index}`"
                :rules="`required|minValue:${tierLowerLimit(index)}`"
                type="number"
                class="flex items-center px-6 bg-gray-50 border border-gray-100 rounded-lg plutto-input"
                @input="changeTierUpperLimit($event.target.value, index)"
                :value="tier.upperLimit"
              >
                {{ tier.upperLimit }}
              </Field>
              <ErrorMessage
                as="p"
                class="absolute text-xs text-danger-light"
                :name="`${priceLogicIndex}-tier-${index}`"
                v-slot="{ message }"
              >
                <p v-if="message">
                  {{ `Must be greater than ${tierLowerLimit(index)}` }}
                </p>
              </ErrorMessage>
            </div>
          </td>
          <td
            class="px-6 py-4 whitespace-nowrap"
            v-else
          >
            <span class="text-gray-600 plutto-icon">
              all_inclusive
            </span>
          </td>
          <td class="whitespace-nowrap">
            <div class="flex">
              <p class="pl-6 my-auto text-sm font-medium">
                {{ currency }}
              </p>
              <div class="flex items-end justify-center">
                <Field
                  :as="edit ? 'input' : 'div'"
                  :name="`${priceLogicIndex}-price-${index}`"
                  rules="required"
                  type="number"
                  class="flex items-center pl-2 pr-6 bg-gray-50 border border-gray-100 rounded-lg plutto-input"
                  :value="tier.price"
                  @input="e => tier.price = e.target.value"
                  step="0.01"
                  min="0"
                >
                  {{ tier.price }}
                </Field>
                <ErrorMessage
                  as="p"
                  class="absolute text-xs text-danger-light"
                  :name="`${priceLogicIndex}-price-${index}`"
                  v-slot="{ message }"
                >
                  <p v-if="message">
                    Required
                  </p>
                </ErrorMessage>
              </div>
            </div>
          </td>
          <td class="bg-gray-50">
            <span
              class="bg-gray-50 cursor-pointer plutto-icon text-primary"
              @click="deleteTier(index)"
              v-if="edit && index !== tiers.length - 1 && index !== 0"
            >
              close
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { Field, ErrorMessage } from 'vee-validate';

export default {
  components: { Field, ErrorMessage },
  props: {
    firstRowText: {
      type: String,
      default: 'Total of units',
    },
    otherRowsText: {
      type: String,
      default: 'Total of units',
    },
    measurementText: {
      type: String,
      default: 'Per unit',
    },
    modelValue: {
      type: Array,
      default: null,
    },
    edit: {
      type: Boolean,
      default: true,
    },
    priceLogicIndex: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      lastTierPrice: null,
      currency: '$',
      defaultTiers: [{ upperLimit: 1, price: 0 }, { upperLimit: 3, price: 0 }],
    };
  },
  beforeMount() {
    if (!this.modelValue) this.tiers = this.defaultTiers;
  },
  computed: {
    lastTierLowerLimit() {
      return this.tiers.slice(-1)[0].upperLimit + 1;
    },
    tiers: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
  },
  methods: {
    addTier() {
      this.tiers = [...this.tiers, { upperLimit: this.lastTierLowerLimit, price: 0 }];
    },
    deleteTier(index) {
      if (this.edit) {
        this.tiers.splice(index, 1);
      }
    },
    /* eslint-disable no-magic-numbers */
    changeTierUpperLimit(val, index) {
      const newValue = Number(val);
      this.tiers[index].upperLimit = newValue;
      if (index < this.tiers.length - 1 && this.tiers[index + 1].upperLimit <= newValue) {
        this.changeTierUpperLimit(newValue + 2, index + 1);
      }
    },
    tierLowerLimit(index) {
      return index === 0 ? 1 : this.tiers[index - 1].upperLimit + 1;
    },
  },
};
</script>

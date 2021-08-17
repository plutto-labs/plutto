<template>
  <div class="inline-block">
    <div class="flex">
      <div
        class="flex items-center ml-auto text-sm cursor-pointer mr-7 text text-primary"
        @click="addTier"
      >
        <span class="plutto-icon">
          add
        </span>
        <button>
          add tier
        </button>
      </div>
    </div>
    <table class="max-w-xl divide-y divide-gray-200">
      <thead class="bg-gray-700">
        <tr>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase rounded-tl-lg text-gray-50"
          />
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase text-gray-50"
          >
            First unit
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase text-gray-50"
          >
            Last unit
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase rounded-tr-lg text-gray-50"
          >
            Per unit
          </th>
          <th class="bg-gray-900" />
        </tr>
      </thead>
      <tbody
        class="bg-gray-800"
      >
        <tr
          class="border-t-4 border-gray-900"
          v-for="(tier, index) in tiers"
          :key="index"
        >
          <td class="px-6 py-4 bg-gray-700 whitespace-nowrap">
            <div class="text-sm font-medium text-gray-50">
              {{ index === 0 ? firstRowText : otherRowsText }}
            </div>
          </td>
          <td class="px-6 py-4 whitespace-nowrap">
            <div class="text-sm font-medium text-gray-400">
              {{ tierLowerLimit(index) }}
            </div>
          </td>
          <td class="whitespace-nowrap">
            <div class="flex items-end justify-center">
              <input
                type="number"
                class="px-6 bg-gray-800 border border-gray-800 rounded-lg focus:outline-none focus:ring-gray-800 focus:border-gray-800 plutto-input"
                v-model.number="tier.upperLimit"
              >
              <span
                v-if="invalidTierRange(tierLowerLimit(index), tier.upperLimit, index)"
                class="absolute text-xs break-words text-danger"
              >
                {{ `must be greater than ${tierLowerLimit(index)}` }}
              </span>
            </div>
          </td>
          <td class="whitespace-nowrap">
            <div class="flex">
              <p class="pl-6 my-auto text-sm font-medium">
                {{ currency }}
              </p>
              <div class="flex items-end justify-center">
                <input
                  type="number"
                  class="pl-2 pr-6 bg-gray-800 border border-gray-800 rounded-lg focus:outline-none focus:ring-gray-800 focus:border-gray-800 plutto-input"
                  v-model.number="tier.price"
                  placeholder="0"
                  @blur="processInputError(tier.price, index)"
                  @input="processInputError(tier.price, index)"
                >
                <span
                  v-if="errors.price[index]"
                  class="absolute text-xs text-danger break-word"
                >
                  required
                </span>
              </div>
            </div>
          </td>
          <td class="bg-gray-900">
            <span
              class="cursor-pointer plutto-icon text-primary"
              :class="index === 0 && 'invisible'"
              @click="deleteTier(index)"
            >
              close
            </span>
          </td>
        </tr>
        <tr class="border-t-4 border-gray-900">
          <td class="px-6 py-4 bg-gray-700 rounded-bl-lg whitespace-nowrap">
            <div class="text-sm font-medium text-gray-50">
              {{ otherRowsText }}
            </div>
          </td>
          <td class="px-6 py-4 whitespace-nowrap">
            <div class="text-sm font-medium text-gray-400">
              {{ lastTierLowerLimit }}
            </div>
          </td>
          <td class="px-6 py-4 whitespace-nowrap">
            <span class="text-gray-400 plutto-icon">
              all_inclusive
            </span>
          </td>
          <td class="rounded-br-lg whitespace-nowrap">
            <div class="flex">
              <p class="pl-6 my-auto text-sm font-medium">
                {{ currency }}
              </p>
              <div class="flex items-end justify-center">
                <input
                  type="number"
                  class="pl-2 pr-6 bg-gray-800 border border-gray-800 rounded-lg focus:outline-none focus:ring-gray-800 focus:border-gray-800 plutto-input"
                  v-model.number="lastTierPrice"
                  placeholder="0"
                  @blur="processInputError(lastTierPrice, 'last')"
                  @input="processInputError(lastTierPrice, 'last')"
                >
                <span
                  v-if="errors.price['last']"
                  class="absolute text-xs text-danger break-word"
                >
                  required
                </span>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  props: {
    firstRowText: {
      type: String,
      default: 'Total of units',
    },
    otherRowsText: {
      type: String,
      default: 'Total of units',
    },
  },
  data() {
    return {
      tiers: [{ 'upperLimit': 1, 'price': null }],
      lastTierPrice: null,
      currency: '$',
      errors: { price: {}, range: {} },
    };
  },
  computed: {
    lastTierLowerLimit() {
      return this.tiers.slice(-1)[0].upperLimit + 1;
    },
  },
  methods: {
    addTier() {
      this.tiers.push({ 'upperLimit': this.lastTierLowerLimit + 1, 'price': null });
    },
    deleteTier(index) {
      this.tiers.splice(index, 1);
    },
    tierLowerLimit(index) {
      return index === 0 ? 0 : this.tiers[index - 1].upperLimit + 1;
    },
    invalidTierRange(from, to, index) {
      const invalid = from >= to;
      if (invalid) {
        this.errors.range[index] = true;
      } else {
        delete this.errors.range[index];
      }

      return invalid;
    },
    processInputError(price, index) {
      if (price) {
        delete this.errors.price[index];
      } else {
        this.errors.price[index] = true;
      }
    },
    isValid() {
      this.tiers.forEach((element, index) => {
        if (!element.price) this.errors.price[index] = true;
      });
      if (!this.lastTierPrice) this.errors.price.last = true;

      return Object.keys(this.errors.price).length === 0 && Object.keys(this.errors.range).length === 0;
    },
  },
};
</script>

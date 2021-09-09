<template>
  <div>
    <div class="relative flex items-center justify-between pr-10">
      <div>
        <div class="flex items-center">
          {{ planVersion.version }}
          <PluttoCopyableDiv
            class="ml-2 text-xs text-gray-100"
            :value="planVersion.id"
          />
          <span class="flex items-center text-gray-100">
            <span class="ml-6 mr-2 plutto-icon">group</span>
            <span>{{ planVersion.subscribedUsers }}</span>
          </span>
        </div>
        <div
          class="text-sm text-gray-300"
          v-for="priceLogic in planVersion.priceLogics"
          :key="priceLogic.id"
        >
          <span>{{ $t(`message.priceLogics.types.${priceLogic.type}`) }}</span>
          <span v-if="!priceLogic.tiers"> | ${{ priceLogic.price }}</span>
          <template v-else>
            | <span
              v-for="tier in priceLogic.tiers"
              :key="tier.id"
            > ${{ tier.price }} \</span>
          </template>
          <span v-if="priceLogic.meterId"> @ {{ meterName(priceLogic.meterId) || priceLogic.meterId }}</span>
          <span v-if="priceLogic.meterId && priceLogic.meterCountMethod"> | {{ priceLogic.meterCountMethod }}</span>
        </div>
      </div>
      <span
        v-if="isDefaultVersion"
        class="ml-4 plutto-tag"
      >Default version</span>
      <span
        class="absolute top-0 right-0 flex items-center h-full text-xl cursor-pointer plutto-icon"
        :class="{ 'transform rotate-180': expanded }"
        @click="expanded = !expanded"
      >
        expand_more
      </span>
    </div>
    <template v-if="expanded">
      <div class="w-full m-auto space-y-8 divide-y divide-gray-200 md:max-w-xl">
        <div class="mt-8 mb-4 text-lg">
          Price Logics
        </div>
        <PriceLogics
          :model-value="planVersion.priceLogics"
          :edit="false"
        />
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PriceLogics from '@/components/price-logics';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: { PriceLogics, PluttoCopyableDiv },
  props: {
    planVersion: {
      type: Object,
      required: true,
    },
    isDefaultVersion: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      expanded: false,
    };
  },
  methods: {
    meterName(meterId) {
      return this.meters && this.meters.find((meter) => meter.id === meterId).name;
    },
  },
  computed: {
    ...mapState({
      loading: state => state.meters.loading,
      meters: state => state.meters.meters,
    }),
  },
};
</script>

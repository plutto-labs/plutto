<template>
  <div>
    <div class="flex items-center justify-between">
      <div>
        {{ planVersion.version }}
        <span
          v-if="isDefaultVersion"
          class="ml-4 plutto-tag"
        >Default version</span>
      </div>
      <span
        class="text-xl cursor-pointer plutto-icon"
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
import PriceLogics from '@/components/price-logics';

export default {
  components: { PriceLogics },
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
};
</script>

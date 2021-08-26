<template>
  <div class="flex items-center w-full px-4 py-4 border border-gray-300 rounded">
    <div class="flex-1">
      <div class="flex items-center text-lg">
        {{ plan.name }}
        <span
          class="ml-4 plutto-tag plutto-tag--green text-2xs"
        >{{ plan.currency }}</span>
      </div>
      <div class="flex justify-between w-full">
        <div class="justify-between flex-1 pr-6 md:px-6 md:flex">
          <div>
            <div class="text-sm text-gray-100">
              Active version: {{ plan.defaultVersion && plan.defaultVersion.version }}
            </div>
            <div class="text-xs text-gray-300">
              {{ plan.defaultVersion && plan.defaultVersion.identifier }}
            </div>
          </div>
          <div class="flex items-center h-full">
            <div
              class="flex items-center h-full"
              v-for="(priceLogic, index) in plan.defaultVersion && plan.defaultVersion.priceLogics"
              :key="priceLogic.id"
            >
              <div class="flex items-center h-full px-4 text-xs border border-gray-700">
                {{ $t(`message.priceLogics.initials.${priceLogic.type}`) }}
              </div>
              <span
                class="mx-2"
                v-if="index !== plan.defaultVersion.priceLogics.length - 1"
              >+</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div
      @click="$router.push({ name: 'plan', params: { id: plan.id } })"
      class="flex items-center justify-center w-8 h-full border-l border-gray-300 cursor-pointer md:w-12"
    >
      <span class="text-xl md:text-3xl plutto-icon">chevron_right</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    plan: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style lang="scss" scoped>
.plutto-icon {
  font-family: 'Material Icons';
}
</style>

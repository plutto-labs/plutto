<template>
  <div class="flex items-center justify-between h-10">
    <div
      v-for="step in steps"
      :key="step"
    >
      <div
        class="relative w-4 h-4 rounded-full"
        :class="{
          'bg-success-light': step < currentStep,
          'bg-primary': step === currentStep,
          'bg-gray-700': step > currentStep,
          'w-6 h-6': step === 1 || step == steps,
        }"
      >
        <span
          class="absolute transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2"
          v-if="step < currentStep"
        >&#10003;</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    steps: {
      type: Number,
      default: 3,
    },
    currentStep: {
      type: Number,
      default: 1,
    },
  },
};
</script>

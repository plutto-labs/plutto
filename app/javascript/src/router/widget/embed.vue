<template>
  <main>
    <h2 class="text-2xl">
      Design
    </h2>
    <div class="flex flex-wrap gap-8 mt-4">
      <div
        v-for="(color, index) in colorInputs"
        :key="index"
      >
        <p class="text-sm text-temporary-gray-500">
          {{ color.label }}
        </p>
        <PluttoColorInput
          v-model="color.value"
        />
      </div>
    </div>
  </main>
</template>
<script>
import PluttoColorInput from '@/components/widget/plutto-color-input';

export default {
  components: {
    PluttoColorInput,
  },
  data() {
    return {
      colorInputs: [
        { key: 'primaryBackground', label: 'Primary background', value: '#FFFFFF' },
        { key: 'secondaryBackground', label: 'Secondary background', value: '#F3F3F3' },
        { key: 'primaryText', label: 'Primary text', value: '#304378' },
        { key: 'secondaryText', label: 'Secondary text', value: '#677D96' },
        { key: 'button', label: 'Button', value: '#E06B71' },
        { key: 'buttonText', label: 'Button text', value: '#FFFFFF' },
      ],
    };
  },
};
</script>

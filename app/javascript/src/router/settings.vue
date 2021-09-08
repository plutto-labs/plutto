<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1"
        title="Settings"
        :options="options"
        :selected-option="selectedOption"
        @optionClicked="changeOption"
      />
      <component
        class="col-span-3 col start-2 md:col-span-5"
        :is="selectedOption"
      />
    </div>
  </main>
</template>

<script>
import PluttoSideOptions from '@/components/plutto-side-options';
import ApiKeys from '@/router/api-keys';
import Meters from '@/router/meters';

export default {
  components: { PluttoSideOptions, ApiKeys, Meters },
  data() {
    return {
      options: [{ label: 'Meters', value: 'Meters' }, { label: 'API Keys', value: 'ApiKeys' }],
      selectedOption: 'Meters',
    };
  },
  methods: {
    changeOption(option) {
      this.selectedOption = option;
    },
  },
};
</script>

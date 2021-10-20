<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1"
        title="Settings"
        :options="options"
        :selected-option="selectedOption"
        @optionClicked="option => $route.name === option ? null : $router.push({ name: option })"
      />
      <component
        class="col-span-3 col start-2 md:col-span-5"
        :is="components[selectedOption]"
      />
    </div>
  </main>
</template>

<script>
import ApiKeys from '@/router/api-keys';
import PluttoSideOptions from '@/components/plutto-side-options';

export default {
  components: { PluttoSideOptions, ApiKeys },
  props: {
    selectedOption: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      options: [
        { label: 'Api Keys', value: 'api-keys' },
      ],
      components: {
        'api-keys': 'ApiKeys',
      },
    };
  },
};
</script>

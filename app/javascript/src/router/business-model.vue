<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1"
        title="Business Model"
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
import Meters from '@/router/meters';
import Plans from '@/router/plans';
import PluttoSideOptions from '@/components/plutto-side-options';
import Products from '@/router/products';

export default {
  components: { PluttoSideOptions, Plans, Meters, Products },
  props: {
    selectedOption: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      options: [
        { label: 'Plans', value: 'plans' },
        { label: 'Products', value: 'products' },
        { label: 'Meters', value: 'meters' },
      ],
      components: {
        'plans': 'Plans',
        'products': 'Products',
        'meters': 'Meters',
      },
    };
  },
};
</script>

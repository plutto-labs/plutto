<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1 mt-20"
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
import PermissionGroups from '@/router/permission-groups';
import PluttoSideOptions from '@/components/plutto-side-options';
import Products from '@/router/products';

export default {
  components: { PluttoSideOptions, PermissionGroups, Meters, Products },
  props: {
    selectedOption: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      options: [
        { label: 'Permission Groups', value: 'permission-groups' },
        { label: 'Products', value: 'products' },
        { label: 'Meters', value: 'meters' },
      ],
      components: {
        'permission-groups': 'PermissionGroups',
        'products': 'Products',
        'meters': 'Meters',
      },
    };
  },
};
</script>

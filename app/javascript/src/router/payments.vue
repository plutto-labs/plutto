<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1"
        title="Payments"
        :options="viewOptions"
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
import Invoices from '@/router/invoices';
import Transactions from '@/router/transactions';

export default {
  components: { PluttoSideOptions, Invoices, Transactions },
  data() {
    return {
      viewOptions: [
        { label: 'Invoices', value: 'Invoices' },
        { label: 'Transactions', value: 'Transactions' },
      ],
      selectedOption: 'Invoices',
    };
  },
  methods: {
    changeOption(option) {
      this.selectedOption = option;
    },
  },
};
</script>

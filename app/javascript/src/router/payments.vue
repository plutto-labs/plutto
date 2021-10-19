<template>
  <main>
    <div class="grid grid-cols-4 md:grid-cols-6">
      <PluttoSideOptions
        class="col-span-1"
        title="Payments"
        :options="viewOptions"
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
import PluttoSideOptions from '@/components/plutto-side-options';
import Invoices from '@/router/invoices';
import Transactions from '@/router/transactions';
import PaymentSettings from '@/router/payment-settings';

export default {
  components: { PluttoSideOptions, Invoices, Transactions, PaymentSettings },
  props: {
    selectedOption: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      viewOptions: [
        { label: 'Invoices', value: 'invoices' },
        { label: 'Transactions', value: 'transactions' },
        { label: 'Settings', value: 'payment-settings' },
      ],
      components: {
        'invoices': 'Invoices',
        'transactions': 'Transactions',
        'payment-settings': 'PaymentSettings',
      },
    };
  },
};
</script>

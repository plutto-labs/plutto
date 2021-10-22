<template>
  <div>
    <template v-if="!showInvoice">
      <div>
        <h2 class="mb-4">
          Transactions
        </h2>
        <div>
          <PluttoTable
            :headers="headers"
            :rows="tableRows"
            :loading="loading"
            @show-clicked="(payment) => openInvoiceSlideover(payment.invoiceId)"
          />
        </div>
      </div>
    </template>
    <PluttoSlideover
      :showing="showInvoice"
      @close="showInvoice = false"
    >
      <div class="w-full pb-8 mx-auto mt-20 space-y-8 divide-y divide-gray-200 md:max-w-xl">
        <Invoice
          :invoice-id="invoiceId"
          class="pb-8 mx-auto"
        />
      </div>
    </PluttoSlideover>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoSlideover from '@/components/plutto-slideover';
import Invoice from '@/components/invoice';

export default {
  components: { PluttoTable, PluttoSlideover, Invoice },
  data() {
    return {
      showInvoice: false,
      invoiceId: null,
      headers: [
        {
          title: 'customer',
          type: 'twoLinesText',
          bigText: 'customerName',
          smallText: 'customerEmail',
        },
        {
          title: 'gateway',
          type: 'twoLinesText',
          bigText: 'gateway',
          smallText: 'idInGateway',
        },
        {
          title: 'paymentMethod',
          type: 'twoLinesText',
          bigText: 'paymentCategory',
          smallText: 'paymentDescription',
        },
        {
          title: 'subtotal',
          type: 'currency',
        },
        {
          title: 'paidAt',
          type: 'date',
        },
        {
          title: 'none',
          type: 'action',
          action: 'show',
        },
      ],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.payments.loading,
      payments: state => state.payments.payments,
    }),
    tableRows() {
      return this.payments.map(payment => (
        {
          customerName: payment.invoice.customerName, gateway: payment.gateway, idInGateway: payment.idInGateway,
          customerEmail: payment.invoice.customerEmail, paymentCategory: payment.paymentMethod.category,
          paidAt: payment.createdAt, subtotal: payment.invoice.subtotal, invoiceId: payment.invoice.id,
          paymentDescription: `${payment.paymentMethod.cardBrand} ${payment.paymentMethod.last4Digits}`,
        }
      ));
    },
  },
  async mounted() {
    await this.$store.dispatch('GET_PAYMENTS');
  },
  methods: {
    openInvoiceSlideover(invoiceId) {
      this.showInvoice = true;
      this.invoiceId = invoiceId;
    },
  },
};
</script>

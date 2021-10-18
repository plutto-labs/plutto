<template>
  <div>
    <template v-if="!showInvoice">
      <div>
        <h2 class="mb-4">
          Invoices
        </h2>
        <div>
          <PluttoTable
            :headers="headers"
            :rows="invoices"
            :loading="loading"
            @show-clicked="(invoice) => openInvoiceSlideover(invoice.id)"
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
          bigText: 'customerEmail',
          smallText: 'customerName',
        },
        {
          title: 'status',
          type: 'tag',
          tags: {
            new: 'purple',
            posted: 'blue',
            paid: 'green',
            notPaid: 'red',
            voided: 'yellow',
          },
        },
        {
          title: 'subtotal',
          type: 'currency',
        },
        {
          title: 'currency',
          type: 'oneLineText',
        },
        {
          title: 'issueDate',
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
      loading: state => state.invoices.loading,
      invoices: state => state.invoices.invoices,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_INVOICES');
  },
  methods: {
    openInvoiceSlideover(invoiceId) {
      this.showInvoice = true;
      this.invoiceId = invoiceId;
    },
  },
};
</script>

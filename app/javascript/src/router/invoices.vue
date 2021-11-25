<template>
  <div>
    <template v-if="!showInvoice">
      <div>
        <h2 class="mb-4">
          Invoices
        </h2>
        <div class="my-4">
          Filter:
          <span
            v-for="status in Object.keys(statusToColors)"
            :key="status"
            @click="changeStatus(status)"
            class="px-2 py-1 mx-2 text-xs font-semibold leading-5 rounded cursor-pointer whitespace-nowrap"
            :class="[`tag-color--${statusToColors[status]}`, {
              'tag-color--gray': status !== selectedStatus
            }]"
          >{{ $t(`message.table.tags.${status}`) }}</span>
        </div>
        <div>
          <PluttoTable
            :headers="headers"
            :rows="invoices"
            :loading="loading"
            @show-clicked="(invoice) => openInvoiceSlideover(invoice.id)"
          />
          <PluttoPagination
            class="mt-6"
            v-if="totalPages > 1"
            :total-pages="totalPages"
            @change-page="(page) => changePage(page)"
          />
        </div>
      </div>
    </template>
    <PluttoSlideover
      :showing="showInvoice"
      @close="showInvoice = false"
    >
      <div class="w-full pb-8 mx-auto mt-20 space-y-8 divide-y divide-gray-700 md:max-w-xl">
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
import { decamelize } from 'humps';
import PluttoTable from '@/components/plutto-table';
import PluttoSlideover from '@/components/plutto-slideover';
import Invoice from '@/components/invoice';
import PluttoPagination from '@/components/plutto-pagination';

const STATUS_TO_COLORS = {
  created: 'purple',
  sent: 'blue',
  paid: 'green',
  notPaid: 'red',
  canceled: 'yellow',
};

export default {
  components: { PluttoTable, PluttoSlideover, Invoice, PluttoPagination },
  data() {
    return {
      showInvoice: false,
      invoiceId: null,
      statusToColors: STATUS_TO_COLORS,
      selectedStatus: 'created',
      headers: [
        {
          title: 'customer',
          type: 'twoLinesText',
          bigText: 'customerName',
          smallText: 'customerEmail',
        },
        {
          title: 'status',
          type: 'tag',
          tags: STATUS_TO_COLORS,
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
      totalPages: state => state.invoices.totalPages,
      page: state => state.invoices.page,
    }),
  },
  async beforeMount() {
    await this.getInvoices(this.selectedStatus);
  },
  methods: {
    openInvoiceSlideover(invoiceId) {
      this.showInvoice = true;
      this.invoiceId = invoiceId;
    },
    async getInvoices() {
      let query = `page=${this.page}&`;
      if (this.selectedStatus) query += `q[status_eq]=${decamelize(this.selectedStatus)}`;
      await this.$store.dispatch('GET_INVOICES', query);
      this.$router.push({ name: 'invoices', query: { query } });
    },
    changeStatus(status) {
      this.selectedStatus = this.selectedStatus === status ? null : status;
      this.getInvoices();
    },
    async changePage(page) {
      await this.$store.dispatch('SET_PAGE', page);
      this.getInvoices();
    },
  },
};
</script>

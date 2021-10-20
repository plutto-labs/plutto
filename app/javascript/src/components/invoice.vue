<template>
  <div>
    <PluttoLoader
      v-if="loading"
    />
    <template v-else-if="invoice">
      <div class="mt-4">
        <div
          v-if="!initialInvoice"
          class="grid grid-cols-6 gap-4 my-6 lg:mt-0 md:gap-x-84lg:col-span-12"
        >
          <button
            class="btn"
            v-for="event in invoice.permittedEvents"
            :key="event"
            @click="changeInvoiceStatus(event)"
          >
            {{ $t(`message.invoices.events.${event}`) }}
          </button>
        </div>
        <div class="px-6 py-6 mt-3 bg-gray-600 rounded-lg">
          <dl class="grid grid-cols-1 gap-6 md:grid-cols-2 my-7 lg:mt-0 md:gap-x-8 lg:px-8 lg:col-span-12">
            <div>
              <dt class="text-xs md:text-base">
                {{ invoice.id }}
              </dt>
              <dt class="text-sm text-gray-300">
                {{ formatDateTime(invoice.issueDate) }}
              </dt>
            </div>
            <div>
              <dt class="md:text-right font-small">
                <div
                  class="inline-flex px-4 py-1 text-xs font-semibold leading-5 rounded-full whitespace-nowrap"
                  :class="`tag-color--${invoiceStatusTags()[invoice.status]}`"
                >
                  {{ $t(`message.invoices.status.${invoice.status}`) }}
                </div>
              </dt>
            </div>
          </dl>
          <dl class="grid grid-cols-1 gap-6 text-sm md:grid-cols-2 my-7 md:gap-x-8 lg:px-8 lg:col-span-12">
            <div>
              <dt class="font-medium">
                Billing Information
              </dt>
              <dd class="mt-3 text-gray-300">
                <span class="block">{{ invoice.customerName }}</span>
                <span class="block">{{ invoice.customerEmail }}</span>
                <span class="block">{{ invoice.billingInformation.taxId }}</span>
              </dd>
            </div>
            <div>
              <dt class="font-medium">
                Payment information
              </dt>
              <dd
                class="flex mt-3"
                v-if="invoice.status === 'paid'"
              >
                <p class="text-sm text-gray-300">
                  Bank Transfer
                </p>
              </dd>
              <dd
                v-else
                class="mt-3 text-gray-300"
              >
                <span class="block">Invoice not paid yet</span>
              </dd>
            </div>
          </dl>
          <dl class="grid grid-cols-1 gap-6 my-7 lg:mt-0 lg:px-8 lg:col-span-12">
            <div class="text-sm">
              <div
                class="flex items-center justify-between py-3 divide-gray-500"
                :key="detail.id"
                v-for="detail in invoice.details"
              >
                <dt class="text-gray-300">
                  {{ detail.description }}
                </dt>
                <dd class="font-medium">
                  {{ formatCurrency(detail.totalPrice, invoice.currency) }}
                </dd>
              </div>
              <hr class="border-gray-300">
              <div class="flex items-center justify-between py-3">
                <dt class="text-gray-300">
                  Subtotal
                </dt>
                <dd class="font-medium">
                  {{ formatCurrency(invoice.subtotal, invoice.currency) }}
                </dd>
              </div>
              <div class="flex items-center justify-between py-3">
                <dt class="text-gray-300">
                  Tax
                </dt>
                <dd class="font-medium">
                  {{ formatCurrency(invoice.tax, invoice.currency) }}
                </dd>
              </div>
              <hr class="border-gray-300">
              <div class="flex items-center justify-between pt-3">
                <dt class="font-medium">
                  Total
                </dt>
                <dd class="font-medium text-indigo-300">
                  {{ formatCurrency(invoice.total, invoice.currency) }}
                </dd>
              </div>
            </div>
          </dl>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoLoader from '@/components/plutto-loader';

export default {
  components: { PluttoLoader },
  props: {
    invoiceId: {
      type: String,
      default: null,
    },
    initialInvoice: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      dropdownOptions: ['new', 'posted', 'paid', 'not_paid', 'voided'],
      invoice: {},
    };
  },
  async beforeMount() {
    if (this.initialInvoice) {
      this.invoice = this.initialInvoice;
    } else {
      await this.getInvoice(this.invoiceId);
    }
  },
  computed: {
    ...mapState({
      loading: state => state.invoices.loading,
      currentInvoice: state => state.invoices.currentInvoice,
    }),
  },
  methods: {
    async getInvoice(id) {
      await this.$store.dispatch('GET_INVOICE', id);
      this.invoice = this.currentInvoice;
    },
    async changeInvoiceStatus(event) {
      this.$store.dispatch('CHANGE_INVOICE_STATUS', {
        id: this.currentInvoice.id,
        event,
      });
    },
    totalAmount() {
      return parseFloat(this.currentInvoice.subtotal) + parseFloat(this.currentInvoice.tax);
    },
  },
};
</script>

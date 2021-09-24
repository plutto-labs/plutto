<template>
  <div>
    <PluttoLoader
      v-if="loading"
    />
    <template v-else>
      <div class="w-full pb-8 mx-auto mt-20 space-y-8 divide-y divide-gray-200 md:max-w-xl">
        <div class="mt-4">
          <div class="grid grid-cols-6 gap-4 my-6 lg:mt-0 md:gap-x-84lg:col-span-12">
            <button
              class="btn"
              v-for="event in currentInvoice.permittedEvents"
              :key="event"
              @click="changeInvoiceStatus(event.event)"
            >
              {{ $t(`message.invoices.events.${event.event}`) }}
            </button>
          </div>
          <div class="px-6 py-6 mt-3 bg-gray-600 rounded-lg">
            <dl class="grid grid-cols-2 gap-6 my-7 lg:mt-0 md:gap-x-8 lg:px-8 lg:col-span-12">
              <div>
                <dt>
                  {{ currentInvoice.id }}
                </dt>
                <dt class="text-sm text-gray-300">
                  {{ formatDateTime(currentInvoice.issueDate) }}
                </dt>
              </div>
              <div>
                <dt class="text-right font-small">
                  <div
                    class="inline-flex px-4 py-1 text-xs font-semibold leading-5 rounded-full whitespace-nowrap"
                    :class="`tag-color--${invoiceStatusTags()[currentInvoice.status]}`"
                  >
                    {{ $t(`message.invoices.status.${currentInvoice.status}`) }}
                  </div>
                </dt>
              </div>
            </dl>
            <dl class="grid grid-cols-2 gap-6 text-sm my-7 md:gap-x-8 lg:px-8 lg:col-span-12">
              <div>
                <dt class="font-medium">
                  Billing Information
                </dt>
                <dd class="mt-3 text-gray-300">
                  <span class="block">{{ currentInvoice.customerName }}</span>
                  <span class="block">{{ currentInvoice.customerEmail }}</span>
                  <span class="block">{{ currentInvoice.billingInformation.taxId }}</span>
                </dd>
              </div>
              <div>
                <dt class="font-medium">
                  Payment information
                </dt>
                <dd
                  class="flex mt-3"
                  v-if="currentInvoice.status === 'paid'"
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
                <InvoiceDetails
                  v-for="detailsKey in Object.keys(currentInvoice.details)"
                  :key="detailsKey"
                  :details="currentInvoice.details[detailsKey]"
                  :currency="currentInvoice.currency"
                  class="flex items-center justify-between py-3 divide-gray-500"
                />
                <hr class="border-gray-300">
                <div class="flex items-center justify-between py-3">
                  <dt class="text-gray-300">
                    Subtotal
                  </dt>
                  <dd class="font-medium">
                    {{ formatCurrency(currentInvoice.subtotal, currentInvoice.currency) }}
                  </dd>
                </div>
                <div class="flex items-center justify-between py-3">
                  <dt class="text-gray-300">
                    Tax
                  </dt>
                  <dd class="font-medium">
                    {{ formatCurrency(currentInvoice.tax, currentInvoice.currency) }}
                  </dd>
                </div>
                <hr class="border-gray-300">
                <div class="flex items-center justify-between pt-3">
                  <dt class="font-medium">
                    Total
                  </dt>
                  <dd class="font-medium text-indigo-300">
                    {{ formatCurrency(currentInvoice.total, currentInvoice.currency) }}
                  </dd>
                </div>
              </div>
            </dl>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoLoader from '@/components/plutto-loader';
import InvoiceDetails from '@/components/invoice-details';

export default {
  components: { PluttoLoader, InvoiceDetails },
  props: {
    invoiceId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      dropdownOptions: ['new', 'posted', 'paid', 'not_paid', 'voided'],
    };
  },
  beforeMount() {
    this.getInvoice(this.invoiceId);
  },
  computed: {
    ...mapState({
      loading: state => state.invoices.loading,
      currentInvoice: state => state.invoices.currentInvoice,
    }),
  },
  methods: {
    async getInvoice(id) {
      this.$store.dispatch('GET_INVOICE', id);
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

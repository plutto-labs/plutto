<template>
  <div>
    <PluttoLoader
      v-if="loading"
    />
    <template v-else-if="invoice">
      <div class="mt-4">
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
                  :class="`tag-color--${tagColor}`"
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
                <span class="block">{{ invoice.billingInformation && invoice.billingInformation.taxId }}</span>
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
        <div
          class="grid grid-cols-2 gap-4"
          v-if="!initialInvoice"
        >
          <div class="p-4 mt-4 bg-gray-600 rounded-lg hover:border hover:border-gray-300">
            <span class="text-lg">Change status</span>
            <p class="mt-2 mb-4 text-xs text-gray-200">
              This action changes invoice status triggering all asociated actions.
              For example, if posted, an email will be sent to the customer.
            </p>
            <PluttoRadioInput
              input-id="change-status"
              :options="invoice.permittedEvents"
              v-model="selectedEvent"
            />
            <div
              class="flex justify-between my-4"
              v-if="selectedEvent"
            >
              <button
                class="btn btn--dismiss"
                @click="selectedEvent = null"
              >
                cancel
              </button>
              <button
                class="btn btn--filled"
                @click="changeInvoiceStatus(selectedEvent)"
              >
                Change status
              </button>
            </div>
          </div>
          <div class="p-4 mt-4 bg-gray-600 rounded-lg">
            <span class="text-lg">Mark as</span>
            <p class="mt-2 mb-4 text-xs text-gray-200">
              This action changes invoice status without triggering actions.
              Only for annotation purposes. No emails are sent or other actions performed.
            </p>
            <PluttoRadioInput
              input-id="mark-as"
              :options="Object.keys(tags)"
              v-model="selectedMarkAs"
            />
            <div
              class="flex justify-between my-4"
              v-if="selectedMarkAs"
            >
              <button
                class="btn btn--dismiss"
                @click="selectedMarkAs = null"
              >
                cancel
              </button>
              <button
                class="btn btn--filled"
                @click="markInvoiceAs(selectedMarkAs)"
              >
                Mark as
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { decamelize } from 'humps';
import { mapState } from 'vuex';
import PluttoLoader from '@/components/plutto-loader';
import PluttoRadioInput from '@/components/plutto-radio-input.vue';

export default {
  components: { PluttoLoader, PluttoRadioInput },
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
      invoice: {},
      tags: {
        created: 'purple',
        posted: 'blue',
        paid: 'green',
        notPaid: 'red',
        voided: 'yellow',
      },
      selectedEvent: null,
      selectedMarkAs: null,
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
    tagColor() {
      return this.tags[this.invoice.status];
    },
  },
  methods: {
    async getInvoice(id) {
      await this.$store.dispatch('GET_INVOICE', id);
    },
    async changeInvoiceStatus(event) {
      await this.$store.dispatch('CHANGE_INVOICE_STATUS', {
        id: this.currentInvoice.id,
        event,
      });
    },
    async markInvoiceAs(event) {
      await this.$store.dispatch('MARK_INVOICE_AS', {
        id: this.currentInvoice.id,
        event: decamelize(event),
      });
    },
    totalAmount() {
      return parseFloat(this.currentInvoice.subtotal) + parseFloat(this.currentInvoice.tax);
    },
  },
  watch: {
    currentInvoice() {
      this.invoice = this.currentInvoice;
    },
  },
};
</script>

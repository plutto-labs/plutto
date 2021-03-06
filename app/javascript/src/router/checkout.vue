<template>
  <main>
    <div class="px-6 m-auto mt-6 md:max-w-xl">
      <h1 class="my-8 text-4xl text-center">
        Checkout
      </h1>
      <PluttoBreadcrumbs
        :steps="3"
        :current-step="currentStep"
        class="w-56 max-w-xs m-auto"
      />
      <div
        class="relative flex flex-col items-center w-full px-6 py-10 m-auto text-center"
        v-if="invalidUrl"
      >
        Ups! This url does not seem valid or has already expired. <br>Please try again.
      </div>
      <template v-else-if="loading">
        <PluttoLoader
          class="mt-8"
        />
      </template>
      <template v-else-if="!reviewedInvoice && invoice">
        <div>
          <Invoice
            :initial-invoice="invoice"
          />
          <button
            v-if="false && this.invoice.status !== 'paid'"
            class="h-12 mt-8 btn btn--full btn--big btn--filled bg-primary"
            @click="reviewedInvoice = true"
          >
            Go to Billing Information
          </button>
        </div>
      </template>
      <template v-else-if="!updatedBillingInfo">
        <BillingInformationForm
          v-model="billingInformation"
          :show-actions="true"
          @button-clicked="updateCustomerInformation"
        />
      </template>
      <template v-else-if="!cardCreated">
        <CreditCardForm
          v-model="card"
        >
          <template #actions>
            <button
              v-if="!loading"
              @click.prevent="registerKushkiCard"
              class="h-12 mt-12 btn btn--full btn--big btn--filled bg-primary"
            >
              Add credit card
            </button>
            <PluttoLoader
              class="mt-8"
              v-else
            />
            <div
              v-if="error"
              class="mt-4 text-danger"
            >
              {{ error }}
            </div>
          </template>
        </CreditCardForm>
      </template>
      <template v-else>
        <div class="relative flex flex-col items-center w-full px-6 py-10 m-auto">
          <div>¡Card Added Successfully!</div>
          <button
            class="mt-8 btn"
            @click="$router.replace('https://getplutto.com')"
          >
            OK
          </button>
        </div>
      </template>
    </div>
  </main>
</template>

<script>
/* eslint-disable no-undef */

import { mapState } from 'vuex';
import * as checkoutsApi from '@/api/checkouts';
import * as paymentMethodsApi from '@/api/payment_methods';
import PluttoLoader from '@/components/plutto-loader';
import Invoice from '@/components/invoice';
import BillingInformationForm from '@/components/forms/billing-information-form.vue';
import CreditCardForm from '@/components/forms/credit-card-form.vue';
import PluttoBreadcrumbs from '@/components/plutto-breadcrumbs';

export default {
  components: { Invoice, CreditCardForm, BillingInformationForm, PluttoLoader, PluttoBreadcrumbs },
  data() {
    return {
      kushki: null,
      error: null,
      loading: false,
      reviewedInvoice: false,
      updatedBillingInfo: false,
      cardCreated: false,
      symbolImage: null,
      invalidUrl: false,
      card: {},
      billingInformation: {},
      customer: null,
      invoice: null,
      token: null,
      gateway: 'kushki',
    };
  },
  async beforeMount() {
    this.token = encodeURIComponent(this.$route.query.token);
    if (this.token) {
      this.loading = true;
      await Promise.all([this.getCustomer(), this.getInvoice()]);
      this.loading = false;
    } else {
      this.invalidUrl = true;
    }
  },
  mounted() {
    if (this.gateway === 'kushki') this.mountKushki();
    else if (this.gateway === 'mercadopago') this.mountMP();
  },
  computed: {
    ...mapState({
      globalError: state => state.ui.error,
    }),
    /* eslint-disable no-magic-numbers*/
    currentStep() {
      if (this.invoice && this.invoice.status === 'paid') return 5;
      else if (!this.reviewedInvoice) return 1;
      else if (!this.updatedBillingInfo) return 2;
      else if (!this.cardCreated) return 3;

      return 4;
    },
  },
  methods: {
    registerKushkiCard() {
      this.error = null;
      this.loading = true;
      this.kushki.requestSubscriptionToken({
        currency: this.invoice.currency,
        card: { ...this.card, number: this.card.number.replace(/\s/g, '') },
      }, (response) => {
        if (response.code) {
          this.error = response.message;
          this.loading = false;
        } else this.submitToken(response.token);
      });
    },
    async registerMPCard() {
      this.error = null;
      this.loading = true;
      try {
        const mp = new MercadoPago(process.env.MERCADOPAGO_PUBLIC_KEY);
        const res = await mp.createCardToken({
          cardNumber: this.card.number,
          cardholderName: this.card.name,
          cardExpirationMonth: this.card.expiryMonth,
          cardExpirationYear: this.card.expiryYear,
          securityCode: this.card.cvc,
        });
        this.res = res;
      } catch (error) {
        this.error = error.message;
      } finally {
        this.loading = false;
      }
    },
    submitToken(token) {
      paymentMethodsApi.create(this.customer.id, { gateway: this.gateway, token, invoiceId: this.invoice.id })
        .then(() => (this.cardCreated = true))
        .catch(err => (this.error = err.response))
        .finally(() => (this.loading = false));
    },
    getCustomer() {
      return checkoutsApi.get(this.token, 'customer')
        .then((res) => {
          this.customer = res.customer;
          this.billingInformation = { ...this.customer.billingInformation };
        })
        .catch(() => (this.invalidUrl = true));
    },
    getInvoice() {
      return checkoutsApi.get(this.token, 'invoice')
        .then((res) => (this.invoice = res.invoice))
        .catch(() => (this.invalidUrl = true));
    },
    updateCustomerInformation() {
      this.loading = true;
      checkoutsApi.update(
        this.token, 'customer', { id: this.customer.id, billingInformationAttributes: this.billingInformation },
      ).then(() => (this.updatedBillingInfo = true))
        .finally(() => (this.loading = false));
    },
    mountKushki() {
      const kushkiScript = document.createElement('script');
      kushkiScript.setAttribute('src', 'https://cdn.kushkipagos.com/kushki.min.js');
      document.body.appendChild(kushkiScript);
      const listener = kushkiScript.addEventListener('load', () => {
        this.kushki = new Kushki({
          merchantId: process.env.KUSHKI_PUBLIC_MERCHANT_ID,
          inTestEnvironment: true,
          regional: false,
        });
        kushkiScript.removeEventListener('load', listener);
      });
    },
    mountMP() {
      this.customerId = this.$route.query.customerId;
      this.permissionGroupId = this.$route.query.permissionGroupId;
      const mpScript = document.createElement('script');
      mpScript.setAttribute('src', 'https://sdk.mercadopago.com/js/v2');
      document.body.appendChild(mpScript);
    },
  },
};
</script>

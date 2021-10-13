<template>
  <main>
    <div class="px-6 mt-6">
      <h1 class="my-8 text-4xl text-center">
        Checkout
      </h1>
      <PluttoBreadcrumbs
        :steps="3"
        :current-step="currentStep"
        class="w-56 max-w-xs m-auto"
      />
      <div
        class="relative flex flex-col items-center w-full px-6 py-10 m-auto text-center md:max-w-xl"
        v-if="invalidUrl"
      >
        Ups! This url does not seem valid or has already expired. <br>Please try again.
      </div>
      <template v-else-if="!updatedBillingInfo">
        <BillingInformationForm
          v-model="billingInformation"
        />
      </template>
      <template v-else-if="!cardCreated">
        <CreditCardForm
          v-model="card"
        >
          <template #actions>
            <button
              v-if="!loading"
              @click.prevent="registerCard"
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
        <div class="relative flex flex-col items-center w-full px-6 py-10 m-auto md:max-w-xl">
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

import * as paymentMethodsApi from '@/api/payment_methods';
import PluttoLoader from '@/components/plutto-loader';
import BillingInformationForm from '@/components/forms/billing-information-form.vue';
import CreditCardForm from '@/components/forms/credit-card-form.vue';
import PluttoBreadcrumbs from '@/components/plutto-breadcrumbs';

export default {
  components: { CreditCardForm, BillingInformationForm, PluttoLoader, PluttoBreadcrumbs },
  data() {
    return {
      kushki: null,
      error: null,
      loading: false,
      updatedBillingInfo: false,
      cardCreated: false,
      symbolImage: null,
      invalidUrl: false,
      card: {},
      billingInformation: {},
    };
  },
  beforeMount() {
    if (!this.$route.query.customerId) this.invalidUrl = true;
  },
  mounted() {
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
  computed: {
    currentStep() {
      if (!this.updatedBillingInfo) return 1;
      else if (!this.cardCreated) return 2;

      return 3; // eslint-disable-line
    },
  },
  methods: {
    registerCard() {
      this.error = null;
      this.loading = true;
      this.kushki.requestSubscriptionToken({
        currency: 'USD',
        card: { ...this.card, number: this.card.number.replace(/\s/g, '') },
      }, (response) => {
        if (response.code) {
          this.error = response.message;
          this.loading = false;
        } else this.submitToken(response.token);
      });
    },
    submitToken(token) {
      paymentMethodsApi.create(this.$route.query.customerId, { gateway: 'kushki', token })
        .then(() => (this.cardCreated = true))
        .catch(err => (this.error = err.response))
        .finally(() => (this.loading = false));
    },
  },
};
</script>

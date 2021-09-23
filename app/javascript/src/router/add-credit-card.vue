<template>
  <main>
    <div class="px-6 mt-6">
      <h1 class="my-8 text-4xl text-center">
        Plutto
      </h1>
      <form
        class="relative w-full px-6 py-10 m-auto border rounded-lg md:max-w-xl"
        v-if="!cardCreated && !invalidUrl"
        @submit.prevent="registerCard"
      >
        <div class="mt-8 plutto-input">
          <label
            class="plutto-input__label"
            for="number"
          >Card number</label>
          <div class="plutto-input__icon">
            <div class="relative w-8 h-5 -ml-1">
              <img
                v-if="symbolImage === 'visa'"
                class="absolute object-cover h-8 m-auto -inset-full"
                src="../../img/visa.png"
              >
              <img
                v-if="symbolImage === 'mastercard'"
                class="absolute object-cover h-5 m-auto -inset-full"
                src="../../img/master-card.svg"
              >
            </div>
          </div>
          <input
            v-imask="cardMasks"
            @accept="onAcceptCardType"
            placeholder="Card Number"
            v-model="card.number"
            type="text"
            inputmode="decimal"
            name="number"
            class="plutto-input__input"
          >
        </div>
        <div class="mt-8 plutto-input">
          <label
            class="plutto-input__label"
            for="name"
          >Name</label>
          <input
            placeholder="Full Name"
            v-model="card.name"
            type="text"
            name="name"
            class="plutto-input__input"
          >
        </div>
        <div class="flex w-full mt-8">
          <div class="plutto-input">
            <label
              class="plutto-input__label"
              for="expiryMonth"
            >Expiry Month</label>
            <input
              placeholder="MM"
              v-model="card.expiryMonth"
              type="text"
              name="expiryMonth"
              inputmode="decimal"
              class="plutto-input__input plutto-input__input--no-icon"
            >
          </div>
          <div class="ml-2 plutto-input">
            <label
              class="plutto-input__label"
              for="expiryYear"
            >Expiry Year</label>
            <input
              placeholder="YY"
              v-model="card.expiryYear"
              type="text"
              name="expiryYear"
              inputmode="decimal"
              class="plutto-input__input plutto-input__input--no-icon"
            >
          </div>
          <div class="ml-2 md:ml-8 plutto-input">
            <label
              class="plutto-input__label"
              for="cvc"
            >CVC</label>
            <input
              v-imask="cvvMask"
              placeholder="CVC"
              v-model="card.cvc"
              type="text"
              name="cvc"
              inputmode="decimal"
              class="plutto-input__input plutto-input__input--no-icon"
            >
          </div>
        </div>
        <button
          v-if="!loading"
          class="h-12 mt-8 btn btn--full btn--big btn--filled bg-primary"
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
      </form>
      <div
        class="relative flex flex-col items-center w-full px-6 py-10 m-auto md:max-w-xl"
        v-else-if="!invalidUrl"
      >
        <div>¡Card Added Successfully!</div>
        <button
          class="mt-8 btn"
          @click="$router.replace('https://getplutto.com')"
        >
          OK
        </button>
      </div>
      <div
        class="relative flex flex-col items-center w-full px-6 py-10 m-auto text-center md:max-w-xl"
        v-else
      >
        Ups! This url does not seem valid or has already expired. <br>Please try again.
      </div>
    </div>
  </main>
</template>

<script>
/* eslint-disable no-undef */

import { IMaskDirective } from 'vue-imask';
import { cardMasks, cvvMask } from '@/utils/card-masks';
import * as paymentMethodsApi from '@/api/payment_methods';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoLoader },
  data() {
    return {
      cardMasks,
      cvvMask,
      card: {
        name: null,
        number: null,
        cvc: null,
        expiryMonth: null,
        expiryYear: null,
      },
      kushki: null,
      error: null,
      loading: false,
      cardCreated: false,
      symbolImage: null,
      invalidUrl: false,
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
    onAcceptCardType(e) {
      const maskRef = e.detail;
      const type = maskRef.masked.currentMask.cardtype;
      this.symbolImage = type;
      this.card.number = maskRef.unmaskedValue;
    },
  },
  directives: {
    imask: IMaskDirective,
  },
};
</script>

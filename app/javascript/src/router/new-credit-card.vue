<template>
  <main>
    <div class="px-6 mt-6">
      <form
        class="relative w-full px-6 py-10 bg-white border rounded-lg md:max-w-xl"
        @submit.prevent="registerCard"
      >
        <div class="mt-8 plutto-input">
          <label
            class="plutto-input__label"
            for="number"
          >Card number</label>
          <input
            placeholder="Card Number"
            v-model="card.number"
            type="text"
            name="number"
            class="text-gray-900 plutto-input__input plutto-input__input--no-icon"
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
            class="text-gray-900 plutto-input__input plutto-input__input--no-icon"
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
              class="text-gray-900 plutto-input__input plutto-input__input--no-icon"
            >
          </div>
          <div class="plutto-input">
            <label
              class="plutto-input__label"
              for="expiryYear"
            >Expiry Year</label>
            <input
              placeholder="YY"
              v-model="card.expiryYear"
              type="text"
              name="expiryYear"
              class="text-gray-900 plutto-input__input plutto-input__input--no-icon"
            >
          </div>
          <div class="ml-8 plutto-input">
            <label
              class="plutto-input__label"
              for="cvc"
            >CVC</label>
            <input
              placeholder="CVC"
              v-model.number="card.cvc"
              type="text"
              name="cvc"
              class="text-gray-900 plutto-input__input plutto-input__input--no-icon"
            >
          </div>
        </div>
        <button class="h-12 mt-8 btn btn--full btn--big btn--filled bg-primary">
          Add credit card
        </button>
      </form>
    </div>
  </main>
</template>

<script>
/* eslint-disable no-undef */

export default {
  data() {
    return {
      card: {
        name: 'ignacio marquez',
        number: '1234123412341234',
        cvc: '733',
        expiryMonth: '01',
        expiryYear: '25',
      },
      kushki: new Kushki({
        merchantId: process.env.KUSHKI_PUBLIC_MERCHANT_ID,
        inTestEnvironment: true,
        regional: false,
      }),
    };
  },
  beforeMount() {
    console.log(process.env.KUSHKI_PUBLIC_MERCHANT_ID);
    this.loadKushkiScript();
  },
  methods: {
    registerCard() {
      this.kushki.requestSubscriptionToken({
        currency: 'USD',
        card: this.card,
      }, (response) => {
        if (response.code) {
          console.log(response);
          // Submit your code to your back-end
        } else {
          console.error('Error: ', response.error, 'Code: ', response.code, 'Message: ', response.message);
        }
      });
    },
    loadKushkiScript() {
      const kushkiScript = document.createElement('script');
      kushkiScript.setAttribute('src', 'https://cdn.kushkipagos.com/kushki.min.js');
      document.head.appendChild(kushkiScript);
    },
  },
};
</script>

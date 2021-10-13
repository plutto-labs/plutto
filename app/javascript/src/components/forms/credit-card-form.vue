<template>
  <Form
    class="relative w-full py-4 m-auto rounded-lg md:px-6 md:max-w-md"
    v-slot="{ errors }"
    :validation-schema="schema"
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
            src="../../../img/visa.png"
          >
          <img
            v-if="symbolImage === 'mastercard'"
            class="absolute object-cover h-5 m-auto -inset-full"
            src="../../../img/master-card.svg"
          >
        </div>
      </div>
      <Field
        v-imask="cardMasks"
        @accept="onAcceptCardType"
        placeholder="Card Number"
        v-model="card.number"
        type="text"
        inputmode="decimal"
        name="number"
        class="plutto-input__input"
      />
      <div
        class="absolute text-sm text-danger-light"
        v-if="errors.number"
      >
        Required
      </div>
    </div>
    <div class="mt-12 plutto-input">
      <label
        class="plutto-input__label"
        for="name"
      >Name</label>
      <Field
        placeholder="Full Name"
        v-model="card.name"
        type="text"
        name="name"
        class="plutto-input__input"
      />
      <div
        class="absolute text-sm text-danger-light"
        v-if="errors.name"
      >
        Required
      </div>
    </div>
    <div class="flex w-full mt-12">
      <div class="plutto-input">
        <label
          class="plutto-input__label"
          for="expiryMonth"
        >Expiry Date</label>
        <Field
          v-imask="dateMask"
          placeholder="MM"
          v-model="card.expiryMonth"
          type="text"
          name="expiryMonth"
          inputmode="decimal"
          class="w-16 plutto-input__input plutto-input__input--no-icon"
        /><span class="mx-4">/</span>
        <Field
          v-imask="dateMask"
          placeholder="YY"
          v-model="card.expiryYear"
          type="text"
          name="expiryYear"
          inputmode="decimal"
          class="w-16 plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.expiryMonth || errors.expiryYear"
        >
          Required
        </div>
        <div
          class="absolute text-sm text-danger-light"
          v-else-if="!isFutureDate"
        >
          Must be a future Date
        </div>
      </div>
      <div class="ml-2 md:ml-8 plutto-input">
        <label
          class="plutto-input__label"
          for="cvc"
        >CVC</label>
        <Field
          v-imask="cvvMask"
          placeholder="CVC"
          v-model="card.cvc"
          type="password"
          name="cvc"
          inputmode="decimal"
          class="plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.cvc"
        >
          Required
        </div>
      </div>
    </div>
    <slot name="actions" />
    <div class="mt-6 text-xs text-center text-gray-200">
      Powered by Plutto ™
    </div>
    <img
      class="object-cover h-12 m-auto"
      src="../../../img/kushki.svg"
    >
  </Form>
</template>

<script>
import { IMaskDirective } from 'vue-imask';
import { cardMasks, cvvMask, dateMask } from '@/utils/card-masks';
import { Field, Form } from 'vee-validate';

export default {
  components: { Field, Form },
  props: {
    modelValue: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      cardMasks,
      cvvMask,
      dateMask,
      symbolImage: null,
      schema: {
        number: 'required',
        name: 'required',
        expiryMonth: 'required',
        expiryYear: 'required',
        cvc: 'required',
      },
    };
  },
  computed: {
    isFutureDate() {
      if (!this.card.expiryYear || !this.card.expiryMonth) return true;
      const date = new Date(`20${this.card.expiryYear}`, Number(this.card.expiryMonth) - 1);

      return date > new Date();
    },
    card: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
  },
  methods: {
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

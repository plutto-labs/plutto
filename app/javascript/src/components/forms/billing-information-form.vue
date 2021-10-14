<template>
  <Form
    class="relative w-full py-4 m-auto rounded-lg md:px-6 md:max-w-md"
    v-slot="{ errors }"
    :validation-schema="schema"
  >
    <div class="flex-1 w-full mt-12">
      <label
        class="plutto-input__label"
        for="address"
      >Address*</label>
      <GooglePlacesAutocomplete
        placeholder="Address"
        v-model="billingInformation.address"
        type="text"
        name="address"
        @address-details="(details) => fillForm(details)"
      />
    </div>
    <div class="flex">
      <div class="mt-12 mr-4 plutto-input">
        <label
          class="plutto-input__label"
          for="city"
        >City*</label>
        <Field
          placeholder="City"
          v-model="billingInformation.city"
          type="text"
          name="city"
          class="plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.city"
        >
          Required
        </div>
      </div>
      <div class="mt-12 plutto-input">
        <label
          class="plutto-input__label"
          for="state"
        >State*</label>
        <Field
          placeholder="State"
          v-model="billingInformation.state"
          type="text"
          name="state"
          class="plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.state"
        >
          Required
        </div>
      </div>
    </div>
    <div class="flex">
      <div class="mt-12 mr-4 plutto-input">
        <label
          class="plutto-input__label"
          for="country"
        >Country*</label>
        <CountrySelector
          class="h-full"
          :selected="billingInformation.countryIsoCode"
          @countrySelected="(country) => { billingInformation.countryIsoCode = country }"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.country"
        >
          Required
        </div>
      </div>
      <div class="mt-12 plutto-input">
        <label
          class="plutto-input__label"
          for="zip"
        >Zip Code*</label>
        <Field
          placeholder="Zip"
          v-model="billingInformation.zip"
          type="text"
          name="zip"
          class="plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.zip"
        >
          Required
        </div>
      </div>
    </div>
    <div class="flex">
      <div class="mt-12 plutto-input">
        <label
          class="plutto-input__label"
          for="phone"
        >Phone*</label>
        <Field
          placeholder="+56912345678"
          v-model="billingInformation.phone"
          type="text"
          name="phone"
          class="plutto-input__input plutto-input__input--no-icon"
        />
        <div
          class="absolute text-sm text-danger-light"
          v-if="errors.phone"
        >
          Required
        </div>
      </div>
      <div class="mt-12 ml-4 plutto-input">
        <label
          class="plutto-input__label"
          for="taxId"
        >Tax Id <span class="text-xs">(only for companies)</span></label>
        <Field
          placeholder="RUT"
          v-model="billingInformation.taxId"
          type="text"
          name="taxId"
          class="plutto-input__input plutto-input__input--no-icon"
        />
      </div>
    </div>
    <div class="mt-12 plutto-input">
      <label
        class="plutto-input__label"
        for="legalName"
      >Legal Name* <span class="text-xs">(or given name)</span></label>
      <Field
        placeholder="Plutto SpA"
        v-model="billingInformation.legalName"
        type="text"
        name="legalName"
        class="plutto-input__input"
      />
      <div
        class="absolute text-sm text-danger-light"
        v-if="errors.legalName"
      >
        Required
      </div>
    </div>
    <div class="mt-12 plutto-input">
      <label
        class="plutto-input__label"
        for="activity"
      >Activity <span class="text-xs">(only for companies)</span></label>
      <Field
        placeholder="Software Development"
        v-model="billingInformation.activity"
        type="text"
        name="activity"
        class="plutto-input__input"
      />
    </div>
    <slot
      v-if="!showActions"
      name="actions"
    />
    <div v-else>
      <button
        @click.prevent="$emit('button-clicked')"
        class="h-12 mt-12 btn btn--full btn--big btn--filled bg-primary"
        :disabled="Object.keys(errors).length > 0"
      >
        Next
      </button>
    </div>
  </Form>
</template>

<script>
import { Form, Field } from 'vee-validate';
import GooglePlacesAutocomplete from '@/components/forms/google-places-autocomplete';
import CountrySelector from '@/components/country-selector';

export default {
  components: { Form, Field, GooglePlacesAutocomplete, CountrySelector },
  props: {
    modelValue: {
      type: Object,
      default: () => {},
    },
    showActions: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      address: null,
      schema: {
        city: 'required',
        state: 'required',
        zip: 'required',
        phone: 'required',
        legalName: 'required',
      },
    };
  },
  computed: {
    billingInformation: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
  },
  methods: {
    fillForm(details) {
      this.billingInformation.countryIsoCode = details.country;
      this.billingInformation.state = details.administrativeAreaLevel1;
      this.billingInformation.city = details.administrativeAreaLevel2;
      if (details.postalCode) this.billingInformation.zip = details.postalCode;
      if (details.postalCodeSuffix) this.billingInformation.zip = `${details.postalCodeSuffix}-${details.postalCode}`;
      this.billingInformation.address = `${details.route} ${details.streetNumber}, ${details.administrativeAreaLevel3}`;
    },
  },
};
</script>

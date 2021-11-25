<template>
  <div class="z-10 plutto-input">
    <span
      v-if="loading && modelValue.lenth !== 0"
      class="plutto-loading__indicator plutto-loading__indicator--input"
    />
    <input
      type="text"
      class="plutto-input__input"
      ref="airportInput"
      :placeholder="placeholder"
      @input="getPlaces"
      @click="selectAll"
      :value="modelValue"
    >
    <ul
      class="px-2 bg-gray-50 rounded"
      v-if="results && results.length > 0"
    >
      <li
        v-for="(result) in results"
        :key="result.iataCode"
        @click.prevent="setPlaceAndClose(result)"
      >
        <div
          class="py-3 text-gray-700 truncate hover:text-gray-900"
        >
          {{ result.description }}
        </div>
      </li>
    </ul>
    <div
      v-if="error"
      class="absolute bottom-0 ml-10 plutto-error"
    >
      {{ error }}
    </div>
  </div>
</template>

<script>
import { camelizeKeys } from 'humps';
import debounce from 'lodash.debounce';
import { autocomplete, getCoordinates } from '@/api/google';

const MIN_INPUT_LENGTH = 3;

export default {
  props: {
    placeholder: {
      type: String,
      required: true,
    },
    modelValue: {
      type: String,
      default: null,
    },
  },
  data() {
    return {
      results: [],
      loading: false,
      error: null,
      address: {},
    };
  },
  methods: {
    selectAll() {
      this.$refs.airportInput.select();
    },
    getPlaces: debounce(function (e) {
      this.loading = true;
      const value = e.target.value;
      this.$emit('update:modelValue', value);

      if (value && value.length >= MIN_INPUT_LENGTH) {
        autocomplete(value)
          .then((results) => {
            this.results = results;
          })
          .finally(() => {
            this.loading = false;
          });
      } else {
        this.results = [];
      }
    // eslint-disable-next-line no-magic-numbers
    }, 500),
    setPlaceAndClose(place) {
      this.loading = true;
      getCoordinates(place.placeId)
        .then((res) => {
          this.fillInAddress(res);
          this.$emit('input', `${place.description}`);
          this.$emit('addressDetails', camelizeKeys(this.address));
          this.loading = false;
        }).catch(() => {
          this.error = 'Intenta con otro destino';
          this.loading = false;
        });
      this.results = [];
    },
    fillInAddress(addressComponents) {
      addressComponents.reduce((acc, component) => {
        acc[component.types[0]] = component.types[0] === 'country' ? component.shortName : component.longName;

        return acc;
      }, this.address);
    },
  },
};
</script>

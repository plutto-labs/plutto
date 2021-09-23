<template>
  <div>
    <template v-if="details.meter">
      <dt class="text-gray-300">
        {{ details.meter }} @ {{ details.quantity }}
      </dt>
    </template>
    <template v-else>
      <dt class="text-gray-300">
        Flat Fee
      </dt>
    </template>
    <dd class="font-medium">
      {{ formatCurrency(details.totalPrice, currency) }}
    </dd>
  </div>
</template>

<script>

export default {
  props: {
    details: {
      type: Object,
      required: true,
    },
    currency: {
      type: String,
      required: true,
    },
  },
  methods: {
    totalAmount() {
      return this.details.totalAmountCents;
    },
  },
};
</script>

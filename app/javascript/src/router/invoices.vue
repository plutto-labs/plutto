<template>
  <div>
    <h2 class="mb-4">
      Invoices
    </h2>
    <div>
      <PluttoTable
        :headers="headers"
        :rows="invoices"
        :loading="loading"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';

export default {
  components: { PluttoTable },
  data() {
    return {
      headers: [
        {
          title: 'customer',
          type: 'twoLinesText',
          bigText: 'customerEmail',
          smallText: 'customerName',
        },
        {
          title: 'state',
          type: 'tag',
          tags: {
            new: 'purple',
            posted: 'blue',
            paid: 'green',
            notPaid: 'red',
            voided: 'yellow',
          },
        },
        {
          title: 'subtotal',
          type: 'currency',
        },
        {
          title: 'currency',
          type: 'oneLineText',
        },
        {
          title: 'issueDate',
          type: 'date',
        },
      ],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.invoices.loading,
      invoices: state => state.invoices.invoices,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_INVOICES');
  },
};
</script>

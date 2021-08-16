<template>
  <main>
    <PluttoHeader
      title="Customers"
      button-text="Add Customer"
    />
    <div class="px-6 mt-6">
      <PluttoTable
        class="mt-6"
        :headers="headers"
        :rows="customers"
        :loading="loading"
        @delete-clicked="destroyCustomer"
      />
    </div>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '@/components/plutto-header';

export default {
  components: {
    PluttoTable,
    PluttoHeader,
  },
  data() {
    return {
      headers: [
        {
          title: 'info',
          type: 'twoLinesText',
          bigText: 'name',
          smallText: 'email',
        },
        {
          title: 'identifier',
          type: 'oneLineText',
        },
        {
          title: 'none',
          type: 'action',
          action: 'delete',
        },
      ],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_CUSTOMERS');
  },
  methods: {
    destroyCustomer(customer) {
      this.$store.dispatch('DESTROY_CUSTOMER', customer);
    },
  },
};
</script>

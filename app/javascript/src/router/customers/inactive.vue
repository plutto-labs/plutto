<template>
  <div>
    <PluttoTable
      class="mt-6 rounded-lg"
      :headers="headers"
      :rows="customers"
      :loading="loading"
      @show-clicked="(customer) => $router.push({ name: 'customer', params: { id: customer.id } })"
    />
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';

export default {
  components: {
    PluttoTable,
  },
  data() {
    return {
      headers: [{
        title: 'info',
        type: 'twoLinesText',
        bigText: 'name',
        smallText: 'email',
      }, {
        title: 'identifier',
        type: 'copyableLine',
      }, {
        title: 'none',
        type: 'action',
        action: 'show',
      }],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
    }),
  },
  async beforeCreate() {
    await this.$store.dispatch('GET_CUSTOMERS', 'inactive');
  },
};
</script>

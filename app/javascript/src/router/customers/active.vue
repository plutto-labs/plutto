<template>
  <div>
    <PluttoTable
      class="mt-6 rounded-lg"
      :headers="headers"
      :rows="customers"
      :loading="loading"
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
        bigText: 'email',
        smallText: 'name',
      }, {
        title: 'identifier',
        type: 'oneLineText',
      }, {
        title: 'id',
        type: 'copyableLine',
      }],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.customers.loading,
      customers: state => state.customers.customers,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_ACTIVE_CUSTOMERS');
  },
};
</script>

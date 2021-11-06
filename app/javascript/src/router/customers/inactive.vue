<template>
  <div>
    <template v-if="customers && customers.length > 0">
      <PluttoTable
        class="mt-6 rounded-lg"
        :headers="headers"
        :rows="customers"
        :loading="loading"
        @show-clicked="(customer) => $router.push({ name: 'customer', params: { id: customer.id } })"
      />
    </template>
    <div
      class="flex items-center justify-center w-full text-center h-80"
      v-else
    >
      <div>
        <p>
          Ups! Seems like there's no <b>inactive</b> customers found.
        </p>
        <p>
          Try looking for
          <router-link
            class="underline text-primary"
            to="/customers/trial"
          >
            customers on trial.
          </router-link>
        </p>
      </div>
    </div>
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
    await this.$store.dispatch('SET_FILTER', { key: 'scope', value: 'inactive' });
    await this.$store.dispatch('GET_CUSTOMERS');
  },
};
</script>

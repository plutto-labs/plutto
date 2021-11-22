<template>
  <main>
    <div class="flex">
      <div class="flex items-center gap-4">
        <PluttoSearch
          @search="searchString => searchCustomers(searchString)"
        />
        <PluttoTabs
          :tabs="tabs"
          :selected-tab="selectedTab"
          @tab-clicked="(tab) => $route.name === tab ? null : $router.push({ name: tab })"
        />
      </div>
    </div>
    <component
      class="col-span-3 col start-2 md:col-span-5"
      @edit-customer="editCustomer"
      :is="selectedTab"
    />
    <PluttoPagination
      class="mt-6"
      v-if="totalPages > 1"
      :total-pages="totalPages"
      @change-page="(page) => getCustomers(page)"
    />
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import PluttoModal from '@/components/plutto-modal';
import Inactive from '@/router/customers/inactive';
import Active from '@/router/widget/customers/active';
import Canceled from '@/router/customers/canceled';
import PluttoTabs from '@/components/plutto-tabs';
import PluttoSearch from '@/components/plutto-search';
import PluttoPagination from '@/components/plutto-pagination';

export default {
  components: {
    PluttoHeader, PluttoModal, PluttoTabs, Inactive, Active, Canceled, PluttoSearch,
    PluttoPagination,
  },
  props: {
    selectedTab: {
      type: String,
      default: 'active',
    },
  },
  data() {
    return {
      showNewCustomerForm: false,
      editingCustomer: null,
      tabs: [
        { label: 'Active', value: 'active' },
        { label: 'Canceled', value: 'canceled' },
        { label: 'Inactive', value: 'inactive' },
      ],
      components: {
        active: 'Active',
        canceled: 'Canceled',
        inactive: 'Inactive',
      },
    };
  },
  computed: {
    ...mapState({
      totalPages: state => state.customers.totalPages,
    }),
  },
  methods: {
    editCustomer(customer) {
      this.editingCustomer = customer;
      this.showNewCustomerForm = true;
    },
    async searchCustomers(searchString) {
      await this.$store.dispatch('SET_PAGE', 1);
      await this.$store.dispatch('SET_FILTER', { key: 'search', value: searchString });
      await this.$store.dispatch('GET_CUSTOMERS');
    },
    getCustomers(page = 1) {
      this.$store.dispatch('SET_PAGE', page);
      this.$store.dispatch('GET_CUSTOMERS');
    },
  },
};
</script>

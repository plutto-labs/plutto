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
      <PluttoHeader
        class="w-full"
        button-text="Add Customer"
        @button-clicked="showNewCustomerForm = true"
      />
    </div>
    <component
      class="col-span-3 col start-2 md:col-span-5"
      @edit-customer="editCustomer"
      :is="selectedTab"
    />
    <PluttoModal
      :showing="showNewCustomerForm"
      @close="showNewCustomerForm = false"
    >
      <NewCustomerForm
        @created-customer="customer => showNewCustomerForm = false"
      />
    </PluttoModal>
  </main>
</template>
<script>
import PluttoHeader from '@/components/plutto-header';
import PluttoModal from '@/components/plutto-modal';
import NewCustomerForm from '@/components/forms/new-customer-form';
import Inactive from '@/router/customers/inactive';
import Active from '@/router/customers/active';
import Canceled from '@/router/customers/canceled';
import Trial from '@/router/customers/trial';
import PluttoTabs from '@/components/plutto-tabs';
import PluttoSearch from '@/components/plutto-search';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, PluttoTabs, Inactive, Active, Trial, Canceled, PluttoSearch,
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
        { label: 'Inactive', value: 'inactive' },
        { label: 'Canceled', value: 'canceled' },
        { label: 'Trial', value: 'trial' },
      ],
      components: {
        inactive: 'Inactive',
        active: 'Active',
        canceled: 'Canceled',
        trial: 'Trial',
      },
    };
  },
  methods: {
    editCustomer(customer) {
      this.editingCustomer = customer;
      this.showNewCustomerForm = true;
    },
    async searchCustomers(searchString) {
      await this.$store.dispatch('SET_FILTER', { key: 'search', value: searchString });
      await this.$store.dispatch('GET_CUSTOMERS');
    },
  },
};
</script>

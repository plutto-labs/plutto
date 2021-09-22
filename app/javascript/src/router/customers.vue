<template>
  <main>
    <div class="flex">
      <PluttoTabs
        :tabs="tabs"
        :selected-tab="selectedTab"
        @tab-clicked="changeTab"
      />
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
import All from '@/router/customers/all';
import Active from '@/router/customers/active';
import PluttoTabs from '@/components/plutto-tabs';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, PluttoTabs, All, Active,
  },
  data() {
    return {
      showNewCustomerForm: false,
      editingCustomer: null,
      selectedTab: 'All',
      tabs: [{ label: 'All', value: 'All' }, { label: 'Active', value: 'Active' }],
    };
  },
  methods: {
    editCustomer(customer) {
      this.editingCustomer = customer;
      this.showNewCustomerForm = true;
    },
    changeTab(tab) {
      this.selectedTab = tab;
    },
  },
};
</script>

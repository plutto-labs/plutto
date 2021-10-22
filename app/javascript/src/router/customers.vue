<template>
  <main>
    <div class="flex">
      <PluttoTabs
        :tabs="tabs"
        :selected-tab="selectedTab"
        @tab-clicked="(tab) => $route.name === tab ? null : $router.push({ name: tab })"
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
import Trial from '@/router/customers/trial';
import PluttoTabs from '@/components/plutto-tabs';

export default {
  components: {
    PluttoHeader, PluttoModal, NewCustomerForm, PluttoTabs, All, Active, Trial,
  },
  props: {
    selectedTab: {
      type: String,
      default: 'all',
    },
  },
  data() {
    return {
      showNewCustomerForm: false,
      editingCustomer: null,
      tabs: [
        { label: 'All', value: 'all' },
        { label: 'Active', value: 'active' },
        { label: 'Trial', value: 'trial' },
      ],
      components: {
        all: 'All',
        active: 'Active',
        trial: 'Trial',
      },
    };
  },
  methods: {
    editCustomer(customer) {
      this.editingCustomer = customer;
      this.showNewCustomerForm = true;
    },
  },
};
</script>

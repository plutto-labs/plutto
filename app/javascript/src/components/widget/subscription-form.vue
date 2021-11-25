<template>
  <Form
    class="w-full px-8"
    @submit="createSubscription"
    :validation-schema="schema"
    :disabled="true"
  >
    <h1 class="text-xl">
      {{ `${this.presentSubscription ? 'Current' : 'New'} Subscription` }}
    </h1>
    <div class="flex items-center justify-between my-8">
      <span class="flex-1">{{ `${this.presentSubscription ? 'Selected' : 'Select'} plan` }}</span>
      <PluttoDropdown
        class="w-32 ml-4 plutto-input"
        :options="parsedPermissionGroups"
        value-key="id"
        :selected="subscription.permissionGroupId"
        @selected="(permissionGroupId) => subscription.permissionGroupId = permissionGroupId"
        :disabled="this.presentSubscription"
      />
    </div>
    <div class="flex justify-around w-full h-full my-8">
      <button
        class="mt-auto btn btn--cancel"
        v-if="this.presentSubscription"
        @click.prevent="endSubscription"
      >
        Cancel subscription
      </button>
      <button
        class="mt-auto btn"
        v-else
      >
        Create subscription
      </button>
    </div>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import PluttoDropdown from '@/components/plutto-dropdown';
import { Form } from 'vee-validate';

export default {
  components: { PluttoDropdown, Form },
  props: {
    currentSubscription: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      pricingErrors: {},
      subscription: {
        pricingIds: [],
        billingPeriodDuration: 'P1W',
        billsAt: 'start',
        trialFinishesAt: null,
        permissionGroupId: null,
      },
    };
  },
  async beforeCreate() {
    await this.$store.dispatch('GET_PERMISSION_GROUPS');

    if (this.presentSubscription) {
      this.subscription.billsAt = this.currentSubscription.billsAt;
      this.subscription.billingPeriodDuration = this.currentSubscription.billingPeriodDuration;
      this.subscription.trialFinishesAt = this.currentSubscription.trialFinishesAt;
      this.subscription.permissionGroupId = this.currentSubscription.permissionGroup?.id;
    }
  },
  computed: {
    ...mapState({
      loading: state => state.products.loading,
      permissionGroups: state => state.permissionGroups.permissionGroups,
      currentCustomer: state => state.customers.currentCustomer,
      globalError: state => state.ui.error,
    }),
    parsedError() {
      return this.globalError?.response?.data?.error;
    },
    parsedPermissionGroups() {
      return this.permissionGroups.map(pg => ({
        ...pg,
        name: `${pg.name} [${pg.currency}]`,
      }));
    },
    presentSubscription() {
      if (this.currentSubscription) return true;

      return false;
    },
  },
  methods: {
    async createSubscription() {
      await this.$store.dispatch('CREATE_SUBSCRIPTION', { ...this.subscription, customerId: this.currentCustomer.id });

      if (this.parsedError === undefined) {
        this.$emit('created-subscription');
      }
    },
    async endSubscription() {
      await this.$store.dispatch('END_SUBSCRIPTION', { id: this.currentSubscription.id });

      if (this.parsedError === undefined) {
        this.$emit('created-subscription');
      }
    },
  },
};
</script>

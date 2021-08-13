<template>
  <main>
    <PluttoHeader
      title="Plans"
      button-text="Add Plan"
      @button-clicked="showPlanForm"
    />
    <div class="px-6 mt-6">
      <div v-if="!loading">
        <div
          v-for="plan in plans"
          :key="plan.id"
          @click="destroyPlan(plan)"
        >
          {{ plan.name }}
        </div>
      </div>
      <PluttoLoader
        v-else
      />
    </div>
    <PluttoModal
      :showing="showingPlanForm"
      @close="showingPlanForm = false"
    >
      <div class="plutto-input mt-8">
        <span class="plutto-input__icon text-primary">mail_outline</span>
        <input
          required
          type="name"
          class="plutto-input__input"
          placeholder="name"
          v-model="newPlan.name"
        >
      </div>
    </PluttoModal>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '../components/plutto-header';
import PluttoLoader from '../components/plutto-loader';
import PluttoModal from '../components/plutto-modal';

export default {
  components: { PluttoHeader, PluttoLoader, PluttoModal },
  data() {
    return {
      showingPlanForm: false,
      newPlan: {},
    };
  },
  computed: {
    ...mapState({
      loading: state => state.plans.loading,
      plans: state => state.plans.plans,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_PLANS');
  },
  methods: {
    showPlanForm() {
      this.showingPlanForm = true;
    },
    createPlan() {
      this.$store.dispatch('CREATE_PLAN', this.newPlan);
    },
    destroyPlan(plan) {
      this.$store.dispatch('DESTROY_PLAN', plan);
    },
  },
};
</script>

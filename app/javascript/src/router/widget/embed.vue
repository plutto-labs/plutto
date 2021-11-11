<template>
  <main class="flex flex-col gap-8">
    <h2 class="text-2xl">
      Design
    </h2>
    <div class="relative flex flex-wrap gap-8 z-1">
      <div
        v-for="(color, index) in colorInputs"
        :key="index"
      >
        <p class="text-sm text-temporary-gray-500">
          {{ color.label }}
        </p>
        <PluttoColorInput
          v-model="color.value"
        />
      </div>
    </div>
    <div class="flex">
      <div
        id="plutto-subs-widget"
        class="flex-1 send-to-background"
      />
      <AddPlan @add-plan="showSlideOver" />
    </div>
    <h2 class="text-2xl">
      Code
    </h2>
    <PluttoCopyableCode
      class="send-to-background"
      :code-string="formatCodeString()"
    />
    <PluttoSlideover
      :showing="showAddPlanSlideOver"
      @close="showAddPlanSlideOver = false"
    >
      <template #preview>
        <div
          id="plutto-subs-widget"
          class="mx-auto"
        />
      </template>
      <template #content>
        <PlanForm
          v-model="formData"
          @created-permission-group="reloadGroups"
        />
      </template>
    </PluttoSlideover>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoColorInput from '@/components/widget/plutto-color-input';
import PluttoCopyableCode from '@/components/widget/plutto-copyable-code';
import AddPlan from '@/components/widget/add-plan';
import PluttoSlideover from '@/components/widget/plutto-slideover';
import PlanForm from '@/components/widget/plan-form';
import codeString from '@/utils/widget/code';

export default {
  components: {
    PluttoColorInput,
    PluttoCopyableCode,
    AddPlan,
    PluttoSlideover,
    PlanForm,
  },
  data() {
    return {
      colorInputs: [
        { key: 'background', label: 'Background', value: '#FFFFFF' },
        { key: 'text', label: 'Text', value: '#304378' },
        { key: 'titleText', label: 'Title text', value: '#FFFFFF' },
        { key: 'primary', label: 'Primary gradient', value: '#304378' },
        { key: 'secondary', label: 'Secondary gradient', value: '#E06B71' },
      ],
      showAddPlanSlideOver: false,
      formData: {
        name: '',
        price: '',
        permissions: [],
      },
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSION_GROUPS');
    window.plutto('init', { permissionGroups: this.permissionGroups });
  },
  computed: {
    ...mapState({
      permissionGroups: state => state.permissionGroups.permissionGroups,
    }),
  },
  methods: {
    updateTheme() {
      window.plutto(
        'widget-event',
        {
          name: 'update-theme',
          data: this.colorInputs.reduce((acc, { key, value }) => ({ ...acc, [key]: value }), {}),
        },
      );
    },
    updateData(permissionGroups) {
      window.plutto(
        'widget-event',
        {
          name: 'update-permission-groups',
          data: permissionGroups,
        },
      );
    },
    formatCodeString() {
      return codeString();
    },
    showSlideOver() {
      this.showAddPlanSlideOver = true;
    },
    async reloadGroups() {
      await this.$store.dispatch('GET_PERMISSION_GROUPS');
      this.updateData(this.permissionGroups);
      this.showAddPlanSlideOver = false;
    },
  },
  watch: {
    colorInputs: {
      handler() {
        this.updateTheme();
      },
      deep: true,
    },
    formData: {
      handler() {
        this.updateData([this.formData]);
      },
      deep: true,
    },
  },
};
</script>
<style scoped>
.send-to-background {
  position: relative;
  z-index: -1 !important;
}
</style>

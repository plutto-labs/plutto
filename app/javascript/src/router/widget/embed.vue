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
    <div class="flex justify-center">
      <!-- <div id="plutto-subs-widget" /> -->
      <AddPlan @add-plan="showSlideOver" />
    </div>
    <h2 class="text-2xl">
      Code
    </h2>
    <PluttoCopyableCode
      class="code"
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
        <PlanForm v-model="formData" />
      </template>
    </PluttoSlideover>
  </main>
</template>
<script>
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
      showAddPlanSlideOver: true,
      formData: {
        name: '',
        price: '',
        permissions: [],
      },
    };
  },
  beforeMount() {
    window.plutto('init', { permissionGroups: [this.formData] });
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
    updateData() {
      window.plutto(
        'widget-event',
        {
          name: 'update-permission-groups',
          data: [this.formData],
        },
      );
    },
    formatCodeString() {
      return codeString('APIIIIIIII');
    },
    showSlideOver() {
      this.showAddPlanSlideOver = true;
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
        this.updateData();
      },
      deep: true,
    },
  },
};
</script>
<style scoped>
.code {
  position: relative;
  z-index: -1 !important;
}
</style>

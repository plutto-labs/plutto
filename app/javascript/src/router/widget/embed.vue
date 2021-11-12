<template>
  <main class="flex flex-col gap-8">
    <div class="flex items-center justify-between">
      <h2 class="text-2xl">
        Design
      </h2>
      <div
        class="text-white btn btn--filled bg-temporary-primary hover:bg-temporary-primary hover:opacity-80 focus:bg-temporary-primary"
        @click="showSlideOver"
      >
        Add Plan
      </div>
    </div>
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
      <div class="relative w-40 h-8">
        <p class="text-sm text-temporary-gray-500">
          Button text
        </p>
        <input
          class="pl-4 plutto-input__input text-temporary-gray-500 focus:border-temporary-primary"
          v-model="buttonText"
        >
      </div>
    </div>
    <div
      id="plutto-subs-widget"
      class="send-to-background"
    />
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
          id="plutto-card-widget"
          class="mx-auto"
        />
      </template>
      <template #content>
        <PlanForm
          v-model="formData"
          :editing-permission-group="editingPermissionGroup"
          :theme="theme"
          @created-permission-group="closeSlideOver"
          @deleted-permission-group="closeSlideOver"
        />
      </template>
    </PluttoSlideover>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoColorInput from '@/components/widget/plutto-color-input';
import PluttoCopyableCode from '@/components/widget/plutto-copyable-code';
import PluttoSlideover from '@/components/widget/plutto-slideover';
import PlanForm from '@/components/widget/plan-form';
import codeString from '@/utils/widget/code';
import debounce from 'lodash.debounce';

export default {
  components: {
    PluttoColorInput,
    PluttoCopyableCode,
    PluttoSlideover,
    PlanForm,
  },
  data() {
    return {
      colorInputs: [
        { key: 'backgroundColor', label: 'Background', value: '#FFFFFF' },
        { key: 'textColor', label: 'Text', value: '#304378' },
        { key: 'titleTextColor', label: 'Title', value: '#FFFFFF' },
        { key: 'primaryColor', label: 'Primary gradient', value: '#304378' },
        { key: 'secondaryColor', label: 'Secondary gradient', value: '#E06B71' },
      ],
      buttonText: 'Subscribe',
      showAddPlanSlideOver: false,
      formData: {
        name: '',
        price: '',
        permissions: [],
      },
      editingPermissionGroup: null,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSION_GROUPS');
  },
  mounted() {
    window.plutto('init', { permissionGroups: this.permissionGroups, theme: this.theme });

    this.colorInputs.forEach((color) => {
      if (this.widgetSettings[color.key]) color.value = this.widgetSettings[color.key];
    });
    if (this.widgetSettings.buttonText) this.buttonText = this.widgetSettings.buttonText;

    document.getElementById('plutto-subs-widget').addEventListener('edit-permission-group', (data) => {
      this.editCard(data.detail.id);
    });
  },
  beforeUnmount() {
    document.getElementById('plutto-subs-widget').removeEventListener('edit-permission-group', this.editCard);
  },
  computed: {
    ...mapState({
      permissionGroups: state => state.permissionGroups.permissionGroups,
      organization: store => store.organization,
      widgetSettings: store => store.organization.widgetSettings,
    }),
    theme() {
      return {
        ...this.colorInputs.reduce((acc, { key, value }) => ({ ...acc, [key]: value }), {}),
        buttonText: this.buttonText,
      };
    },
  },
  methods: {
    updateTheme() {
      window.plutto(
        'widget-event',
        {
          name: 'update-theme',
          data: this.theme,
        },
      );
      this.updateWidgetSettings();
    },
    updateData(string, permissionGroups) {
      window.plutto(
        'widget-event',
        {
          widgetId: string,
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
    closeSlideOver() {
      this.showAddPlanSlideOver = false;
      this.editingPermissionGroup = {};
      this.formData = {
        name: '',
        price: '',
        permissions: [],
      };
    },
    updateWidgetSettings: debounce(function () {
      this.$store.dispatch('UPDATE_ORGANIZATION', { ...this.organization, widgetSettings: this.theme });
    // eslint-disable-next-line no-magic-numbers
    }, 1000),
    editCard(id) {
      this.editingPermissionGroup = this.permissionGroups.find(group => group.id === id);
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
    buttonText: {
      handler() {
        this.updateTheme();
      },
    },
    formData: {
      handler() {
        this.updateData('plutto-card-widget', [this.formData]);
      },
      deep: true,
    },
    permissionGroups: {
      handler() {
        this.updateData('plutto-subs-widget', [...this.permissionGroups]);
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

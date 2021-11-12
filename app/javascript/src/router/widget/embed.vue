<template>
  <main class="flex flex-col gap-8">
    <div class="flex items-center justify-between">
      <h2 class="text-2xl">
        Design
      </h2>
      <div
        class="btn btn--filled"
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
        <p class="text-sm text-gray-400">
          {{ color.label }}
        </p>
        <PluttoColorInput
          v-model="color.value"
          :undo="colorChanged(color)"
          @undo="undoColor(color)"
        />
      </div>
      <div class="relative w-40 h-8">
        <p class="text-sm text-gray-400">
          Button text
        </p>
        <input
          class="pl-4 text-gray-400 plutto-input__input focus:border-primary"
          v-model="buttonText"
        >
      </div>
      <button
        v-if="themeChanged()"
        class="h-8 mt-5 text-white btn btn-filled bg-success hover:bg-success-light border-success focus:bg-success-light"
        @click="updateWidgetSettings()"
      >
        Save
      </button>
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
      @close="closeSlideOver"
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

    if (this.widgetsettings === undefined) this.updateWidgetSettings();

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
    updateWidgetSettings() {
      this.$store.dispatch('UPDATE_ORGANIZATION', { ...this.organization, widgetSettings: this.theme });
    // eslint-disable-next-line no-magic-numbers
    },
    editCard(id) {
      this.editingPermissionGroup = this.permissionGroups.find(group => group.id === id);
      this.showAddPlanSlideOver = true;
    },
    colorChanged(color) {
      return (color.value !== this.widgetSettings[color.key]);
    },
    undoColor(color) {
      color.value = this.widgetSettings[color.key];
      this.updateTheme();
    },
    themeChanged() {
      return this.colorInputs.some(color => this.colorChanged(color)) ||
        this.buttonText !== this.widgetSettings.buttonText;
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

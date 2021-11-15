
<template>
  <div>
    <div class="relative flex flex-wrap gap-8 z-1">
      <div
        v-for="(color, index) in colorInputs"
        :key="index"
      >
        <p class="text-sm text-gray-400">
          {{ color.label }}
        </p>
        <PluttoColorInput
          class="send-to-front"
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
    </div>
    <div
      id="plutto-subs-widget"
      class="send-to-background"
    />
  </div>
</template>
<script>
import PluttoColorInput from '@/components/widget/plutto-color-input';

export default {
  components: {
    PluttoColorInput,
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
      widgetSettings: {
        backgroundColor: '#FFFFFF',
        textColor: '#304378',
        titleTextColor: '#FFFFFF',
        primaryColor: '#304378',
        secondaryColor: '#E06B71',
        buttonText: 'Subscribe',
      },
      buttonText: 'Get your widget!',
      permissionGroups: [
        {
          name: 'Free',
          price: '0',
          currency: 'USD',
          permissions: [
            { limit: 100, name: 'subscriptions' },
            { limit: null, name: 'Charge your customers' },
          ],
        },
        {
          name: 'Startup',
          price: '29',
          currency: 'USD',
          permissions: [
            { limit: 1000, name: 'subscriptions' },
            { limit: null, name: 'Charge your customers' },
          ],
        },
        {
          name: 'Pro',
          price: '99',
          currency: 'USD',
          permissions: [
            { limit: null, name: 'All your subscriptions' },
            { limit: null, name: 'Charge your customers' },
          ],
        },
      ],
    };
  },
  methods: {
    colorChanged(color) {
      return (color.value !== this.widgetSettings[color.key]);
    },
    undoColor(color) {
      color.value = this.widgetSettings[color.key];
      this.updateTheme();
    },
    updateTheme() {
      window.plutto(
        'widget-event',
        {
          name: 'update-theme',
          data: this.theme,
        },
      );
    },
  },
  mounted() {
    window.plutto('init', { permissionGroups: this.permissionGroups, theme: this.theme });
  },
  computed: {
    theme() {
      return {
        ...this.colorInputs.reduce((acc, { key, value }) => ({ ...acc, [key]: value }), {}),
        buttonText: this.buttonText,
      };
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
  },
};
</script>
<style scoped>
.send-to-background {
  position: relative;
  z-index: 0 !important;
}

.send-to-front {
  position: relative;
  z-index: 1 !important;
}
</style>

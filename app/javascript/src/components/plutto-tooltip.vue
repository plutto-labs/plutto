<template>
  <div
    @mouseover="onHover"
    @mouseout="show = false"
  >
    <slot name="trigger" />
    <div
      class="absolute z-10 flex flex-col mr-2"
      v-if="show"
    >
      <span
        class="w-2 h-2 ml-2 origin-bottom-left transform rotate-45 bg-gray-600"
        :class="{'bg-danger-light': background === 'danger'}"
      />
      <div
        class="px-3 py-1 bg-gray-600 rounded"
        :class="{'bg-danger-light': background === 'danger'}"
      >
        <slot name="content" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    background: {
      type: String,
      default: 'normal',
    },
  },
  data() {
    return {
      show: false,
    };
  },
  methods: {
    onHover() {
      this.show = true;
    },
  },
};
</script>

<template>
  <div>
    <div
      class="flex items-center justify-between cursor-pointer"
      @click.prevent.stop="e => copyToClipboard(e, value)"
    >
      <p class="max-w-xs break-words sm:max-w-sm md:max-w-md">
        {{ value }}
      </p>
      <span
        v-if="value"
        class="ml-1 cursor-pointer fill-current text-primary plutto-icon"
        @click.prevent
      >
        content_copy
      </span>
    </div>
    <div
      v-show="copied"
      ref="copyNotification"
      class="fixed text-primary"
    >
      Copied!
    </div>
  </div>
</template>

<script>
import copy from '@/utils/copy-to-clipboard';

const SHOW_TIME = 1000;

export default {
  props: {
    value: {
      type: String || Number,
      required: true,
    },
  },
  data() {
    return {
      copied: false,
    };
  },
  methods: {
    copyToClipboard(e, value = null) {
      copy(value || e.target.innerText);
      this.showCopiedNotification(event);
    },
    showCopiedNotification(event) {
      if (this.copied) return;
      this.copied = true;
      const clickOffset = 15;
      const element = this.$refs.copyNotification;
      element.style.top = `${event.clientY + clickOffset}px`;
      element.style.left = `${event.clientX - clickOffset}px`;
      window.setTimeout(() => {
        this.copied = false;
      }, SHOW_TIME);
    },
  },
};
</script>

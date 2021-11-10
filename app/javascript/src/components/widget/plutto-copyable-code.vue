<template>
  <div class="relative z-0">
    <div
      class="relative z-0 cursor-pointer"
      @click.prevent.stop="e => copyToClipboard(e, codeString)"
    >
      <CodeEditor
        id="code-box"
        :value="codeString"
        font_size="12px"
        border_radius="6px"
        :width="boxWidth"
        :hide_header="true"
        :read_only="true"
        z_index="0"
      />
      <span
        class="absolute top-0 right-0 m-1 text-white plutto-icon"
        @click.prevent
      >
        content_copy
      </span>
    </div>
    <div
      v-show="copied"
      ref="copyNotification"
      class="absolute top-0 flex items-center justify-center w-full h-full text-2xl bg-white rounded-md opacity-70 text-temporary-primary"
    >
      Copied!
    </div>
  </div>
</template>
<script>
import CodeEditor from 'simple-code-editor';
import copy from '@/utils/copy-to-clipboard';

const SHOW_TIME = 1000;

export default {
  props: {
    codeString: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      copied: false,
    };
  },
  components: {
    CodeEditor,
  },
  methods: {
    copyToClipboard(e, value = null) {
      copy(value || e.target.innerText);
      this.showCopiedNotification();
    },
    showCopiedNotification() {
      if (this.copied) return;
      this.copied = true;
      window.setTimeout(() => {
        this.copied = false;
      }, SHOW_TIME);
    },
    boxWidth() {
      return document.getElementById('code-box').parentElement.clientWidth;
    },
  },
};
</script>

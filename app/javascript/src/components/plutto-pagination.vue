<template>
  <div class="flex items-center justify-end space-x-4">
    <button
      id="previous-button"
      class="btn"
      v-if="currentPage !== 1"
      @click="previousPage"
    >
      {{ $t('message.table.pagination.previous') }}
    </button>
    <div
      class="btn"
      v-if="currentPage > 1"
    >
      {{ currentPage }}
    </div>
    <button
      id="next-button"
      class="btn"
      @click="nextPage"
      v-if="currentPage === 0 || currentPage < totalPages"
    >
      {{ $t('message.table.pagination.next') }}
    </button>
  </div>
</template>

<script>
export default {
  props: {
    showing: {
      required: true,
      type: Boolean,
    },
    totalPages: {
      required: true,
      type: Number,
    },
  },
  data() {
    return {
      currentPage: 1,
    };
  },
  methods: {
    previousPage() {
      this.currentPage -= 1;
      this.changePage();
    },
    nextPage() {
      this.currentPage += 1;
      this.changePage();
    },
    goToPage(page) {
      this.currentPage = page;
      this.changePage();
    },
    changePage() {
      this.$emit('change-page', this.currentPage);
    },
  },
};
</script>

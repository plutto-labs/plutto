<template>
  <main class="space-y-8">
    <h1
      class="text-2xl"
    >
      Settings
    </h1>
    <div class="flex items-center gap-4">
      <h3 class="text-lg">
        API Key:
      </h3>
      <PluttoCopyableDiv
        class="px-3 py-2 border rounded-md"
        :value="publicApiKey"
      />
    </div>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: {
    PluttoCopyableDiv,
  },
  computed: {
    ...mapState({
      organizationName: state => state.organization.name,
      publicApiKey: state => state.organization.publicApiKey,
    }),
  },
};
</script>

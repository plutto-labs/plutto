<script>
export default {
  methods: {
    analyticsIdentify(userId, traits) {
      if (analytics) {
        analytics.identify(userId, traits);
      }
    },
    analyticsGroup(groupId, traits) {
      if (analytics) {
        analytics.group(groupId, traits);
      }
    },
  },
};
</script>

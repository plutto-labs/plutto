<script>
export default {
  methods: {
    invoiceStatusTags() {
      const tags = {
        created: 'purple',
        posted: 'blue',
        paid: 'green',
        notPaid: 'red',
        voided: 'yellow',
      };

      return tags;
    },
  },
};
</script>

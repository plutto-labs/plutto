<script>
import moment from 'moment';
import currencies from '../../../../config/currencies.json';

export default {
  data() {
    return {
      CURRENCIES: currencies,
      CURRENCY_KEYS: Object.keys(currencies),
    };
  },
  methods: {
    formatCurrency(val, currency = 'CLP') {
      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency }).format(val);
    },
    formatDateTime(date, utc = false) {
      if (!date) return date;
      if (utc) return moment(String(date)).utc().format('DD/MM/YYYY - HH:mm');

      return moment(String(date)).format('DD/MM/YYYY - HH:mm');
    },
    humanizedDuration(val, options = {}) {
      if (!val) return null;

      let humanDuration = moment.duration(val).humanize();

      if (options.removePrefix) humanDuration = humanDuration.substring(2);

      return humanDuration;
    },
  },
};
</script>

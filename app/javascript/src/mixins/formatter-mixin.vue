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
      if (val === null || currency === null) return null;

      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency }).format(val);
    },
    formatDateTime(date, utc = false) {
      if (!date) return date;
      if (utc) return moment(String(date)).utc().format('DD/MM/YYYY - HH:mm');

      return moment(String(date)).format('DD/MM/YYYY - HH:mm');
    },
    formatDate(date, utc = false) {
      if (!date) return date;
      if (utc) return moment(String(date)).utc().format('DD/MM/YYYY');

      return moment(String(date)).format('DD/MM/YYYY');
    },
    humanizedDuration(val, options = {}) {
      if (!val) return null;

      let humanDuration = moment.duration(val).humanize();

      if (options.removePrefix) humanDuration = humanDuration.substring(2);

      return humanDuration;
    },
    daysFromDate(date) {
      return moment(date).from(new Date());
    },
  },
};
</script>

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
    humanizedDuration(val) {
      return moment.duration(val).humanize();
    },
  },
};
</script>

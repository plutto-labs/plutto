import moment from 'moment';

export default function dateTime(value, utc = false) {
  if (value) {
    if (utc) return moment(String(value)).utc().format('DD/MM/YYYY - HH:mm');

    return moment(String(value)).format('DD/MM/YYYY - HH:mm');
  }

  return value;
}

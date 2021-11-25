function codeString(apikey) {
  const text = `<script>
  (function (w,d,s,o,f,js,fjs) {
      w['PluttoSubsWidget']=o;w[o] = w[o] || function () { (w[o].q = w[o].q || []).push(arguments) };
      js = d.createElement(s), fjs = d.getElementsByTagName(s)[0];
      js.id = o; js.src = f; js.async = 1; fjs.parentNode.insertBefore(js, fjs);
  }(window, document, 'script', 'plutto', 'https://p-widget.getplutto.com/widget.js'));

  window.plutto('init', { apiKey: '${apikey}' });
</script>`;

  return text;
}

export default codeString;

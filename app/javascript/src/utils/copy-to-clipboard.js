/* eslint-disable no-magic-numbers */

function isOS() {
  return navigator.userAgent.match(/ipad|iphone/i);
}

function createTextArea(text) {
  const textArea = document.createElement('textArea');
  textArea.value = text;
  document.body.appendChild(textArea);

  return textArea;
}

function selectText(textArea) {
  let range;
  let selection;

  if (isOS()) {
    range = document.createRange();
    range.selectNodeContents(textArea);
    selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    textArea.setSelectionRange(0, 999999);
  } else {
    textArea.select();
  }
}

function copyToClipboard(textArea) {
  document.execCommand('copy');
  document.body.removeChild(textArea);
}

function copy(text) {
  const textArea = createTextArea(text);
  selectText(textArea);
  copyToClipboard(textArea);
}

export default copy;

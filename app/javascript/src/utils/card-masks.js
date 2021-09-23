export const cardMasks = {
  mask: [
    {
      mask: '0000 0000 0000 0000',
      regex: '^(5[1-5]\\d{0,2}|22[2-9]\\d{0,1}|2[3-7]\\d{0,2})\\d{0,12}',
      cardtype: 'mastercard',
    },
    {
      mask: '0000 0000 0000 0000',
      regex: '^4\\d{0,15}',
      cardtype: 'visa',
    },
    {
      mask: '0000 0000 0000 0000',
      cardtype: 'Unknown',
    },
  ],
  dispatch(appended, dynamicMasked) {
    const number = (dynamicMasked.value + appended).replace(/\D/g, '');

    for (let i = 0; i < dynamicMasked.compiledMasks.length; i++) {
      const re = new RegExp(dynamicMasked.compiledMasks[i].regex);
      if (number.match(re) !== null) {
        return dynamicMasked.compiledMasks[i];
      }
    }

    return dynamicMasked;
  },
};

export const cvvMask = {
  mask: '0000',
};

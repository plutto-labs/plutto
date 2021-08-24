export default {
  message: {
    global: {
      name: 'Name',
      currency: 'Currency',
    },
    table: {
      headers: {
        info: 'Info',
        identifier: 'Identifier',
        planSubscription: 'Plan Subscription',
        none: '',
      },
    },
    meters: {
      types: {
        periodSum: 'Periodic sum',
        historySum: 'Historic sum',
      },
    },
    priceLogics: {
      types: {
        'PriceLogic::FlatFee': 'Flat Fee',
        'PriceLogic::PerUnit': 'Per Unit',
        'PriceLogic::StairStep': 'Stair Step',
        'PriceLogic::Tiered': 'Tiered',
        'PriceLogic::Volume': 'Volume',
      },
      initials: {
        'PriceLogic::FlatFee': 'FF',
        'PriceLogic::PerUnit': 'PU',
        'PriceLogic::StairStep': 'SS',
        'PriceLogic::Tiered': 'T',
        'PriceLogic::Volume': 'V',
      },
      descriptions: {
        'PriceLogic::FlatFee': 'Just a simple flat fee',
        'PriceLogic::PerUnit': 'Charge a fixed amount per event',
        'PriceLogic::StairStep': 'Charge a flat fee based on the corresponding tier',
        'PriceLogic::Tiered': 'Each event gets charged starting from the lowest tier',
        'PriceLogic::Volume': 'Charge a fixed amount per event based on the corresponding tier',
      },
    },
  },
};

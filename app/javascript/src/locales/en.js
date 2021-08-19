export default {
  message: {
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
    },
  },
};

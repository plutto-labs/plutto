export default {
  message: {
    global: {
      name: 'Name',
      country: 'Country',
      currency: 'Currency',
      price: 'Price',
    },
    table: {
      headers: {
        info: 'Info',
        id: 'Id',
        identifier: 'Identifier',
        pricing: 'Pricing',
        name: 'Name',
        customer: 'Customer',
        status: 'Status',
        currency: 'Currency',
        subtotal: 'Amount',
        issueDate: 'Issue Date',
        product: 'Products',
        gateway: 'Gateway',
        paymentMethod: 'Payment Method',
        paidAt: 'Paid At',
        previousInvoiceAmount: 'Previous billed amount',
        currentBillingPeriodEndDate: 'Next billing date',
        trialFinishesAt: 'Trial finishes at',
        none: '',
      },
      tags: {
        created: 'Created',
        posted: 'Posted',
        paid: 'Paid',
        notPaid: 'Not Paid',
        voided: 'Voided',
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
    invoices: {
      status: {
        created: 'Created',
        posted: 'Posted',
        paid: 'Paid',
        notPaid: 'Not Paid',
        voided: 'Voided',
      },
      events: {
        post: 'Post',
        charge: 'Charge',
        fail: 'Fail',
        void: 'Void',
      },
    },
  },
};

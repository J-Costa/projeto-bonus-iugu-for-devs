require 'securerandom'
class Invoice
  def self.all
    [
      { payment_method: 'Boleto',
        value: 1000.0,
        status: 'Pendente',
        due_date: '05-05-2021',
        token: SecureRandom.hex(5)
      },
      { payment_method: 'Pix',
        value: 1000.0,
        status: 'Pendente',
        due_date: '05-05-2021',
        token: SecureRandom.hex(5)
      },
      { payment_method: 'Cartão de crédito',
        value: 1000.0,
        status: 'Pendente',
        due_date: '05-05-2021',
        token: SecureRandom.hex(5)
      }
    ]
  end
end
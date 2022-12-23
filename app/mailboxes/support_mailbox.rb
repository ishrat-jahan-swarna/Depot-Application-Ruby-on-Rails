class SupportMailbox < ApplicationMailbox
  def process
    puts "checking mailbox: #{mail}"
    recent_order = Order.where(email: mail.from).
                         order('created_at desc').
                         first
    puts "recent order: #{recent_order}"

    puts "mail #{mail.from}"
    SupportRequest.create!(
      email:   mail.from,
      subject: mail.subject,
      body:    mail.body.to_s,
      order:   recent_order
    )
  end
end
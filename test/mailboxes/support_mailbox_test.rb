require "test_helper"
require "mail"
class SupportMailboxTest < ActionMailbox::TestCase
  # test "receive mail" do
  #   receive_inbound_email_from_mail \
  #     to: '"someone" <someone@example.com>',
  #     from: '"else" <else@example.com>',
  #     subject: "Hello world!",
  #     body: "Hello?"
  # end
  test "we create a SupportRequest when we get a support email" do
    receive_inbound_email_from_mail(
      to: "support@example.com",
      from: "chris@somewhere.net",
      subject: "Need help",
      body: "I can't figure out how to check out!!"
    )
    support_request = SupportRequest.last
    a = support_request.email.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |x| puts x } 
    puts a
    assert_equal "chris@somewhere.net", JSON.parse(support_request.email)[0]
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body
    assert_nil support_request.order
  end

  test "we create a SupportRequest with the most recent order" do
    recent_order = orders(:one)
    older_order  = orders(:another_one)
    non_customer = orders(:other_customer)

    receive_inbound_email_from_mail(
      to: "support@example.com",
      from: recent_order.email,
      subject: "Need help",
      body: "I can't figure out how to check out!!"
    )
    support_request = SupportRequest.last
    a = support_request.email.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |x| puts x } 
    puts a
    assert_equal recent_order.email, JSON.parse(support_request.email)[0]
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body
    assert_equal recent_order, support_request.order
  end
end

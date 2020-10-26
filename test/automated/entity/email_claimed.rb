require_relative '../automated_init'

context "Registration" do
  context "Has Email Claimed Time" do
    registration = Controls::Registration::EmailClaimed.example

    test "Is email_claimed" do
      assert(registration.email_claimed?)
    end
  end

  context "Does not Have Email Claimed Time" do
    registration = Controls::Registration.example

    test "Is not email_claimed" do
      refute(registration.email_claimed?)
    end
  end
end

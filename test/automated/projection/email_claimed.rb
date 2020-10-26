require_relative '../automated_init'

context "Projection" do
  context "Email Claimed" do
    registration = Controls::Registration::New.example

    assert(registration.email_claimed_time.nil?)

    projection = Projection.build(registration)
    email_claimed = Controls::Events::EmailClaimed.example

    fixture(
      EntityProjection::Fixtures::Projection,
      projection,
      email_claimed
    ) do |fixture|
      fixture.assert_attributes_copied(:registration_id => :id)
      fixture.assert_transformed_and_copied(:time => :email_claimed_time) { |v| Time.parse(v) }
    end
  end
end

require_relative '../automated_init'

context "Projection" do
  context "Email Rejected" do
    registration = Controls::Registration::New.example

    assert(registration.email_rejected_time.nil?)

    projection = Projection.build(registration)
    email_rejected = Controls::Events::EmailRejected.example

    fixture(
      EntityProjection::Fixtures::Projection,
      projection,
      email_rejected
    ) do |fixture|
      fixture.assert_attributes_copied(:registration_id => :id)
      fixture.assert_transformed_and_copied(:time => :email_rejected_time) { |v| Time.parse(v) }
    end
  end
end

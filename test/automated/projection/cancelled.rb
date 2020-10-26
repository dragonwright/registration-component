require_relative '../automated_init'

context "Projection" do
  context "Cancelled" do
    registration = Controls::Registration::New.example

    assert(registration.cancelled_time.nil?)

    projection = Projection.build(registration)
    cancelled = Controls::Events::Cancelled.example

    fixture(
      EntityProjection::Fixtures::Projection,
      projection,
      cancelled
    ) do |fixture|
      fixture.assert_attributes_copied(:registration_id => :id)
      fixture.assert_transformed_and_copied(:time => :cancelled_time) { |v| Time.parse(v) }
    end
  end
end

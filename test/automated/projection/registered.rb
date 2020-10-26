require_relative '../automated_init'

context "Projection" do
  context "Registered" do
    registration = Controls::Registration::New.example

    assert(registration.registered_time.nil?)

    projection = Projection.build(registration)
    registered = Controls::Events::Registered.example

    fixture(
      EntityProjection::Fixtures::Projection,
      projection,
      registered
    ) do |fixture|
      fixture.assert_attributes_copied(:registration_id => :id)
      fixture.assert_transformed_and_copied(:time => :registered_time) { |v| Time.parse(v) }
    end
  end
end

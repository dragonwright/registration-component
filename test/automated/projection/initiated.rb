require_relative '../automated_init'

context "Projection" do
  context "Initiated" do
    registration = Controls::Registration::New.example

    assert(registration.initiated_time.nil?)

    projection = Projection.build(registration)
    initiated = Controls::Events::Initiated.example

    fixture(
      EntityProjection::Fixtures::Projection,
      projection,
      initiated
    ) do |fixture|
      fixture.assert_attributes_copied([
        { :registration_id => :id },
        :player_id,
        :email_address
      ])

      fixture.assert_transformed_and_copied(:time => :initiated_time) { |v| Time.parse(v) }
    end
  end
end

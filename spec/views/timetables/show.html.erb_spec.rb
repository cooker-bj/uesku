require 'spec_helper'

describe "timetables/show" do
  before(:each) do
    @timetable = assign(:timetable, stub_model(Timetable,
      :creator_id => 1,
      :title => "Title",
      :description => "MyText",
      :lesson_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/2/)
  end
end

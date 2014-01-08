require 'spec_helper'

describe "timetables/edit" do
  before(:each) do
    @timetable = assign(:timetable, stub_model(Timetable,
      :creator_id => 1,
      :title => "MyString",
      :description => "MyText",
      :lesson_id => 1
    ))
  end

  it "renders the edit timetable form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", timetable_path(@timetable), "post" do
      assert_select "input#timetable_creator_id[name=?]", "timetable[creator_id]"
      assert_select "input#timetable_title[name=?]", "timetable[title]"
      assert_select "textarea#timetable_description[name=?]", "timetable[description]"
      assert_select "input#timetable_lesson_id[name=?]", "timetable[lesson_id]"
    end
  end
end

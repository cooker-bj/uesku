require 'spec_helper'

describe "places/edit" do
  before(:each) do
    @place = assign(:place, stub_model(Place,
      :title => "MyString",
      :street => "MyString",
      :province_id => 1,
      :city_id => 1,
      :district_id => 1,
      :website => "MyString",
      :description => "MyText",
      :recommendation => "MyText",
      :price => "MyString",
      :opening_hours => "MyString",
      :positionx => "MyString",
      :positiony => "MyString",
      :direction => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit place form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", place_path(@place), "post" do
      assert_select "input#place_title[name=?]", "place[title]"
      assert_select "input#place_street[name=?]", "place[street]"
      assert_select "input#place_province_id[name=?]", "place[province_id]"
      assert_select "input#place_city_id[name=?]", "place[city_id]"
      assert_select "input#place_district_id[name=?]", "place[district_id]"
      assert_select "input#place_website[name=?]", "place[website]"
      assert_select "textarea#place_description[name=?]", "place[description]"
      assert_select "textarea#place_recommendation[name=?]", "place[recommendation]"
      assert_select "input#place_price[name=?]", "place[price]"
      assert_select "input#place_opening_hours[name=?]", "place[opening_hours]"
      assert_select "input#place_positionx[name=?]", "place[positionx]"
      assert_select "input#place_positiony[name=?]", "place[positiony]"
      assert_select "input#place_direction[name=?]", "place[direction]"
      assert_select "input#place_phone[name=?]", "place[phone]"
    end
  end
end

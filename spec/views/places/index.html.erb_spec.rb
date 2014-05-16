require 'spec_helper'

describe "places/index" do
  before(:each) do
    assign(:places, [
      stub_model(Place,
        :title => "Title",
        :street => "Street",
        :province_id => 1,
        :city_id => 2,
        :district_id => 3,
        :website => "Website",
        :description => "MyText",
        :recommendation => "MyText",
        :price => "Price",
        :opening_hours => "Opening Hours",
        :positionx => "Positionx",
        :positiony => "Positiony",
        :direction => "Direction",
        :phone => "Phone"
      ),
      stub_model(Place,
        :title => "Title",
        :street => "Street",
        :province_id => 1,
        :city_id => 2,
        :district_id => 3,
        :website => "Website",
        :description => "MyText",
        :recommendation => "MyText",
        :price => "Price",
        :opening_hours => "Opening Hours",
        :positionx => "Positionx",
        :positiony => "Positiony",
        :direction => "Direction",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of places" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Price".to_s, :count => 2
    assert_select "tr>td", :text => "Opening Hours".to_s, :count => 2
    assert_select "tr>td", :text => "Positionx".to_s, :count => 2
    assert_select "tr>td", :text => "Positiony".to_s, :count => 2
    assert_select "tr>td", :text => "Direction".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
